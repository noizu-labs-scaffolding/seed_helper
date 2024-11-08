defmodule SeedHelper do

  @doc """
  Set a handle to a value for reference by other seeds.
  """
  def set_handle(handle, value) do
    SeedHelper.Handles.set_handle(handle, value)
  end

  @doc """
  Get a handle to a value for use in seeds (like default_organization_id)
  """
  def handle(handle, default \\ nil) do
    SeedHelper.Handles.handle(handle, default)
  end

  @doc """
  Begin a seeding session. This should be called in your priv/migrations/seed.exs file.
  """
  def begin_session() do
    SeedHelper.Session.begin_session()
  end

  @doc """
  End a seeding session. This should be called in your priv/migrations/seed.exs file.
  """
  def end_session() do
    SeedHelper.Session.end_session()
  end

  @doc """
  Macro to conditionally execute a block of code based on the current build environment
  """
  defmacro if_env(env_or_envs, [do: block]) do
    if env_or_envs == [] do
      quote do
        unquote(block)
      end
    else
      quote do
        case unquote(env_or_envs) do
          [] -> true
          env when  is_atom(env) -> Mix.env() == env
          envs when is_list(envs) -> Enum.member?(envs, Mix.env())
        end
        |> if do
             unquote(block)
           end
      end
    end
  end

  @doc """
  Queue block until all required seeds have been applied.
  """
  defmacro requires_seed(seed_or_seeds, [do: block]) do
    quote do
      lambda = fn ->
        unquote(block)
      end
      cond do
        is_list(unquote(seed_or_seeds)) -> unquote(seed_or_seeds)
        :else -> [unquote(seed_or_seeds)]
      end
      |> Enum.reject(&SeedHelper.Seeds.executed?/1)
      |> case do
           [] -> lambda.()
           seeds -> SeedHelper.Session.await_seed(seeds, lambda)
         end
    end
  end

  @doc """
  Execute block if seed has not been applied yet (and build env in `options[:only]` if set)
  """
  defmacro seed(seed, options \\ [], [do: block]) do
    restrict = options[:only]
    run_seed = quote do
      seed_key = unquote(seed)
      unless SeedHelper.Seeds.executed?(seed_key) do
        unquote(block)
        IO.puts "[#{inspect seed_key}] Executed"
        SeedHelper.Seeds.mark_executed(seed_key)
        SeedHelper.Session.mark_applied(seed_key)
        |> Enum.map(& apply(&1, []))
      else
        IO.puts "[#{inspect seed_key}] Already Applied"
        SeedHelper.Session.mark_applied(seed_key)
        |> Enum.map(& apply(&1, []))
      end
    end

    if restrict do
      quote do
        SeedHelper.if_env(unquote(restrict)) do
          unquote(run_seed)
        end
      end
    else
      run_seed
    end
  end

end

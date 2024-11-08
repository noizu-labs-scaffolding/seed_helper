
defmodule SeedHelper.Handles do
  @repo Application.compile_env!(:seed_helper, :repo)
  @cache SeedHelper.Handles.Cache
  alias SeedHelper.Schema.Handles

  def init() do
    :ets.new(@cache, [:public, :set, :named_table, read_concurrency: true])
  end

  @doc """
  Set handle to value (which will be erlang term encoded) for reference by other seeds.
  iex> set_handle("default_user", 1234)
  :ok
  """
  def set_handle(handle, value) do
    encode_value = :erlang.term_to_binary(value) |> Base.encode64()
    handles = %Handles{handle: handle, value: encode_value}
    apply(@repo, :insert!, [
      handles,
      [
        on_conflict: [set: [handle: handle, value: encode_value, updated_at: DateTime.utc_now()]],
        conflict_target: [:handle]
      ]
    ]
    )
    |> case do
         %Handles{} ->
           set_handle_cache(handle, value, if_exists: true)
           :ok
         {:error, _} -> {:error, "Failed to set handle"}
       end
  end

  defp set_handle_cache(handle, value, opts \\ nil) do
    if opts[:if_exists] do
      unless :ets.lookup(@cache, handle) == [] do
        :ets.insert(@cache, {handle, value})
      end
    else
      :ets.insert(@cache, {handle, value})
    end
  end

  @doc """
  Get cached handle by name.

  iex> get_handle("default_user_code", 555)
  iex> get_handle("default_user_code")
  555

  iex> get_handle("default_user_code_not_set", :not_set)
  :not_set
  """
  def handle(handle, default \\ nil) do
    case get_handle_cache(handle) do
      {:ok, {__MODULE__, :cache_miss}} -> default
      {:ok, value} ->
        value
      _ ->
        case apply(@repo, :get, [Handles, handle]) do
          %{value: value} ->
            value = value
                    |> Base.decode64!()
                    |> :erlang.binary_to_term()
            set_handle_cache(handle, value)
            value
          _ ->
            set_handle_cache(handle, {__MODULE__, :cache_miss})
            default
        end
    end
  end

  defp get_handle_cache(handle) do
    case :ets.lookup(@cache, handle) do
      [{_, value}|_] -> {:ok, value}
      _ -> :cache_miss
    end
  end

end


defmodule SeedHelper.Session do
  @agent SeedHelper.Session.Agent

  @doc """
  Initialize Seeding Session (call in your priv/migrations/seed.exs file.
  """
  def begin_session() do
    SeedHelper.Handles.init()
    Agent.start_link(
      fn ->
        %{
          # Seeds applied
          applied: MapSet.new([]),
          # %{change_id => change_lambda}
          changes: %{},
          # %{change_id => [waiting_for_seed]}
          changes_pending: %{},
          # changes waiting on seed
          # %{seed => [change_ids]}
          pending_seed: %{}
        }
      end,
      name: @agent
    )
  end

  @doc """
  Close session and return list of any unapplied/blocked changes.
  """
  def end_session() do
    pending = Agent.get(@agent, & &1.changes_pending)
              |> Map.to_list()
    Agent.stop(@agent)
    unless pending == [] do
      {:error, {:unprocessed_changes, pending}}
    else
      :ok
    end
  end

  # Returns {change_id, [pending_seeds]}
  defp list_changes_pending_seed(seed, state) do
    (state.pending_seed[seed] || [])
    |> Enum.map(& {&1, (state.changes_pending[&1] || []) -- [seed]})
  end

  defp unblocked_changes(pending_seed_list, state) do
    pending_seed_list
    |> Enum.map(
         fn
           {key, []} -> state.changes[key]
           {_,_} -> nil
         end
       ) |> Enum.reject(&is_nil/1)
  end

  defp mark_seed_applied(state, seed) do
    state
    |> put_in([:applied],
         MapSet.put(state.applied, seed))
  end

  defp update_pending_changes(state, pending_seed_list) do
    changes = pending_seed_list
              |> Enum.reduce(state.changes,
                   fn
                     {key, []}, acc -> Map.delete(acc, key)
                     _, acc -> acc
                   end
                 )
    changes_pending = pending_seed_list
                      |> Enum.reduce(state.changes_pending,
                           fn
                             ({key, []}, acc) -> Map.delete(acc, key)
                             ({key, required}, acc) -> Map.put(acc, key, required)
                           end
                         )
    %{state| changes: changes, changes_pending: changes_pending}
  end

  defp clear_pending_seed_list(state, seed) do
    state
    |> pop_in([:pending_seed, seed])
    |> elem(1)
  end


  def mark_applied(seed, opts \\ nil)
  def mark_applied(seed = {_, _}, _) do
    Agent.get_and_update(@agent, fn state ->
      changes_pending_seed = list_changes_pending_seed(seed, state)
      available = unblocked_changes(changes_pending_seed, state)
      state = state
              |> mark_seed_applied(seed)
              |> clear_pending_seed_list(seed)
              |> update_pending_changes(changes_pending_seed)
      {available, state}
    end
    )
  end


  defp change_key(change)
  defp change_key(_) do
    UUID.uuid4()
  end


  def await_seed(seeds, change) when is_tuple(seeds) do
    await_seed([seeds], change)
  end
  def await_seed(seeds, change) when is_list(seeds) do
    Agent.update(@agent, fn state ->
      change_key = change_key(change)
      register_pending_seed = seeds
                              |> Enum.reduce(state.pending_seed, &(Map.put(&2, &1, (&2[&1] || []) ++ [change_key])))
      state
      |> put_in([:changes, change_key], change)
      |> put_in([:changes_pending, change_key], seeds)
      |> put_in([:pending_seed], register_pending_seed)
    end)
  end

end

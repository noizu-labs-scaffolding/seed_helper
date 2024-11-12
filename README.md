SeedHelper
===========

SeedHelper provides some simple schem and utilities for supporting incremental seeding of data in Ecto with out requiring a full 
teardown/setup to obtain consistent data sets.

# Features

## Track versioned seed sections
Run a seed only if it has not already been applied to current database.

```elixir
require SeedHelper
import SeedHelper

seed({"MySeed", "1"}) do
  IO.puts "Seeding database..."
  # Write data here.
end
```
## Specify seed dependencies.
Wait until required Seed.Version has been applied before executing block.

```elixir
require SeedHelper
import SeedHelper

requires_seed({"MySeed", "2"}) do
  seed({"MySeed", "1"}) do
    IO.puts "Seeding database... 1"
  end
end

# Seed 1 will be queued into an agent until {"MySeed"",2} has executed. 
seed({"MySeed", "2"}) do
  IO.puts "Seeding database... 2"
end
```
## Specify environment dependencies.
Only apply seeds in test environments, prod, dev, etc. 

```elixir
require SeedHelper
import SeedHelper

if_env([:prod,:stage]) do
  IO.puts "Running in production or staging environment"
   seed({"MySeed", "1"}) do
    IO.puts "Seeding database... 1"
  end 
end

if_env(:test) do 
  IO.puts "Running in test environment"
  requires_seed({"MySeed", "Core"}) do
    seed({"MySeed", "test-data"}) do
      IO.puts "Seeding database... test-data"
    end
  end
end

seed({"MySeed", "stuff"}) do
  IO.puts "Seeding database... stuff"
  if_env(:test) do
    IO.puts "Test Specific Stuff"
  end
end

```

## Set and Lookup handles
This is useful when inserted data used generated ids but needs to be referenced by other seeds.
handles are stored to the SeedHelper.Schema.Handles (seed_helpers_handles) table
but loaded/fetched during session from an etc cache to avoid perf issues with large data sets/frequent look ups.

```elixir
require SeedHelper
import SeedHelper

seed({"MySeed", "core"}) do
    IO.puts "Seeding database... core"
    # Save some record with dynamic id.
    set_handle("record.id", record.id)
end

# .
# .
# .

seed({"MySeed", "links"}) do
    record_id = get_handle("record.id", :or_apple_if_nil)
    # Save record referencing record_id    
end

```

# Setup 

1. Add SeedHelper to your mix.exs file.
    
    ```elixir
    defp deps do
      [
        {:seed_helper, "~> 0.1.0"}
      ]
    end
    ```
2. Set config.exs set repo for seed helper. 

    ```elixir
    config :seed_helper, repo: MyApp.Repo
    ```
3. Setup migration
 
    Run:
    ``` 
    mix ecto.gen.migration setup_seed_helper 
    ```
    
    # Edit migration file:
    ```
    defmodule MyApp.Repo.Migrations.SetupSeedHelper do
      use Ecto.Migration

      def up() do 
        SeedHelper.Migrate.up(1)
      end
   
      def down() do 
        SeedHelper.Migrate.down(1)
      end
    end
    ```

4. Start SeedHelper session in your priv/repo/seeds.exs file
   ```
   require SeedHelper
   import SeedHelper
   
   # Begin SeedSession (Agent for requires_seed blocks and etc table for handle cache
   begin_session()
   
   dir = Path.dirname(__ENV__.file)
   Code.eval_file("#{dir}/seeds/#{Mix.env}-seeds.exs")
   
   # Will throw if and requires_seeds blocks were not resolved during execution. 
   :ok = end_session() 
   ```

# ExChargebee


Elixir implementation of the [Chargebee API](https://apidocs.chargebee.com/docs/api). 

ExChargebee is a fork of [ChargebeeElixir](https://github.com/PandaScore/chargebee-elixir) by Nicolas Marlier. This project also borrows from the work of [Chargebeex](https://github.com/WTTJ/chargebeex). 

## Installation
The package can be installed by adding `ex_chargebee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_chargebee, "~> 0.3.0"}
  ]
end
```

## Configuration
```elixir
# config/dev.ex
config :ex_chargebee,
  namespace: "$your_namespace",
  api_key: "$your_api_key"

# or scoped to a single Chargebee site
config :ex_chargebee, :my_site, 
  namespace: "$site_specific_namespace",
  api_key: "$site_specific_api_key"

config :ex_chargebee, :second_site, 
  namespace: "$site_specific_namespace",
  api_key: "$site_specific_api_key"
```

## Usage
```elixir
iex> ExChargebee.Plan.list()
[%{"id" => "some_id", "name" => "some_name", ...}, ...]

# or scoped to a single Chargebee site
ExChargebee.Plan.list(_params = %{}, [site: :my_site])
```


## Alternatives 

 - [ChargebeeElixir](https://github.com/PandaScore/chargebee-elixir) - The original Chargebee Elixir library, which this project is forked from.
 - [Chargebeex](https://github.com/WTTJ/chargebeex) - More idiomatic to Elixir, Provides structs and types for Chargebee Resources, but is not as complete as ExChargebee.

defmodule SnowflakeType do
  @moduledoc """
  Documentation for SnowflakeType.
  """

  use Ecto.Type

  def type, do: :integer

  # Provide custom casting rules.
  # Cast strings into the URI struct to be used at runtime
  def cast(id) when is_integer(id) do
    {:ok, id}
  end

  def cast(id) when is_binary(id) do
    id = String.to_integer(id)
    {:ok, id}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, we are guaranteed to
  # receive a map (as databases are strict) and we will
  # just put the data back into an URI struct to be stored
  # in the loaded schema struct.
  def load(id) when is_integer(id) do
    {:ok, id}
  end

  # When dumping data to the database, we *expect* an URI struct
  # but any value could be inserted into the schema struct at runtime,
  # so we need to guard against them.
  def dump(id) when is_integer(id), do: {:ok, id}
  def dump(_), do: :error

  @doc """
  Generate Snowflake ID.
  """
  # @spec generate() :: t
  def generate() do
    {:ok, id} = Snowflake.next_id()
    id
  end

  # Callback invoked by autogenerate fields.
  @doc false
  def autogenerate, do: generate()
end

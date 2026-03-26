defmodule BathroomOracle do
  @moduledoc """
  Public entrypoint for consulting the Bathroom Oracle.
  """

  alias BathroomOracle.{Oracle, Response}

  @spec consult(String.t()) :: Response.t()
  def consult(question) when is_binary(question) do
    Oracle.consult(question)
  end
end

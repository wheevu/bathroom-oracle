defmodule BathroomOracle.Vote do
  @moduledoc false

  @enforce_keys [:entity, :vote, :confidence, :reason_key]
  defstruct [:entity, :vote, :confidence, :reason_key]

  @type entity :: :mirror_of_doubt | :sink_of_mercury | :third_towel | :soap_of_clarity
  @type stance :: :yes | :no | :abstain

  @type t :: %__MODULE__{
          entity: entity(),
          vote: stance(),
          confidence: 1..5,
          reason_key: atom()
        }
end

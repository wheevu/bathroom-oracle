defmodule BathroomOracle.Response do
  @moduledoc false

  @enforce_keys [:header, :verdict, :verdict_key, :council, :omens, :interpretation, :ritual]
  defstruct [:header, :verdict, :verdict_key, :council, :omens, :interpretation, :ritual]

  @type council_note :: %{
          name: String.t(),
          vote: String.t(),
          reason: String.t(),
          confidence: pos_integer()
        }
  @type omen_note :: %{label: String.t(), value: String.t()}

  @type t :: %__MODULE__{
          header: String.t(),
          verdict: String.t(),
          verdict_key: atom(),
          council: [council_note()],
          omens: [omen_note()],
          interpretation: String.t(),
          ritual: String.t()
        }
end

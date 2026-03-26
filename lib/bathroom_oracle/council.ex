defmodule BathroomOracle.Council do
  @moduledoc false

  alias BathroomOracle.Entities.{MirrorOfDoubt, SinkOfMercury, SoapOfClarity, ThirdTowel}
  alias BathroomOracle.{Omens, Question, Vote}

  @entity_modules [MirrorOfDoubt, SinkOfMercury, ThirdTowel, SoapOfClarity]

  @spec vote(Question.t(), Omens.t()) :: [Vote.t()]
  def vote(%Question{} = question, %Omens{} = omens) do
    Enum.map(@entity_modules, & &1.vote(question, omens))
  end
end

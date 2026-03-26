defmodule BathroomOracle.Entities.SinkOfMercury do
  @moduledoc false

  alias BathroomOracle.{Omens, Question, Vote}

  @spec vote(Question.t(), Omens.t()) :: Vote.t()
  def vote(%Question{} = question, %Omens{} = omens) do
    cond do
      question.category == :impulse ->
        %Vote{entity: :sink_of_mercury, vote: :no, confidence: 4, reason_key: :wet_brakes}

      question.category in [:money, :ambition] and omens.tile_resonance == :unstable ->
        %Vote{entity: :sink_of_mercury, vote: :no, confidence: 4, reason_key: :bad_timing}

      question.category in [:money, :ambition] and question.wording == :clean and
          omens.steam_density == :favorable ->
        %Vote{
          entity: :sink_of_mercury,
          vote: :yes,
          confidence: 4,
          reason_key: :momentum_favorable
        }

      question.length == :short and question.tone == :sincere ->
        %Vote{entity: :sink_of_mercury, vote: :yes, confidence: 3, reason_key: :practical_current}

      true ->
        %Vote{
          entity: :sink_of_mercury,
          vote: :abstain,
          confidence: 2,
          reason_key: :drainage_inconclusive
        }
    end
  end
end

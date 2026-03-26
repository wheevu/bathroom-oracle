defmodule BathroomOracle.Entities.ThirdTowel do
  @moduledoc false

  alias BathroomOracle.{Omens, Question, Vote}

  @spec vote(Question.t(), Omens.t()) :: Vote.t()
  def vote(%Question{} = question, %Omens{} = _omens) do
    cond do
      question.desperation >= 3 ->
        %Vote{entity: :third_towel, vote: :no, confidence: 3, reason_key: :wrung_out}

      question.wording == :clean and question.length != :long ->
        %Vote{entity: :third_towel, vote: :yes, confidence: 3, reason_key: :proper_fold}

      question.category == :appearance ->
        %Vote{entity: :third_towel, vote: :yes, confidence: 2, reason_key: :presentation_matters}

      true ->
        %Vote{entity: :third_towel, vote: :abstain, confidence: 1, reason_key: :hanging_back}
    end
  end
end

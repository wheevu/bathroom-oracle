defmodule BathroomOracle.Entities.MirrorOfDoubt do
  @moduledoc false

  alias BathroomOracle.{Omens, Question, Vote}

  @spec vote(Question.t(), Omens.t()) :: Vote.t()
  def vote(%Question{} = question, %Omens{} = omens) do
    cond do
      question.tone == :arrogant ->
        %Vote{entity: :mirror_of_doubt, vote: :no, confidence: 4, reason_key: :false_certainty}

      question.desperation >= 3 ->
        %Vote{entity: :mirror_of_doubt, vote: :no, confidence: 4, reason_key: :fear_detected}

      question.category == :appearance and question.wording != :clean ->
        %Vote{entity: :mirror_of_doubt, vote: :no, confidence: 3, reason_key: :vanity_detected}

      question.tone == :sincere and omens.mirror_clarity in [:clear, :clouded] ->
        %Vote{entity: :mirror_of_doubt, vote: :yes, confidence: 3, reason_key: :honest_intent}

      question.wording == :clean ->
        %Vote{
          entity: :mirror_of_doubt,
          vote: :abstain,
          confidence: 2,
          reason_key: :nothing_to_mock
        }

      true ->
        %Vote{entity: :mirror_of_doubt, vote: :no, confidence: 2, reason_key: :weak_intent}
    end
  end
end

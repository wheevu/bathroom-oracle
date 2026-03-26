defmodule BathroomOracle.Entities.SoapOfClarity do
  @moduledoc false

  alias BathroomOracle.{Omens, Question, Vote}

  @spec vote(Question.t(), Omens.t()) :: Vote.t()
  def vote(%Question{} = question, %Omens{} = _omens) do
    cond do
      question.tone == :chaotic ->
        %Vote{entity: :soap_of_clarity, vote: :no, confidence: 4, reason_key: :lather_rejected}

      question.wording == :foggy ->
        %Vote{entity: :soap_of_clarity, vote: :no, confidence: 3, reason_key: :murky_phrasing}

      question.tone == :sincere and question.wording == :clean ->
        %Vote{entity: :soap_of_clarity, vote: :yes, confidence: 4, reason_key: :clean_intent}

      question.punctuation == :flat ->
        %Vote{entity: :soap_of_clarity, vote: :abstain, confidence: 1, reason_key: :no_lather}

      true ->
        %Vote{entity: :soap_of_clarity, vote: :yes, confidence: 2, reason_key: :clarity_emerges}
    end
  end
end

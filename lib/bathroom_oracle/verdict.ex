defmodule BathroomOracle.Verdict do
  @moduledoc false

  alias BathroomOracle.{Omens, Question, Vote}

  @enforce_keys [:key, :label, :score, :severity]
  defstruct [:key, :label, :score, :severity]

  @type key :: :yes | :no | :proceed_carefully | :ask_later | :oracle_refuses
  @type severity :: :low | :medium | :high

  @type t :: %__MODULE__{
          key: key(),
          label: String.t(),
          score: integer(),
          severity: severity()
        }

  @weights %{
    mirror_of_doubt: 2,
    sink_of_mercury: 2,
    third_towel: 1,
    soap_of_clarity: 2
  }

  @spec resolve(Question.t(), Omens.t(), [Vote.t()]) :: t()
  def resolve(%Question{} = question, %Omens{} = omens, votes) when is_list(votes) do
    score =
      Enum.reduce(votes, 0, &vote_score/2) + Omens.score(omens) + tone_modifier(question.tone)

    {key, label} =
      cond do
        score >= 3 -> {:yes, "Yes."}
        score in 1..2 -> {:proceed_carefully, "Proceed carefully."}
        score == 0 -> {:ask_later, "Ask later."}
        score in -3..-1 -> {:no, "No."}
        true -> {:oracle_refuses, "The Oracle refuses."}
      end

    %__MODULE__{key: key, label: label, score: score, severity: severity(score)}
  end

  defp vote_score(%Vote{entity: entity, vote: :yes}, total),
    do: total + Map.fetch!(@weights, entity)

  defp vote_score(%Vote{entity: entity, vote: :no}, total),
    do: total - Map.fetch!(@weights, entity)

  defp vote_score(%Vote{vote: :abstain}, total), do: total

  defp tone_modifier(:sincere), do: 1
  defp tone_modifier(:desperate), do: -1
  defp tone_modifier(:chaotic), do: -2
  defp tone_modifier(:arrogant), do: -1
  defp tone_modifier(:uncertain), do: 0

  defp severity(score) when score >= 4 or score <= -4, do: :high
  defp severity(score) when score >= 2 or score <= -2, do: :medium
  defp severity(_score), do: :low
end

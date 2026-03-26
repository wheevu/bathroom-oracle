defmodule BathroomOracle.Composer do
  @moduledoc false

  alias BathroomOracle.{Content, Omens, Question, Response, Verdict, Vote}

  @spec compose(Question.t(), Omens.t(), [Vote.t()], Verdict.t()) :: Response.t()
  def compose(%Question{} = question, %Omens{} = omens, votes, %Verdict{} = verdict)
      when is_list(votes) do
    seed = response_seed(question, verdict)

    %Response{
      header: Content.header_line(seed),
      verdict: verdict.label,
      verdict_key: verdict.key,
      council: Enum.with_index(votes) |> Enum.map(&council_note(&1, seed)),
      omens: omen_notes(omens, seed),
      interpretation: Content.interpretation(question, verdict, seed),
      ritual: Content.ritual(question, verdict, seed)
    }
  end

  defp response_seed(question, verdict) do
    String.to_charlist(question.normalized)
    |> Enum.sum()
    |> Kernel.+(question.word_count)
    |> Kernel.+(question.desperation)
    |> Kernel.+(verdict.score)
  end

  defp council_note({%Vote{} = vote, index}, seed) do
    %{
      name: Content.entity_name(vote.entity),
      vote: Content.vote_label(vote.vote),
      reason: Content.entity_reason(vote.entity, vote.reason_key, seed + index),
      confidence: vote.confidence
    }
  end

  defp omen_notes(%Omens{} = omens, seed) do
    [
      {:steam_density, omens.steam_density},
      {:tile_resonance, omens.tile_resonance},
      {:mirror_clarity, omens.mirror_clarity},
      {:towel_alignment, omens.towel_alignment}
    ]
    |> Enum.with_index()
    |> Enum.map(fn {{label, value}, index} ->
      %{
        label: Content.omen_label(label),
        value: Content.omen_value(label, value, seed + index)
      }
    end)
  end
end

defmodule BathroomOracle.Omens do
  @moduledoc false

  alias BathroomOracle.Question

  @enforce_keys [:steam_density, :tile_resonance, :mirror_clarity, :towel_alignment]
  defstruct [:steam_density, :tile_resonance, :mirror_clarity, :towel_alignment]

  @type steam_density :: :favorable | :neutral | :ominous
  @type tile_resonance :: :steady | :wavering | :unstable
  @type mirror_clarity :: :clear | :clouded | :smudged
  @type towel_alignment :: :aligned | :slack | :crooked

  @type t :: %__MODULE__{
          steam_density: steam_density(),
          tile_resonance: tile_resonance(),
          mirror_clarity: mirror_clarity(),
          towel_alignment: towel_alignment()
        }

  @spec compute(Question.t(), keyword()) :: t()
  def compute(%Question{} = question, opts \\ []) do
    now = Keyword.get(opts, :now, DateTime.utc_now())
    roll = Keyword.get(opts, :roll, :rand.uniform(6))
    {hour, minute} = clock(now)

    %__MODULE__{
      steam_density: steam_density(question, minute, roll),
      tile_resonance: tile_resonance(question, hour, minute),
      mirror_clarity: mirror_clarity(question, roll),
      towel_alignment: towel_alignment(question, minute)
    }
  end

  @spec score(t()) :: integer()
  def score(%__MODULE__{} = omens) do
    omen_score(:steam_density, omens.steam_density) +
      omen_score(:tile_resonance, omens.tile_resonance) +
      omen_score(:mirror_clarity, omens.mirror_clarity) +
      omen_score(:towel_alignment, omens.towel_alignment)
  end

  defp clock(%DateTime{hour: hour, minute: minute}), do: {hour, minute}
  defp clock(%NaiveDateTime{hour: hour, minute: minute}), do: {hour, minute}
  defp clock(%Time{hour: hour, minute: minute}), do: {hour, minute}

  defp steam_density(question, minute, roll) do
    case rem(minute + roll + question.desperation, 3) do
      0 -> :favorable
      1 -> :neutral
      _ -> :ominous
    end
  end

  defp tile_resonance(question, hour, minute) do
    case rem(hour + minute + question.word_count, 3) do
      0 -> :steady
      1 -> :wavering
      _ -> :unstable
    end
  end

  defp mirror_clarity(%Question{tone: :chaotic}, _roll), do: :smudged
  defp mirror_clarity(%Question{wording: :frayed}, _roll), do: :smudged
  defp mirror_clarity(%Question{tone: :sincere}, roll) when roll <= 4, do: :clear
  defp mirror_clarity(%Question{wording: :clean}, roll) when roll <= 3, do: :clear
  defp mirror_clarity(%Question{tone: :arrogant}, _roll), do: :smudged
  defp mirror_clarity(_question, _roll), do: :clouded

  defp towel_alignment(%Question{length: :long}, _minute), do: :crooked

  defp towel_alignment(%Question{desperation: desperation}, _minute) when desperation >= 3,
    do: :crooked

  defp towel_alignment(%Question{wording: :clean}, minute) do
    if rem(minute, 2) == 0, do: :aligned, else: :slack
  end

  defp towel_alignment(_question, _minute), do: :slack

  defp omen_score(:steam_density, :favorable), do: 1
  defp omen_score(:steam_density, :ominous), do: -1
  defp omen_score(:tile_resonance, :steady), do: 1
  defp omen_score(:tile_resonance, :unstable), do: -1
  defp omen_score(:mirror_clarity, :clear), do: 1
  defp omen_score(:mirror_clarity, :smudged), do: -1
  defp omen_score(:towel_alignment, :aligned), do: 1
  defp omen_score(:towel_alignment, :crooked), do: -1
  defp omen_score(_omen, _state), do: 0
end

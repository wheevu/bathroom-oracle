defmodule BathroomOracle.Question do
  @moduledoc false

  @enforce_keys [
    :raw,
    :normalized,
    :category,
    :tone,
    :wording,
    :desperation,
    :punctuation,
    :length,
    :punctuation_count,
    :word_count
  ]
  defstruct [
    :raw,
    :normalized,
    :category,
    :tone,
    :wording,
    :desperation,
    :punctuation,
    :length,
    :punctuation_count,
    :word_count
  ]

  @type category :: :romance | :appearance | :ambition | :money | :impulse | :general
  @type tone :: :uncertain | :desperate | :arrogant | :sincere | :chaotic
  @type wording :: :clean | :foggy | :frayed
  @type punctuation :: :question_mark | :chaotic | :emphatic | :flat
  @type length_bucket :: :short | :medium | :long

  @type t :: %__MODULE__{
          raw: String.t(),
          normalized: String.t(),
          category: category(),
          tone: tone(),
          wording: wording(),
          desperation: 0..4,
          punctuation: punctuation(),
          length: length_bucket(),
          punctuation_count: non_neg_integer(),
          word_count: non_neg_integer()
        }

  @romance_markers [
    "love",
    "date",
    "crush",
    "kiss",
    "relationship",
    "boyfriend",
    "girlfriend",
    "text her",
    "text him",
    "text them",
    "call them",
    "call her",
    "call him"
  ]
  @appearance_markers [
    "hair",
    "bangs",
    "look",
    "outfit",
    "appearance",
    "hot",
    "ugly",
    "glow up",
    "mustache",
    "beard",
    "wear this"
  ]
  @ambition_markers [
    "job",
    "career",
    "quit",
    "business",
    "startup",
    "apply",
    "ambition",
    "dream",
    "move",
    "launch",
    "project",
    "mysterious"
  ]
  @money_markers [
    "money",
    "salary",
    "raise",
    "rent",
    "debt",
    "buy",
    "spend",
    "invest",
    "expensive",
    "rich"
  ]
  @impulse_markers [
    "right now",
    "tonight",
    "immediately",
    "tattoo",
    "book it",
    "buy it",
    "send it",
    "go now"
  ]
  @uncertain_markers ["maybe", "idk", "i don't know", "not sure", "or whatever", "perhaps"]
  @desperate_markers ["please", "again", "right now", "need", "immediately", "desperate"]
  @arrogant_markers ["obviously", "clearly", "of course", "i already know"]
  @sincere_markers ["honestly", "truly", "sincerely", "for real"]
  @chaos_markers ["?!", "!!!", "???", "wtf", "help me", "be serious"]
  @filler_markers ["like", "just", "literally", "basically", "sort of"]

  @spec analyze(String.t()) :: t()
  def analyze(raw_question) when is_binary(raw_question) do
    normalized = normalize(raw_question)
    downcased = String.downcase(normalized)
    word_count = count_words(normalized)
    punctuation_count = count_punctuation(normalized)
    desperation = desperation_score(downcased, normalized)
    tone = tone(downcased, normalized, desperation)

    %__MODULE__{
      raw: raw_question,
      normalized: normalized,
      category: category(downcased),
      tone: tone,
      wording: wording(downcased, tone, word_count),
      desperation: desperation,
      punctuation: punctuation_style(normalized),
      length: length_bucket(word_count),
      punctuation_count: punctuation_count,
      word_count: word_count
    }
  end

  defp normalize(question) do
    question
    |> String.trim()
    |> String.replace(~r/\s+/, " ")
  end

  defp count_words(""), do: 0
  defp count_words(question), do: question |> String.split(" ", trim: true) |> length()

  defp count_punctuation(question) do
    question
    |> String.graphemes()
    |> Enum.count(&(&1 in ["?", "!", ",", ".", ":", ";"]))
  end

  defp category(question) do
    cond do
      contains_any?(question, @romance_markers) -> :romance
      contains_any?(question, @appearance_markers) -> :appearance
      contains_any?(question, @money_markers) -> :money
      contains_any?(question, @ambition_markers) -> :ambition
      contains_any?(question, @impulse_markers) -> :impulse
      true -> :general
    end
  end

  defp tone(question, raw_question, desperation) do
    cond do
      chaotic?(question, raw_question) -> :chaotic
      desperation >= 3 -> :desperate
      contains_any?(question, @arrogant_markers) -> :arrogant
      contains_any?(question, @sincere_markers) -> :sincere
      true -> :uncertain
    end
  end

  defp wording(_question, :chaotic, _word_count), do: :frayed

  defp wording(question, _tone, word_count) do
    cond do
      word_count > 20 -> :foggy
      contains_any?(question, @filler_markers) -> :foggy
      true -> :clean
    end
  end

  defp punctuation_style(question) do
    cond do
      String.contains?(question, "?!") or String.contains?(question, "!!") or
          String.contains?(question, "??") ->
        :chaotic

      String.contains?(question, "?") ->
        :question_mark

      String.contains?(question, "!") ->
        :emphatic

      true ->
        :flat
    end
  end

  defp length_bucket(word_count) when word_count <= 7, do: :short
  defp length_bucket(word_count) when word_count <= 18, do: :medium
  defp length_bucket(_word_count), do: :long

  defp desperation_score(question, raw_question) do
    score =
      count_markers(question, @desperate_markers) +
        count_markers(question, @uncertain_markers) +
        if String.contains?(raw_question, "!!") or String.contains?(raw_question, "??"),
          do: 1,
          else: 0

    min(score, 4)
  end

  defp chaotic?(question, raw_question) do
    contains_any?(question, @chaos_markers) or Regex.match?(~r/[?!]{2,}/, raw_question)
  end

  defp count_markers(question, markers) do
    Enum.count(markers, &String.contains?(question, &1))
  end

  defp contains_any?(question, markers) do
    Enum.any?(markers, &String.contains?(question, &1))
  end
end

defmodule BathroomOracle.OracleTest do
  use ExUnit.Case, async: true

  alias BathroomOracle.{Omens, Oracle, Question, Response}

  describe "question analysis" do
    test "detects category and desperation from surface features" do
      question = Question.analyze("Should I text her right now please again?")

      assert question.category == :romance
      assert question.tone == :desperate
      assert question.desperation == 3
      assert question.punctuation == :question_mark
    end
  end

  describe "omens.compute/2" do
    test "stays deterministic with provided time and roll" do
      question = Question.analyze("Should I quit my job and become mysterious?")

      assert %Omens{
               steam_density: :neutral,
               tile_resonance: :unstable,
               mirror_clarity: :clear,
               towel_alignment: :slack
             } = Omens.compute(question, now: ~U[2026-03-26 13:47:00Z], roll: 2)
    end
  end

  describe "consult/2" do
    test "returns a fully composed response" do
      response =
        Oracle.consult("Should I quit my job and become mysterious?",
          now: ~U[2026-03-26 13:47:00Z],
          roll: 2
        )

      assert %Response{
               verdict: "Proceed carefully.",
               verdict_key: :proceed_carefully,
               council: council,
               omens: omens,
               interpretation: interpretation,
               ritual: ritual
             } = response

      assert length(council) == 4
      assert Enum.any?(council, &(&1.name == "Mirror of Doubt"))
      assert Enum.any?(council, &(&1.vote == "Yes"))

      assert length(omens) == 4
      assert Enum.any?(omens, &(&1.label == "Steam density"))

      assert interpretation != ""
      assert ritual != ""
    end
  end
end

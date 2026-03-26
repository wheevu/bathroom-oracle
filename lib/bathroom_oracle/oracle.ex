defmodule BathroomOracle.Oracle do
  @moduledoc false

  alias BathroomOracle.{Composer, Council, Omens, Question, Response, Verdict}

  @spec consult(String.t()) :: Response.t()
  def consult(question) when is_binary(question) do
    consult(question, [])
  end

  @doc false
  @spec consult(String.t(), keyword()) :: Response.t()
  def consult(question, opts) when is_binary(question) and is_list(opts) do
    analysis = Question.analyze(question)
    omens = Omens.compute(analysis, opts)
    votes = Council.vote(analysis, omens)
    verdict = Verdict.resolve(analysis, omens, votes)

    Composer.compose(analysis, omens, votes, verdict)
  end
end

defmodule BathroomOracleWeb.OracleComponents do
  @moduledoc false

  use Phoenix.Component

  attr :response, BathroomOracle.Response, required: true

  def oracle_response(assigns) do
    ~H"""
    <div class="max-w-2xl space-y-5 text-sm leading-7 text-[var(--text)]">
      <p
        class="oracle-reveal text-[0.7rem] uppercase tracking-[0.3em] text-[var(--accent-soft)]/90"
        style={reveal_style(0)}
      >
        {@response.header}
      </p>

      <div class="space-y-5">
        <.response_section label="Verdict" delay={1}>
          <p class={["text-lg sm:text-xl", verdict_class(@response.verdict_key)]}>
            {@response.verdict}
          </p>
        </.response_section>

        <.response_section label="Council" delay={2}>
          <ul class="space-y-2.5">
            <li
              :for={{note, idx} <- Enum.with_index(@response.council, 3)}
              class="oracle-reveal flex flex-wrap items-baseline gap-x-3 gap-y-1"
              style={reveal_style(idx)}
            >
              <span class="text-[var(--muted)]">{note.name}:</span>
              <span class="text-[var(--text)]">{note.vote}</span>
              <span class="text-xs text-[var(--muted)]/80">{note.reason}</span>
            </li>
          </ul>
        </.response_section>

        <.response_section label="Omens" delay={7}>
          <ul class="space-y-2.5">
            <li
              :for={{omen, idx} <- Enum.with_index(@response.omens, 8)}
              class="oracle-reveal flex flex-wrap items-baseline gap-x-3 gap-y-1"
              style={reveal_style(idx)}
            >
              <span class="text-[var(--muted)]">{omen.label}:</span>
              <span class="text-[var(--text)]">{omen.value}</span>
            </li>
          </ul>
        </.response_section>

        <.response_section label="Interpretation" delay={13}>
          <p class="oracle-reveal text-[var(--text)]" style={reveal_style(14)}>
            {@response.interpretation}
          </p>
        </.response_section>

        <.response_section label="Ritual" delay={15}>
          <p class="oracle-reveal text-[var(--accent-soft)]" style={reveal_style(16)}>
            {@response.ritual}
          </p>
        </.response_section>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :delay, :integer, default: 0
  slot :inner_block, required: true

  defp response_section(assigns) do
    ~H"""
    <section class="space-y-2 border-l border-[var(--line-strong)] pl-4 sm:pl-5">
      <p
        class="oracle-reveal text-[0.76rem] font-semibold uppercase tracking-[0.32em] text-[var(--accent-soft)]"
        style={reveal_style(@delay)}
      >
        {@label}
      </p>
      {render_slot(@inner_block)}
    </section>
    """
  end

  defp reveal_style(index), do: "--reveal-delay: #{120 + index * 70}ms"

  defp verdict_class(:yes), do: "font-semibold text-[var(--accent-soft)]"
  defp verdict_class(:proceed_carefully), do: "font-semibold text-[var(--accent)]"
  defp verdict_class(:ask_later), do: "font-semibold text-[var(--muted)]"
  defp verdict_class(:no), do: "font-semibold text-[var(--text)]"
  defp verdict_class(:oracle_refuses), do: "font-semibold text-[var(--danger)]"
end

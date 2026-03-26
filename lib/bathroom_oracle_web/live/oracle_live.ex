defmodule BathroomOracleWeb.OracleLive do
  use BathroomOracleWeb, :live_view

  import BathroomOracleWeb.OracleComponents

  @empty_question_error "The Oracle requires an actual question."
  @minimum_think_time_ms 480
  @oracle_title_art [
                      "  ░██████                                  ░██                              ░████       ░██    ░██                      ░████████                 ░██    ░██",
                      " ░██   ░██                                 ░██                             ░██          ░██    ░██                      ░██    ░██                ░██    ░██",
                      "░██     ░██ ░██░████  ░██████    ░███████  ░██  ░███████      ░███████  ░████████    ░████████ ░████████   ░███████     ░██    ░██   ░██████   ░████████ ░████████  ░██░████  ░███████   ░███████  ░█████████████",
                      "░██     ░██ ░███           ░██  ░██    ░██ ░██ ░██    ░██    ░██    ░██    ░██          ░██    ░██    ░██ ░██    ░██    ░████████         ░██     ░██    ░██    ░██ ░███     ░██    ░██ ░██    ░██ ░██   ░██   ░██",
                      "░██     ░██ ░██       ░███████  ░██        ░██ ░█████████    ░██    ░██    ░██          ░██    ░██    ░██ ░█████████    ░██     ░██  ░███████     ░██    ░██    ░██ ░██      ░██    ░██ ░██    ░██ ░██   ░██   ░██",
                      " ░██   ░██  ░██      ░██   ░██  ░██    ░██ ░██ ░██           ░██    ░██    ░██          ░██    ░██    ░██ ░██           ░██     ░██ ░██   ░██     ░██    ░██    ░██ ░██      ░██    ░██ ░██    ░██ ░██   ░██   ░██",
                      "  ░██████   ░██       ░█████░██  ░███████  ░██  ░███████      ░███████     ░██           ░████ ░██    ░██  ░███████     ░█████████   ░█████░██     ░████ ░██    ░██ ░██       ░███████   ░███████  ░██   ░██   ░██"
                    ]
                    |> Enum.join("\n")

  @oracle_background_art [
                           "           __________________________________________________",
                           "          ~~<><><><><><><><><><><><><><><><><><><><><><><>~~!",
                           "            8888888888888888888888888888888888888888888888  !",
                           "            8888888888888888888888888888888888888888888888  !",
                           "            8888888888888888888888888888888888888888888888  !",
                           "            8888888888888888888888888888888888888888888888  !",
                           "            8888888888888888888888888888888888888888888888  !",
                           "            8888888888888888888888888888888888888888888888  !",
                           "            8888888888888888888888888888888888888888888888  !",
                           "             ~~~~~~~~~~~~~~~~~~~~~[]~~~~~~~~~~~~~~~~~~~~~   !",
                           "                                  []                        !",
                           "                                  []                        !",
                           "                                  []                        !",
                           "                                  []                        !",
                           "                                  []                        I",
                           "                                  []                        M",
                           "                                  []                        W",
                           "                              ____[]___",
                           "                       _mmm88888888888888mmm_",
                           "                   _m8**888888888888888888888**8m_",
                           "                 m8*8m*8m888***88~88~8***888m8*m8*8m",
                           "               m8888mm888*8m88888 88 8888m8*888mm8888m",
                           "              m8888888*8m88888888 88 8888888m8*8888888m",
                           "             m8888888*_8888888888 88 888888888_*8888888m",
                           "             88888888 88888888888 88 8888888888 88888888",
                           "             88888888 88888888888 88 8888888888 88888888",
                           "             ~88888888 8888888888 88 888888888 88888888~",
                           "              ~88888888m8*8888888 88 888888*8m88888888~",
                           "               ~*888888888m8***88 88 8***8m888888888*~",
                           "                 ~*888888888888mmmmmmm888888888888*~",
                           "                    ~**888~m=m=mmmmmmm=m=m~888**~",
                           "            ____________88_888888888888888_88____________",
                           "           *888888888888888888888888888888888888888888888*",
                           "                 mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm",
                           "                 88888888888888888888888888888888888",
                           "                  888888888888888888888888888888888",
                           "                   *88888888*88888888888*88888888*",
                           "                     ~*888888 888888888 888888*~",
                           "                        ~**88 888888888 88**~",
                           "                          8mm 888888888 mm8   -Jeurgen Jacubowski-",
                           "                         _88* 888888888 *88_",
                           "                    _____888_88888888888_888_____",
                           "                   8888888888888888888888888888888"
                         ]
                         |> Enum.join("\n")

  @placeholder_rotations [
    "Should I quit my job and become mysterious?",
    "What are we?",
    "Should I text first?",
    "Would bangs fix the spiritual issue?",
    "If I wear rings, will the personality arrive on its own?"
  ]

  @loading_copy [
    "The council is conferring in damp silence.",
    "Steam is being consulted.",
    "The fixtures are arranging their disapproval.",
    "The chamber is pretending this is a formal process."
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Oracle of the Bathroom")
     |> assign(:oracle_title_art, @oracle_title_art)
     |> assign(:oracle_background_art, @oracle_background_art)
     |> assign(:placeholder_rotation_json, Jason.encode!(@placeholder_rotations))
     |> assign(:question_error, nil)
     |> assign(:consulting?, false)
     |> assign(:pending_oracle_id, nil)
     |> assign(:loading_copy, Enum.at(@loading_copy, 0))
     |> assign(:form, question_form(""))
     |> stream_configure(:messages, dom_id: &"message-#{&1.id}")
     |> stream(:messages, [])}
  end

  @impl true
  def handle_event("validate", %{"oracle" => %{"question" => question}}, socket) do
    trimmed_question = String.trim(question)

    {:noreply,
     socket
     |> assign(:form, question_form(question))
     |> assign(:question_error, validation_error(trimmed_question, question))}
  end

  def handle_event("consult", %{"oracle" => %{"question" => question}}, socket) do
    trimmed_question = String.trim(question)

    cond do
      trimmed_question == "" ->
        {:noreply,
         socket
         |> assign(:form, question_form(question))
         |> assign(:question_error, @empty_question_error)}

      socket.assigns.consulting? ->
        {:noreply, socket}

      true ->
        user_message = %{id: message_id("user"), role: :user, body: trimmed_question}
        oracle_id = message_id("oracle")

        loading_message = %{
          id: oracle_id,
          role: :oracle_loading,
          loading_copy: loading_copy(trimmed_question)
        }

        socket =
          socket
          |> assign(:form, question_form(""))
          |> assign(:question_error, nil)
          |> assign(:consulting?, true)
          |> assign(:pending_oracle_id, oracle_id)
          |> assign(:loading_copy, loading_message.loading_copy)
          |> stream(:messages, [user_message, loading_message])

        {:noreply,
         start_async(socket, :consult, fn ->
           Process.sleep(@minimum_think_time_ms)
           BathroomOracle.consult(trimmed_question)
         end)}
    end
  end

  @impl true
  def handle_async(:consult, {:ok, response}, socket) do
    oracle_id = socket.assigns.pending_oracle_id

    {:noreply,
     socket
     |> assign(:consulting?, false)
     |> assign(:pending_oracle_id, nil)
     |> stream_insert(:messages, %{id: oracle_id, role: :oracle, response: response})}
  end

  def handle_async(:consult, _result, socket) do
    oracle_id = socket.assigns.pending_oracle_id

    {:noreply,
     socket
     |> assign(:consulting?, false)
     |> assign(:pending_oracle_id, nil)
     |> stream_insert(:messages, %{
       id: oracle_id,
       role: :oracle_error,
       body: "The chamber slipped on its own moisture. Ask again in a calmer minute."
     })}
  end

  defp question_form(question) do
    to_form(%{"question" => question}, as: :oracle)
  end

  defp validation_error("", raw_question) when raw_question != "", do: @empty_question_error
  defp validation_error(_trimmed_question, _raw_question), do: nil

  defp loading_copy(question) do
    seed =
      question
      |> String.to_charlist()
      |> Enum.sum()

    Enum.at(@loading_copy, rem(seed, length(@loading_copy)))
  end

  defp message_id(prefix) do
    "#{prefix}-#{System.unique_integer([:positive])}"
  end
end

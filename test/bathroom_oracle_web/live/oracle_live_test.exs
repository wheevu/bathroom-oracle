defmodule BathroomOracleWeb.OracleLiveTest do
  use BathroomOracleWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the oracle console", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert has_element?(view, "#oracle-thread")
    assert has_element?(view, "#oracle-form")
    assert has_element?(view, "#consult-button")
  end

  test "rejects blank submissions", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    view
    |> form("#oracle-form", %{oracle: %{question: "   "}})
    |> render_submit()

    assert has_element?(view, "#oracle-question-error", "The Oracle requires an actual question.")
  end

  test "shows a loading state and appends exchanges to the in-session thread", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    loading_html =
      view
      |> form("#oracle-form", %{
        oracle: %{question: "Should I quit my job and become mysterious?"}
      })
      |> render_submit()

    assert loading_html =~ "data-role=\"oracle_loading\""
    assert loading_html =~ "Steam is being consulted."

    settled_html = render_async(view, 1_000)

    assert has_element?(view, "[data-role='user']", "Should I quit my job and become mysterious?")
    assert has_element?(view, "[data-role='oracle']")

    assert Enum.any?(
             ["Yes.", "No.", "Proceed carefully.", "Ask later.", "The Oracle refuses."],
             &String.contains?(settled_html, &1)
           )

    view
    |> form("#oracle-form", %{oracle: %{question: "Should I text her right now please again?"}})
    |> render_submit()

    html = render_async(view, 1_000)

    assert Regex.scan(~r/data-role="user"/, html) |> length() == 2
    assert Regex.scan(~r/data-role="oracle"/, html) |> length() == 2
  end
end

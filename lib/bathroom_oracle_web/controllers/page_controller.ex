defmodule BathroomOracleWeb.PageController do
  use BathroomOracleWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

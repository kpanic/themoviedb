defmodule TheMovieDB.HTTP do
  @moduledoc false

  use HTTPoison.Base

  def process_request_url(url), do: "https://" <> url

  def process_request_params(params) do
    Map.merge(
      params,
        Map.merge(params, %{api_key: Application.fetch_env!(:themoviedb, :api_key)})
    )
  end
end

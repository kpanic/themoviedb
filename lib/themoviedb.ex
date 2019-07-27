defmodule TheMovieDB do
  alias TheMovieDB.API

  def search(title, type, opts \\ [])

  def search(title, :movie, recommendations: true) do
    API.recommendations(title)
  end

  def search(title, :movie, _opts) do
    API.movie(title)
  end
end

defmodule Themoviedb do
  def search(title, :movie) do
    TMDB.movie(title)
  end
end

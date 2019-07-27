defmodule TMDB do
  @url "https://api.themoviedb.org/3/search/movie"
  @public_url "https://www.themoviedb.org/movie"

  def movie(title) do
    api_key = Application.fetch_env!(:themoviedb, :api_key)
    query_params = URI.encode_query(%{api_key: api_key, query: title})
    %{body: body} = HTTPoison.get!("#{@url}?#{query_params}")
    %{"results" => [first_match | _rest]} = Jason.decode!(body)
    Map.put(first_match, "public_url", "#{@public_url}/#{first_match["id"]}")
  end
end

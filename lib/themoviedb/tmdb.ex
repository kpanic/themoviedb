defmodule TheMovieDB.API do
  @url "api.themoviedb.org/3"
  @public_url "https://www.themoviedb.org"

  alias TheMovieDB.HTTP

  def movie(title) do
    query_params = URI.encode_query(%{query: title})

    with {:ok, %{body: body}} <- HTTP.get("#{@url}/search/movie?#{query_params}"),
         {:ok, %{"results" => results} = response} <- Jason.decode(body) do
      results = Enum.map(results, &build_public_url(&1, :movie))
      {:ok, Map.put(response, "results", results)}
    end
  end

  def recommendations(title) do
    query_params = URI.encode_query(%{query: title})

    with {:ok, %{body: body}} <- HTTP.get("#{@url}/search/movie?#{query_params}"),
         {:ok, %{"results" => [first_match | _rest]} = response} <- Jason.decode(body),
         recommendations_url = "#{@url}/movie/#{first_match["id"]}/recommendations",
         {:ok, %{body: body}} <- HTTP.get(recommendations_url),
         {:ok, %{"results" => results}} <- Jason.decode(body) do
      results = Enum.map(results, &build_public_url(&1, :movie))

      {:ok, Map.put(response, "results", results)}
    end
  end

  def person(name) do
    query_params = URI.encode_query(%{query: name})

    with {:ok, %{body: body}} <- HTTP.get("#{@url}/search/person?#{query_params}"),
         {:ok, %{"results" => results} = response} <- Jason.decode(body) do
      results = Enum.map(results, &build_public_url(&1, :person))
      {:ok, Map.put(response, "results", results)}
    end
  end

  defp build_public_url(%{"id" => id} = result, type) do
    Map.put(result, "public_url", "#{@public_url}/#{type}/#{id}")
  end
end

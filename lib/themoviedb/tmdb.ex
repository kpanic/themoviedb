defmodule TheMovieDB.API do
  @url "api.themoviedb.org/3"
  @public_url "https://www.themoviedb.org"

  alias TheMovieDB.HTTP

  def movie(title) do
    query_params = URI.encode_query(%{query: title})

    with %{body: body} <- HTTP.get!("#{@url}/search/movie?#{query_params}"),
         {:ok, %{"results" => [first_match | _rest]}} <- Jason.decode(body) do
      {:ok, Map.put(first_match, "public_url", "#{@public_url}/movie/#{first_match["id"]}")}
    end
  end

  def recommendations(title) do
    query_params = URI.encode_query(%{query: title})

    with %{body: body} <- HTTP.get!("#{@url}/search/movie?#{query_params}"),
         {:ok, %{"results" => [first_match | _rest]}} <- Jason.decode(body),
         recommendations_url = "#{@url}/movie/#{first_match["id"]}/recommendations",
         {:ok, %{body: body}} <- HTTP.get(recommendations_url),
         {:ok, %{"results" => results}} <- Jason.decode(body) do
      {:ok,
       Enum.reduce(results, [], fn %{"original_title" => original_title, "id" => id}, acc ->
         acc ++
           [
             %{}
             |> Map.put("public_url", "#{@public_url}/movie/#{id}")
             |> Map.put("original_title", original_title)
           ]
       end)}
    end
  end

  def person(name) do
    query_params = URI.encode_query(%{query: name})

    with %{body: body} <- HTTP.get!("#{@url}/search/person?#{query_params}"),
         {:ok, %{"results" => results}} <- Jason.decode(body) do
      {:ok,
       Enum.map(results, fn %{"id" => id} = result ->
         Map.put(result, "public_url", "#{@public_url}/person/#{id}")
       end)}
    end
  end
end

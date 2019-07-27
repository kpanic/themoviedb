# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :themoviedb, api_key: System.get_env("TMDB_API_KEY")

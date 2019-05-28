defmodule EggheadDl.MixProject do
  use Mix.Project

  def project do
    [
      app: :egghead_dl,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :algolia],
      mod: {EggheadDl.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ffmpex, "~> 0.5.2"},
      {:httpoison, "~> 1.4"},
      {:algolia, "~> 0.8.0"},
      {:floki, "~> 0.21.0"}
    ]
  end
end

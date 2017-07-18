defmodule Ytaudio.Mixfile do
  use Mix.Project

  def project do
    [app: :ytaudio,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Ytaudio.Application, []}]
  end

  defp deps do
    [
      {:poison, "~> 2.0"},
      {:httpoison, "~> 0.8.0"},
      {:ex_doc, "~> 0.16.2", only: :dev}
    ]
  end
end

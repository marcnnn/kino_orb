defmodule KinoOrb.MixProject do
  use Mix.Project

  @version "0.0.1"
  @description "Orb Graph viewer integration with Livebook"

  def project do
    [
      app: :kino_orb,
      version: @version,
      description: @description,
      name: "KinoOrb",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.14.2"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "components",
      source_url: "https://github.com/marcnnn/kino_orb",
      source_ref: "v#{@version}",
      extras: ["guides/components.livemd"],
      groups_for_modules: [
        Kinos: [
          Kino.Orb
        ]
      ]
    ]
  end

  def package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/marcnnn/kino_orb"
      }
    ]
  end
end

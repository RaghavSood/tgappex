defmodule TgAppEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :tgappex,
      version: "1.0.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Raghav Sood"],
      description: "A library for validating and parsing Telegram Web App Init Data.",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/RaghavSood/tgappex"}
    ]
  end
end

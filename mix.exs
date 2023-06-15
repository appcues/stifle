defmodule Stifle.Mixfile do
  use Mix.Project

  def project do
    [app: :stifle,
     version: "0.1.0",
     elixir: "~> 1.2",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps]
  end

  def description do
    ~S"""
    Stifle is a library for suppressing side-effects (raises, exits, etc)
    in Elixir functions, allowing the developer to replay side effects
    in the current process or inspect the effect/return value safely.
    """
  end

  def package do
    [
      maintainers: ["pete gamache", "Appcues"],
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/appcues/stifle"},
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_spec, "~> 2.0.0", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:ex_doc, "~> 0.11.0", only: :dev},
    ]
  end
end


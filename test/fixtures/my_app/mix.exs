defmodule MyApp.Mixfile do
  use Mix.Project

  def project do
    [app: :my_app, version: "1.0.0", compilers: [:ex_task]]
  end
end

defmodule Mix.Tasks.Compile.ExTask do
  @moduledoc """
  Runs Task, a task runner / build tool, in the current project.

  This task installs Task, and runs `task` in the current project;
  any output coming from `task` is printed in real-time on stdout.

  ## Configuration

  This compiler can be configured through the return value of the `project/0` function in `mix.exs`;
  for example:

  ```elixir
    def project() do
      [
        app: :myapp,
        compilers: [:ex_task] ++ Mix.compilers,
        deps: deps()
      ]
    end
  ```

  No option is available now.
  """

  use Mix.Task

  @recursive true

  @doc false
  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:req)

    unless File.exists?(ExTask.Constants.bin_dir()) do
      File.mkdir(ExTask.Constants.bin_dir())
    end

    System.cmd("sh", [
      "-c",
      Req.get!("https://taskfile.dev/install.sh").body,
      "--",
      "-d",
      "-b",
      ExTask.Constants.bin_dir()
    ])

    case System.cmd(ExTask.Constants.executable(), [], cd: File.cwd!(), stderr_to_stdout: true) do
      {msg, 0} -> IO.puts(msg)
      {msg, _} -> raise Mix.Error, msg
    end
  end
end

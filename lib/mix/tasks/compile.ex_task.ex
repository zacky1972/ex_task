defmodule Mix.Tasks.Compile.ExTask do
  @moduledoc """
  Runs Task, a task runner / build tool, in the current project.
  """

  use Mix.Task

  @recursive true

  @doc false
  def run(_args) do
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
      {_msg, 0} -> :ok
      {msg, _} -> raise Mix.Error, msg
    end
  end
end

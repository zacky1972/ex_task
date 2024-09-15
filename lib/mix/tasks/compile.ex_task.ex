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

  ## Default environment variables

  There are also several default environment variables set:

  * `MIX_TARGET`
  * `MIX_ENV`
  * `MIX_BUILD_PATH` - same as [`Mix.Project.build_path/0`](https://hexdocs.pm/mix/Mix.Project.html#build_path/0)
  * `MIX_APP_PATH` - same as [`Mix.Project.app_path/0`](https://hexdocs.pm/mix/Mix.Project.html#app_path/0)
  * `MIX_COMPILE_PATH` - same as [`Mix.Project.compile_path/0`](https://hexdocs.pm/mix/Mix.Project.html#compile_path/0)
  * `MIX_CONSOLIDATION_PATH` - same as [`Mix.Project.consolidation_path/0`](https://hexdocs.pm/mix/Mix.Project.html#consolidation_path/0)
  * `MIX_DEPS_PATH` - same as [`Mix.Project.deps_path/0`](https://hexdocs.pm/mix/Mix.Project.html#deps_path/0)
  * `MIX_MANIFEST_PATH` - same as [`Mix.Project.manifest_path/0`](https://hexdocs.pm/mix/Mix.Project.html#manifest_path/0)
  * `ERL_EI_LIBDIR`
  * `ERL_EI_INCLUDE_DIR`
  * `ERTS_INCLUDE_DIR`
  * `ERL_INTERFACE_LIB_DIR`
  * `ERL_INTERFACE_INCLUDE_DIR`
  """

  use Mix.Task

  @recursive true

  @doc false
  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:req)

    env =
      Mix.Project.config()
      |> ExTask.Constants.default_env()

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

    case System.cmd(ExTask.Constants.executable(), [],
           cd: File.cwd!(),
           stderr_to_stdout: true,
           env: env
         ) do
      {msg, 0} -> IO.puts(msg)
      {msg, _} -> raise Mix.Error, msg
    end
  end
end

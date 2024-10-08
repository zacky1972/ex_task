defmodule Mix.Tasks.Compile.ExTaskTest do
  use ExUnit.Case

  import Mix.Tasks.Compile.ExTask, only: [run: 1]
  import ExUnit.CaptureIO

  @fixture_project Path.expand("../../fixtures/my_app", __DIR__)

  defmodule Sample do
    def project do
      [app: :sample, version: "0.1.0"]
    end
  end

  setup do
    in_fixture(fn ->
      File.rm_rf!("Taskfile.yml")
      File.rm_rf!("_build")
      File.rm_rf!("priv")
      File.rm_rf!("cache")
      File.rm_rf!("dl")
    end)

    :ok
  end

  test "running without Taskfile.yml" do
    msg = ~r/task: No Taskfile found at/

    in_fixture(fn ->
      File.rm_rf!("Taskfile.yml")

      capture_io(fn ->
        assert_raise Mix.Error, msg, fn -> run([]) end
      end)
    end)
  end

  test "running with Taskfile.yml" do
    in_fixture(fn ->
      File.write!("Taskfile.yml", """
      version: '3'

      tasks:
        default:
          cmds:
            - echo 'Hello World from Task!'
          silent: true
      """)

      assert capture_io(fn -> run([]) end) =~ "Hello World from Task!\n"
    end)
  end

  test "default env" do
    in_fixture(fn ->
      File.write!("Taskfile.yml", """
      version: '3'

      tasks:
        default:
          cmds:
            - echo $MIX_TARGET
            - echo $MIX_ENV
            - echo $MIX_BUILD_PATH
            - echo $MIX_COMPILE_PATH
            - echo $MIX_DEPS_PATH
          silent: true
      """)

      with_project_config([], fn ->
        assert capture_io(fn -> run([]) end) =~ """
               host
               test
               #{@fixture_project}/_build/test
               #{@fixture_project}/_build/test/lib/my_app/ebin
               #{@fixture_project}/deps
               """
      end)
    end)
  end

  defp in_fixture(fun) do
    File.cd!(@fixture_project, fun)
  end

  defp with_project_config(config, fun) do
    Mix.Project.in_project(:my_app, @fixture_project, config, fn _ -> fun.() end)
  end
end

defmodule ExTask.Constants do
  @moduledoc false

  def bin_dir() do
    Application.app_dir(:ex_task, "bin")
  end

  def executable() do
    Path.join(bin_dir(), "task")
  end
end

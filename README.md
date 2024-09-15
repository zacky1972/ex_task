# ExTask

ExTask: Task, a task runner / build tool, for Mix

## Documentation

API documentation is available at https://hexdocs.pm/ex_task

## Usage

The package can be installed by adding `ex_task` to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:ex_task, "~> 0.1", runtime: false}]
  end
```

Still in your `mix.exs` file, you will need to add `:ex_task` to your list of compilers in `project/0`:

```elixir
  compilers: [:ex_task] ++ Mix.compilers,
```


And that's it. The command above invoke [installing script](https://taskfile.dev/installation#install-script) and the `task` command that is just installed.  

## Publishing a package to Hex.pm

When publishing a package to Hex.pm using `ex_task` requires you to add any file (such as the Taskfile.yml and any source files) to the `files` option. See [the hex docs](https://hex.pm/docs/publish#adding-metadata-to-code-classinlinemixexscode)

```elixir
  defp package do
    [
      # ...
      files: [
        "lib", "LICENSE", "mix.exs", "README.md", # These are the default files
        "src/*.[ch]", "Taskfile.yml"], # You will need to add something like this.
      # ...
    ]
  end
```

## License

Copyright (c) 2024 University of Kitakyushu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

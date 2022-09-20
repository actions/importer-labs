# Using custom transformers to customize Valet's behavior

In this lab we will build upon the `dry-run` command to override Valet's default behavior and customize the converted workflow using "custom transformers". Custom transformers can be used to:

1. Convert items that are not automatically converted.
2. Convert items that were automatically converted using different actions.
3. Convert environment variable values differently.
4. Convert references to runners to use a different runner name in Actions.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and bootstrap an Azure DevOps project.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).
4. Completed the [dry-run lab](./4-dry-run.md).

## Perform a dry run

You will perform a dry-run for a pipeline in the bootstrapped Azure DevOps project. Answer the following questions before running this command:

1. What is the id of the pipeline to convert?
    - __:pipeline_id__. This id can be found by:
      - Navigating to the build pipelines in the bootstrapped Azure DevOps project <https://dev.azure.com/:organization/:project/_build>
      - Selecting the pipeline with the name "valet-custom-transformer-example"
      - Inspecting the URL to locate the pipeline id <https://dev.azure.com/:organization/:project/_build?definitionId=:pipeline_id>

2. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory from which Valet commands are executed.

### Steps

1. Navigate to the codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh valet dry-run azure-devops pipeline --pipeline-id :pipeline_id --output-dir tmp/dry-run
    ```

3. The command will list all the files written to disk when the command succeeds.
4. View the converted workflow:
    - Find `tmp/dry-run` in the file explorer pane in your codespace.
    - Click `valet-custom-transformer-example.yml` to open.

The converted workflow that is generated can be seen below:

<details>
  <summary><em>Converted workflow 👇</em></summary>

```yaml
name: valet-bootstrap/pipelines/valet-custom-transformer-example
on:
  push:
    branches:
    - "*"
env:
  BUILDCONFIGURATION: Release
  BuildParameters_RESTOREBUILDPROJECTS: "**/*.csproj"
jobs:
  Job_1:
    name: Agent job 1
    runs-on:
      - self-hosted
      - mechamachine
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - uses: actions/checkout@v2
    - name: Use Node 10.16.3
      uses: actions/setup-node@v2
      with:
        node-version: 10.16.3
    - name: Restore
      run: dotnet restore ${{ env.BuildParameters_RESTOREBUILDPROJECTS }}
    - name: Build
      run: dotnet build ${{ env.BuildParameters_RESTOREBUILDPROJECTS }} --configuration ${{ env.BUILDCONFIGURATION }}
```

</details>

_Note_: You can refer to the previous [lab](./4-dry-run.md) to learn about the fundamentals of the `dry-run` command.

## Custom transformers for build steps

You can use custom transformers to override Valet's default behavior. In this scenario, you may want to override the behavior for converting `DotnetCoreCLI@2` tasks to support parameters that are glob patterns. Answer the following questions before writing a custom transformer:

1. What is the "identifier" of the step to customize?
    - __DotnetCoreCLI@2__

2. What is the desired Actions syntax to use instead?
      - After some research, you have determined that the following script will provide the desired functionality:

      ```yaml
        - run: shopt -s globstar; for f in ./**/*.csproj; do dotnet build $f --configuration ${{ env.BUILDCONFIGURATION }} ; done
          shell: bash
      ```

Now you can begin to write the custom transformer. Custom transformers use a DSL built on top of Ruby and should be defined in a file with the `.rb` file extension. You can create this file by running the following command in your codespace terminal:

```bash
touch transformers.rb && code transformers.rb
```

To build this custom transformer, you first need to inspect the `item` keyword to programmatically obtain the projects, command, and arguments to use in the `DotNetCoreCLI@2` step.

To do this, you will print `item` to the console. You can achieve this by adding the following custom transformer to `transformers.rb`:

```ruby
transform "DotNetCoreCLI@2" do |item|
  puts "This is the item: #{item}"
end
```

The `transform` method can use any valid ruby syntax and should return a `Hash` that represents the YAML that should be generated for a given step. Valet will use this method to convert a step with the provided identifier and will use the `item` parameter for the original values configured in Azure DevOps.

Now, we can perform a `dry-run` command with the `--custom-transformers` CLI option. The output of the `dry-run` command should look similar to this:

```console
$ gh valet dry-run azure-devops pipeline --pipeline-id 6 --output-dir tmp/dry-run --custom-transformers transformers.rb
[2022-09-20 18:39:50] Logs: 'tmp/dry-run/log/valet-20220920-183950.log'         
This is the item: {"command"=>"restore", "projects"=>"$(BuildParameters.RESTOREBUILDPROJECTS)"}
This is the item: {"projects"=>"$(BuildParameters.RESTOREBUILDPROJECTS)", "arguments"=>"--configuration $(BUILDCONFIGURATION)"}
[2022-09-20 18:39:51] Output file(s):
[2022-09-20 18:39:51]   tmp/dry-run/lab-test/pipelines/valet-custom-transformer-example.yml
```

In the above command you will see two instances of `item` printed to the console. This is because there are two `DotNetCoreCLI@2` steps in the pipeline. Each item listed above represents each `DotNetCoreCLI@2` step in the order that they are defined in the pipeline.

Now that you know the data structure of `item`, you can access the dotnet projects, command, and arguments programmatically by editing the custom transformer to the following:

```ruby
transform "DotNetCoreCLI@2" do |item|
  projects = item["projects"]
  command = item["command"]
  run_command = []

  if projects.include?("$")
    command = "build" if command.nil?
    run_command << "shopt -s globstar; for f in ./**/*.csproj; do dotnet #{command} $f #{item['arguments']} ; done"
  else
    run_command << "dotnet #{command} #{item['projects']} #{item['arguments']}"
  end

  {
    run:   run_command.join("\n"),
    shell: "bash",
  }
end
```

Now you can perform another `dry-run` command and use the `--custom-transformers` CLI option to provide this custom transformer. Run the following command within your codespace terminal:

```bash
gh valet dry-run azure-devops pipeline --pipeline-id :pipeline_id --output-dir tmp/dry-run --custom-transformers transformers.rb
```

Open the workflow that is generated and inspect the contents. Now the `DotnetCoreCLI@2` steps are converted using the customized behavior!

```diff
-    - name: Restore
-      run: dotnet restore ${{ env.BuildParameters_RESTOREBUILDPROJECTS }}
-    - name: Build
-      run: dotnet build ${{ env.BuildParameters_RESTOREBUILDPROJECTS }} --configuration ${{ env.BUILDCONFIGURATION }}
+    - name: Restore
+      run: shopt -s globstar; for f in ./**/*.csproj; do dotnet restore $f  ; done
+      shell: bash
+    - name: Build
+      run: shopt -s globstar; for f in ./**/*.csproj; do dotnet build $f --configuration ${{ env.BUILDCONFIGURATION }} ; done
+      shell: bash
```

## Custom transformers for environment variables

You can also use custom transformers to edit the values of environment variables in converted workflows. In this example, you will be updating the `BUILDCONFIGURATION` environment variable to be `Debug` instead of `Release`.

To do this, add the following code at the top of the `transformers.rb` file.

```ruby
env "BUILDCONFIGURATION", "Debug"
```

In this example, the first parameter to the `env` method is the environment variable name and the second is the updated value.

Now you can perform another `dry-run` command with the `--custom-transformers` CLI option.  When you open the converted workflow, the `DB_ENGINE` environment variable will be set to `mongodb`:

```diff
env:
-  BUILDCONFIGURATION: Release
+  BUILDCONFIGURATION: Debug
  BuildParameters_RESTOREBUILDPROJECTS: "**/*.csproj"
```

## Custom transformers for runners

Finally, you can use custom transformers to dictate which runners converted workflows should use. First, answer the following questions:

1. What is the label of the runner in Azure DevOps to update?
    - __mechamachine__

2. What is the label of the runner in Actions to use instead?
    - __ubuntu-latest__

With these questions answered, you can add the following code to the `transformers.rb` file:

```ruby
runner "mechamachine", "ubuntu-latest"
```

In this example, the first parameter to the `runner` method is the Azure DevOps label and the second is the Actions runner label.

Now you can perform another `dry-run` command with the `--custom-transformers` CLI option.  When you open the converted workflow, the `runs-on` statement will use the customized runner label:

```diff
-    runs-on:
-      - self-hosted
-      - mechamachine
+    runs-on: ubuntu-latest
```

At this point, the file contents of `transformers.rb` should match this:

<details>
  <summary><em>Custom transformers 👇</em></summary>

```ruby
transform "DotNetCoreCLI@2" do |item|
  projects = item["projects"]
  command = item["command"]
  run_command = []

  if projects.include?("$")
    command = "build" if command.nil?
    run_command << "shopt -s globstar; for f in ./**/*.csproj; do dotnet #{command} $f #{item['arguments']} ; done"
  else
    run_command << "dotnet #{command} #{item['projects']} #{item['arguments']}"
  end

  {
    shell: "bash",
    run:   run_command.join("\n")
  }
end

env "BUILDCONFIGURATION", "Debug"

runner "mechamachine", "ubuntu-latest"
```

</details>

That's it! At this point you have overridden Valet's default behavior by customizing the conversion of:

- Build steps
- Environment variables
- Runners

## Next lab

[Perform a production migration of an Azure DevOps pipeline](6-migrate.md)

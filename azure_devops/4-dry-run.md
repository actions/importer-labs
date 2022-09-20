# Perform a dry-run migration of an Azure DevOps pipeline

In this lab you will use the `dry-run` command to convert an Azure DevOps pipeline to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and bootstrap an Azure DevOps project.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

You will perform a dry run for a pipeline in the bootstrapped Azure DevOps project. Answer the following questions before running this command:

1. What is the id of the pipeline to convert?
    - __:pipeline_id__. This id can be found by:
      - Navigating to the build pipelines in the bootstrapped Azure DevOps project <https://dev.azure.com/:organization/:project/_build>
      - Selecting the pipeline with the name "valet-pipeline1"
      - Inspecting the URL to locate the pipeline id <https://dev.azure.com/:organization/:project/_build?definitionId=:pipeline_id>

2. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory from which Valet commands are executed.

### Steps

1. Navigate to your codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh valet dry-run azure-devops pipeline --pipeline-id :pipeline_id --output-dir tmp/dry-run
    ```

3. The command will list all the files written to disk when the command succeeds.
4. View the converted workflow:
    - Find `tmp/dry-run` in the file explorer pane in your codespace.
    - Click `valet-pipeline1.yml` to open.

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the given Azure DevOps pipeline. The Azure DevOps pipeline and converted workflow can be seen below:

<details>
  <summary><em>Azure DevOps pipeline 👇</em></summary>

```yaml
trigger:
- main

pool:
  vmImage: windows-latest

steps:
- script: echo Hello, I am pipeline 1!
  displayName: 'Run a one-line script'

- script: |
    echo Add other tasks to build, test, and deploy your project.
    echo See https://aka.ms/yaml
  displayName: 'Run a multi-line script'
```

</details>

<details>
  <summary><em>Converted workflow 👇</em></summary>

```yaml
name: valet-bootstrap/pipelines/valet-pipeline1
on:
  push:
    branches:
    - main
jobs:
  build:
    runs-on: windows-latest
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: Run a one-line script
      run: echo Hello, I am pipeline 1!
    - name: Run a multi-line script
      run: |-
        echo Add other tasks to build, test, and deploy your project.
        echo See https://aka.ms/yaml
```

</details>

Despite these two pipelines using different syntax they will function equivalently.

## Next lab

[Use custom transformers to customize Valet's behavior](./5-custom-transformers.md)

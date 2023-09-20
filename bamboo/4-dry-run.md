# Perform a dry-run migration of a Bamboo build plan.

In this lab you will use the `dry-run` command to convert a Bamboo build plan to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the [steps to set up your GitHub Codespaces](./readme.md#configure-your-codespace) environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

You will be performing a dry run against a single Bamboo pipeline. Answer the following questions before running this command:

1. What is the plan slug of the pipeline you want to convert?

    - __MARS-ROCKET__

2. Where do you want to store the result?
    - __tmp/dry-run__
        - This can be any path within the working directory from which GitHub Actions Importer commands are executed.

3. Which file would you like to convert?

    - __bamboo/bootstrap/source_files/bamboo/bamboo.yml__

4. Are you converting a build or deployment plan?
    - The supplied configuration is a build plan.

### Steps

1. Navigate to your codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer dry-run bamboo build --source-file-path bamboo/bootstrap/source_files/bamboo/bamboo.yml -p MARS-ROCKET --output-dir tmp/dry-run
    ```
    > Note: The `--source-file-path` option is not required and is used throughout this lab to convert a pipeline that is stored locally. This can be omitted and GitHub Actions Importer will programmatically fetch pipelines using the Bamboo REST APIs

3. The command will list all the files written to disk when the command succeeds.

    ```console
    Logs: 'tmp/dry-run/log/valet.log'
    Output file(s):
      tmp/dry-run/build/mars/sample_plan/.github/workflows/sample_plan.yml
    ```

4. View the converted workflow:
    - Find `tmp/dry-run/build/mars/sample_plan/.github/workflows` in the file explorer pane in your codespace.
    - Click `sample_plan.yml` to open.

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the provided Bamboo pipeline.

## Next lab

[Use custom transformers to customize GitHub Actions Importer's behavior](5-custom-transformers.md)

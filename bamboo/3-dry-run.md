# Perform a dry-run migration of a Bamboo build plan.

In this lab you will use the `dry-run` command to convert a Bamboo build plan to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

You will be performing a dry run against a single Bamboo pipeline. Answer the following questions before running this command:

1. What is the planslug of the pipeline you want to convert?

    ```
    export PLAN_SLUG=MARS-ROCKET
    ```

2. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory from which GitHub Actions Importer commands are executed.

3. Which file would you like to conver?

    ```
    export SOURCE_FILE_PATH=bamboo/bootstrap/source_files/bamboo/bamboo.yml
    ```

4. Are you converting a build or deployment plan?
    - The supplied configuration is a build plan.

### Steps

1. Navigate to your codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer dry-run bamboo build --source-file-path $SOURCE_FILE_PATH -p $PLAN_SLUG--output-dir tmp/dry-run
    ```

3. The command will list all the files written to disk when the command succeeds.

    ```console
    $ gh actions-importer dry-run bamboo build
    ```

4. View the converted workflow:
    - Find `tmp/dry-run/test_pipeline/.github/workflows` in the file explorer pane in your codespace.
    - Click `test_pipeline.yml` to open.

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the provided Bamboo pipeline.

## Next lab

[Use the migrate command to open a PR with the supplied workflow.](4-migrate.md)

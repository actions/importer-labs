# Perform a production migration of a Bitbucket pipeline

In this lab, you will use the `migrate` command to convert a Bitbucket pipeline and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [dry-run lab](./4-dry-run.md).

## Performing a migration

Answer the following questions before running a `migrate` command:

1. What repository do you want to migrate?
    - __basic-pipeline__
2. What is the workspace for that repository?
    - __actions-importer__
3. Where do you want to store the logs?
    - __tmp/migrate__
4. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

### Steps

1. Run the below `migrate` command in the codespace terminal, remember to update the `--target-url` before executing:

    ```bash
    gh actions-importer migrate bitbucket --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --workspace actions-importer --repository basic-pipeline --source-file-path ./bitbucket/bootstrap/source_files/basic_pipeline.yml
    ```
    Note: The `--source-file-path` option is not required and is used throughout this lab to convert files that are stored locally. This can be omitted and GitHub Actions Importer will programmatically fetch pipeline definitions using the Bitbucket REST APIs.
2. The command will write the URL to the pull request that was created when the command succeeds.

    ```console
    $ gh actions-importer migrate bitbucket --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --workspace actions-importer --repository basic-pipeline --source-file-path ./bitbucket/bootstrap/source_files/basic_pipeline.yml
    [2022-08-20 22:08:20] Logs: 'tmp/migrate/log/actions-importer-20220916-014033.log'
    [2022-08-20 22:08:20] Pull request: 'https://github.com/:owner/:repo/pull/1'
    ```

3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The first thing to notice about the pull request is that there is a list of manual steps to complete.

Next, you can inspect the "Files changed" in this pull request and see the converted workflow that is being added. Any additional changes or code reviews that were needed should be done in this pull request.

Finally, you can merge the pull request once your review has completed. You can then view the workflow running by selecting the "Actions" menu in the top navigation bar in GitHub.

At this point, the migration has completed and you have successfully migrated a Bitbucket pipeline to Actions!

### Next Lab

This concludes all labs for migrating Bitbucket pipelines to Actions with GitHub Actions Importer!

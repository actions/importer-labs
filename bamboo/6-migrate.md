# Perform a production migration of a Bamboo plan

In this lab, you will use the `migrate` command to convert a Bamboo plan and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the [steps to set up your GitHub Codespaces](./readme.md#configure-your-codespace) environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

3. Completed the [dry-run lab](./4-dry-run.md).

## Performing a migration

Answer the following questions before running a `migrate` command:

1. What is the plan slug of the pipeline you want to migrate?
    - __MARS-ROCKET__
    
2. Where do you want to store the logs?
    - __tmp/migrate__
    
3. Which file would you like to convert?
    - __bamboo/bootstrap/source_files/bamboo/bamboo.yml__

4. Are you converting a build or deployment plan?
    - The supplied configuration is a build plan.

5. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

### Steps

1. Run the following `migrate` command in your codespace terminal:

    ```bash
   gh actions-importer migrate bamboo build -p MARS-ROCKET --target-url <target_url> --output-dir tmp/migrate --source-file-path bamboo/bootstrap/source_files/bamboo/bamboo.yml
    ```

    Note: The `--source-file-path` option is not required and is used throughout this lab to convert files that are stored locally. This can be omitted and GitHub Actions Importer will programmatically fetch pipeline definitions using the Bamboo REST APIs.

2. The command will write the URL to the pull request that is created when the command succeeds.


3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The pull request contains a list of manual steps to complete.

Inspect the "Files changed" in this pull request and see the converted workflow. Any additional changes or code reviews that were needed should be done in this pull request.

Finally, you can merge the pull request once your review has completed. You can then view the workflow running by selecting the "Actions" menu in the top navigation bar in GitHub.

At this point, the migration has completed and you have successfully migrated a Bamboo build plan to Actions!

### Next lab

This concludes all labs for migrating a Bamboo plan Actions with GitHub Actions Importer!

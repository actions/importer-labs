# Perform a production migration of a Travis CI pipeline

In this lab, you will use the `migrate` command to convert a Travis CI pipeline and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [dry-run lab](./3-dry-run.md).

## Performing a migration

Answer the following questions before running a `migrate` command:

1. What project do you want to migrate?
    - __travisci-deploy-example__
2. Where do you want to store the logs?
    - __./tmp/migrate__
3. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

### Steps

1. Run the following `migrate` command in the codespace terminal. Ensure the values in `--target-url` for `:owner` and `:repo` are replaced with your values:

    ```bash
    gh valet migrate travis-ci --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --travis-ci-repository "travisci-deploy-example"
    ```

2. The command will write the URL to the pull request that was created when the command succeeds.

    ```console
    $ gh valet migrate travis-ci --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --travis-ci-repository "travisci-deploy-example"
    [2022-08-20 22:08:20] Logs: 'tmp/migrate/log/valet-20220916-014033.log'
    [2022-08-20 22:08:20] Pull request: 'https://github.com/:owner/:repo/pull/1'
    ```

3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The first thing to notice about the pull request is that there is a list of manual steps to complete.

Next, you can inspect the "Files changed" in this pull request and see the converted workflow that is being added. Any additional changes or code reviews that were needed should be done in this pull request.

![action-run](https://user-images.githubusercontent.com/19557880/190726209-dd9ddc54-5ac7-4951-b525-24d76d4378ab.png)

Finally, you can merge the pull request once your review has completed. You can then view the workflow running by selecting the "Actions" menu in the top navigation bar in GitHub.

At this point, the migration has completed and you have successfully migrated a Travis CI pipeline to Actions!

## Next steps

This concludes all labs for migrating Travis CI pipelines to Actions with Valet!

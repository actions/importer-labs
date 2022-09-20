# Perform a production migration of a Jenkins pipeline

In this lab, you will use the `migrate` command to convert a Jenkins pipeline and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and start a Jenkins server.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [dry-run lab](./4-dry-run.md).

## Performing a migration

Answer the following questions before running a `migrate` command:

1. What is the source URL of the pipeline you want to convert?
    - __<http://localhost:8080/monas_dev_work/job/monas_freestyle>__
2. Where do you want to store the logs?
    - __tmp/migrate__
3. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

### Steps

1. Run the following `migrate` command in your codespace terminal:

    ```bash
    gh valet migrate jenkins --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --source-url http://localhost:8080/job/monas_dev_work/job/monas_freestyle
    ```

2. The command will write the URL to the pull request that was created when the command succeeds.

    ```console
    $ gh valet migrate jenkins --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --source-url http://localhost:8080/job/monas_dev_work/job/monas_freestyle
    [2022-08-20 22:08:20] Logs: 'tmp/migrate/log/valet-20220916-014033.log'
    [2022-08-20 22:08:20] Pull request: 'https://github.com/:owner/:repo/pull/1'
    ```

3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The first thing we should notice about the pull request is that there is a list of manual steps to complete:

![img](https://user-images.githubusercontent.com/19557880/186784161-b7882ac4-ac99-4462-b69f-f49b9202527b.png)

Next, you can inspect the "Files changed" in this pull request and see the converted workflow that is being added. Any additional changes or code reviews that were needed should be done in this pull request.

Finally, you can merge the pull request once your review has completed. You can then view the workflow running by selecting the "Actions" menu in the top navigation bar in GitHub.

![img](https://user-images.githubusercontent.com/19557880/185509704-90243ec5-e77f-4baf-a9b2-d9a4d9fda199.png)

At this point, the migration has completed and you have successfully migrated a Jenkins pipeline to Actions!

### Next lab

This concludes all labs for migrating Jenkins pipelines to Actions with Valet!

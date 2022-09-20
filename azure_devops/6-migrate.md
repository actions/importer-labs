# Perform a production migration of an Azure DevOps pipeline

In this lab, you will use the `migrate` command to convert an Azure DevOps pipeline and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and bootstrap an Azure DevOps project.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [dry-run lab](./4-dry-run.md).

## Performing a migration

Answer the following questions before running a `migrate` command:

1. What is the id of the pipeline to convert?
    - __:pipeline_id__. This id can be found by:
      - Navigating to the build pipelines in the bootstrapped Azure DevOps project <https://dev.azure.com/:organization/:project/_build>
      - Selecting the pipeline with the name "valet-pipeline2"
      - Inspecting the URL to locate the pipeline id <https://dev.azure.com/:organization/:project/_build?definitionId=:pipeline_id>
2. Where do you want to store the logs?
    - __tmp/migrate__
3. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

### Steps

1. Run the following `migrate` command in the codespace terminal:

    ```bash
    gh valet migrate azure-devops pipeline --pipeline-id :pipeline_id --target-url https://github.com/:owner/:repo --output-dir tmp/migrate
    ```

2. The command will write the URL to the pull request that was created when the command succeeds.

   ```console
   $ gh valet migrate azure-devops pipeline --pipeline-id 8 --target-url https://github.com/ethanis/labs --output-dir tmp/migrate
   [2022-09-07 20:25:08] Logs: 'tmp/dry-run/log/valet-20220907-202508.log'
   [2022-09-07 20:25:13] Pull request: 'https://github.com/ethanis/labs/pull/42'
   ```

3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The first thing to notice about the pull request is that there is a list of manual steps to complete:

![img](https://user-images.githubusercontent.com/8703324/189002125-45561312-dd26-42fd-bd38-a596614ee871.png)

Next, you can inspect the `Files changed` in this pull request to see the converted workflow that is being added. Any additional changes or code reviews that were needed should be done in this pull request.

Finally, you can merge the pull request once your review has completed. You can then view the workflow running by selecting the `Actions` menu in the top navigation bar in GitHub.

![img](https://user-images.githubusercontent.com/19557880/185509704-90243ec5-e77f-4baf-a9b2-d9a4d9fda199.png)

At this point, the migration has completed and you have successfully migrated an Azure DevOps pipeline to Actions!

### Next lab

This concludes all labs for migrating Azure DevOps pipelines to Actions with Valet!

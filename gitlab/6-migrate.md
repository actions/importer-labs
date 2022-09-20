# Perform a production migration of a GitLab pipeline

In this lab, you will use the `migrate` command to convert a GitLab pipeline and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and start a GitLab server.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [dry-run lab](./4-dry-run.md).

## Performing a migration

Answer the following questions before running a `migrate` command:

1. What project do you want to migrate?
    - __rails-example__
2. What is the namespace for that project?
    - __Valet__
3. Where do you want to store the logs?
    - __tmp/migrate__
4. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

### Steps

1. Run the following `migrate` command in the codespace terminal:

    ```bash
    gh valet migrate gitlab --target-url https://github.com/:owner/:repo --output-dir tmp/migrate --namespace valet --project rails-example
    ```

2. The command will write the URL to the pull request that was created when the command succeeds.

    ![img](https://user-images.githubusercontent.com/18723510/184953133-9bafd9a1-c3f0-40b3-8414-f23cea698c8e.png)

3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The first thing to notice about the pull request is that there is a list of manual steps to complete.

Next, you can inspect the "Files changed" in this pull request and see the converted workflow that is being added. Any additional changes or code reviews that were needed should be done in this pull request.

Finally, you can merge the pull request once your review has completed. You can then view the workflow running by selecting the "Actions" menu in the top navigation bar in GitHub.

![img](https://user-images.githubusercontent.com/18723510/184960870-590b1a28-422f-4350-9ec0-0423bf7ad445.png)

At this point, the migration has completed and you have successfully migrated a GitLab pipeline to Actions!

### Next Lab

This concludes all labs for migrating GitLab pipelines to Actions with Valet!

# Perform a production migration of a Jenkins pipeline

In this lab, you will use the `migrate` command to convert a Jenkins pipeline and open a pull request with the equivalent Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment and start a Jenkins server.
2. Completed the [configure lab](./1-configure-lab.md#configuring-credentials).
3. Completed the [dry-run lab](./3-dry-run.md).
4. Completed the [custom transformers lab](./4-custom-transformers.md).

## Preparing for migration

We need to answer the following questions before running a `migrate` command:

1. What is the source URL of the pipeline we want to convert?
    - __<http://localhost:8080/monas_dev_work/job/monas_freestyle>__
2. Where do we want to store the result?
    - __./tmp/migrate__
3. What is the URL for the GitHub repository to add the workflow to?
    - __this repository__. The URL should should follow the pattern <https://github.com/:owner/:repo> with `:owner` and `:repo` replaced with your values.

## Performing a migration

1. Run the following `migrate` command in the codespace terminal:

    ```bash
    gh valet migrate jenkins --target-urlhttps://github.com/:owner/:repo --output-dir ./tmp/migrate --source-url http://localhost:8080/job/monas_dev_work/job/monas_freestyle
    ```

2. The command will write the URL to the pull request that was created when the command succeeds.
    ![img](https://user-images.githubusercontent.com/19557880/185509412-ab64d92d-2a56-4d5a-bbb4-35a41a2ca48c.png)

3. Open the generated pull request in a new browser tab.

### Inspect the pull request

The first thing we should notice about the PR is that there is a list of manual steps for us to complete:

![img](https://user-images.githubusercontent.com/19557880/186784161-b7882ac4-ac99-4462-b69f-f49b9202527b.png)

Next, let's review the workflow we are adding by clicking on `Files changed` tab. This is where you would double check everything looks good. If it didn't you could push commits with the required changes, prior to merging.

Next, you can inspect the "Files changed" in this PR and see the converted workflow that is being added. Any additional changes or code reviews that were needed should be done in this PR.

Finally, you can merge the PR once your review has completed. We can then view the workflow running by selecting the "Actions" menu in the top navigation bar in GitHub.

![img](https://user-images.githubusercontent.com/19557880/185509704-90243ec5-e77f-4baf-a9b2-d9a4d9fda199.png)

At this point, the migration has completed and you have successfully migrated a Jenkins pipeline to Actions!

### Next lab

[Forecast potential build runner usage](6-forecast.md)

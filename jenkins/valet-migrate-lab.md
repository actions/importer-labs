# Migrate an Jenkins Project to GitHub Actions

In this lab, we will use the Valet `migrate` command to migrate a Jenkins pipeline to GitHub Actions.
The previous commands used in the labs, such as `audit` and `dry-run` have prepared us to run a migration.
The `migrate` command will transform the Jenkins pipeline into a GitHub Actions workflow like the `dry-run` command did, but instead of writing these files locally, it will open a pull request with the files.
The pull request will contain a checklist of `Manual Tasks` if required. These tasks are changes that Valet could not do on our behalf, like creating a runner or adding a secret to a repository.

- [Prerequisites](#prerequisites)
- [Preparing for migration](#preparing-for-migration)
- [Performing the migration](#performing-a-migration)
- [Reviewing the pull request](#reviewing-the-pull-request)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../jenkins#readme) to set up your codespace environment.
2. Completed the [configure lab](../jenkins/valet-configure-lab.md)
3. Completed the [dry-run lab](../jenkins/valet-dry-run-lab.md)
4. Completed the [dry-run lab with custom transformer](../jenkins/valet-custom-transformers-lab.md)

## Preparing for migration

Before running the command we need to collect some information:

  1. What is the name of the pipeline we want to convert? __monas_dev_work/job/monas_freestyle__
  2. What is the source URL of the pipeline we want to convert? __<http://localhost:8080/monas_dev_work/job/monas_freestyle>__
  3. Where do we want to store the result? __./tmp/migrate__.
  4. What is the URL for the GitHub repository we want to add the workflow too? __this repo!__. *When constructing the value for the migrate command it should match this url <https://github.com/GITHUB-ORG-USERNAME-HERE/GITHUB-REPO-NAME-HERE> with `GITHUB-ORG-USERNAME` and `GITHUB-REPO-NAME` substitued with your values*  

## Performing a migration

1. Run `migrate` command using the information collected above, make sure to update the `--target-url` value with the information from step 4.

```bash
gh valet migrate jenkins --target-url https://github.com/GITHUB-ORG-USERNAME-HERE/GITHUB-REPO-NAME-HERE --output-dir ./tmp/migrate --source-url http://localhost:8080/job/monas_dev_work/job/monas_freestyle
```

2. Valet will create a pull request directly in the target GitHub repository.
3. Open the pull request by clicking the green pull request link in the output of the migrate command, if you have trouble clicking it you can always copy and paste the url in your browser.
  ![pr-screen-shot](https://user-images.githubusercontent.com/19557880/185509412-ab64d92d-2a56-4d5a-bbb4-35a41a2ca48c.png)

## Reviewing the pull request

- Lets first look at the `Conversation` tab of the PR. It tells us we have a manual task to perform before the GitHub Actions workflow is functional.  We need to add a secret. We can use the GitHub [documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for secrets and add a `actions` secret for `EXPRESSION_FIRST_VAR` with any value.

- Next, lets review the workflow we are adding by clicking on `Files changed` tab. This is where you would double check everything looks good. If it didn't you could push commits with the required changes, prior to merging.

- Now our review is completed we want to go back to the `Conversation` tab and click `Merge pull request`

- Once the PR is merged the new workflow should start and we can view it by clicking `Actions` in the top navigation
  <img width="1119" alt="actions-screen-shot" src="https://user-images.githubusercontent.com/19557880/185509704-90243ec5-e77f-4baf-a9b2-d9a4d9fda199.png">
- The migration is complete and we have successfully transformed a pipeline from Jenkins into a GitHub Actions workflow, added it to a GitHub Repository, and run the workflow in Actions.

### Next Lab

[Forecast Jenkins Usage](../Jenkins/valet-forecast-lab.md)

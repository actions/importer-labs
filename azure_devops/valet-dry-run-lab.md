# Dry run the migration of an Azure DevOps pipeline to GitHub Actions
In this lab, you will use the `valet dry-run` command to convert an Azure DevOps pipeline to it's equivalent GitHub Actions workflow and write the workflow to your local filesystem.

- [Prerequisites](#prerequisites)
- [Identify the Azure DevOps pipeline ID to use](#identify-the-azure-devops-pipeline-id-to-use)
- [Perform a dry run](#perform-a-dry-run)
- [View dry-run output](#view-dry-run-output)

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)
3. You have completed the [Valet audit lab](valet-audit-lab.md).
4. Verify or add the following values to the `valet/.env.local` file. All values were created [here](/labs/azure_devops#readme)
```
GITHUB_ACCESS_TOKEN=<GithHub PAT generated>
GITHUB_INSTANCE_URL=https://github.com/

AZURE_DEVOPS_PROJECT=<Project identified>
AZURE_DEVOPS_ORGANIZATION=<Org identified>
AZURE_DEVOPS_INSTANCE_URL=<DevOps instance>
AZURE_DEVOPS_ACCESS_TOKEN=<Token Generated>
```
### Example ###

![envlocal](https://user-images.githubusercontent.com/26442605/169069638-0bfa8f89-eaa9-423b-b2b7-447248e63e2b.png)

## Identify the Azure DevOps pipeline ID to use
You will need a pipeline ID to perform the dry run
1. Go to the `valet/ValetBootstrap/pipelines` folder
2. Open the `valet/ValetBootstrap/pipelines/valet-pipeline1.json` file
3. Look for the `$.web.href` link
4. At the end of the link is the pipeline ID. Copy or note the ID.

### Example
![valet-dr-5](https://user-images.githubusercontent.com/26442605/169616920-7c407adc-0c4e-4104-9046-d1d2ecdd6edf.png)

## Perform a dry run
You will use the codespace preconfigured in this repository to perform the dry run.

1. Navigate to the codespace Visual Studio Code terminal 
2. Verify you are in the `valet` directory
  
```
gh valet dry-run azure-devops pipeline --pipeline-id PIPELINE-ID --output-dir dry-runs
```
3. Now, from the `valet` folder in your repository, run `gh valet dry-run` to see the output: 

### Example
![valet-dr-1](https://user-images.githubusercontent.com/26442605/169616149-46c2d743-47fe-4061-a48a-7f21442624cb.png)

4. Valet will create a folder called `dry-runs` under the `valet` folder that shows what will be migrated.  

### Example
![valet-dr-2](https://user-images.githubusercontent.com/26442605/169616265-176a19fd-3071-44fc-bff7-866a172afc57.png)

## View dry-run output
The dry-run output will show you the GitHub Actions yml that will be migrated to GitHub.

### Example
![valet-dr-3](https://user-images.githubusercontent.com/26442605/169616486-fd5512fa-0761-45fe-a252-5b2ef0926a04.png)


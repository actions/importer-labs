# Dry run the migration of an Azure DevOps pipeline to GitHub Actions
In this lab, you will use the `valet dry-run` command on one Azure DevOps pipeline.

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)
3. You have completed the [Valet audit lab](valet-audit-lab.md).

## Identify the Azure DevOps pipeline ID to use
You will need a pipeline ID to perform the dry run
1. Go to the `scripts/ValetBootstrap/pipelines` folder
2. Open the `scripts/ValetBootstrap/pipelines/valet-mapper-example.config.json` file
3. Look for the `web - href` link
4. At the end of the link is the pipeline ID. Copy or note the ID.

### Example
![configpipelineid](https://user-images.githubusercontent.com/26442605/161106098-3b9b05ec-ee5d-4b21-ab07-9f05f8cf1d98.png)


## Perform a dry run
You will use the codespace preconfigured in this repository to perform the dry run.

1. Navigate to the codespace Visual Studio Code terminal 
2. Verify you are in the scripts directory
3. Copy the following command and replace:
   - `GITHUB-ORG` with the name of your organization. 
   - `GITHUB-REPO` with the name of your repository. 
   - `PIPELINE-ID` with your pipeline ID.
  
```
cd scripts
valet dry-run azure-devops pipeline --target-url https://github.com/GITHUB-ORG/GITHUB-REPO --pipeline-id PIPELINE-ID --output-dir .dry-runs
```
4. Now, from the `./scripts` folder in your repository, run `valet dry-run` to see the output: 

### Example
![dryrun-ex2](https://user-images.githubusercontent.com/26442605/161107259-39076729-2ac8-4104-8170-11061b732593.png)

4. Valet will create a folder called `dry-runs` under the scripts folder that shows what will be migrated.  

### Example
![dryrun-output](https://user-images.githubusercontent.com/26442605/161106810-6a48b261-8099-449b-a41c-3d1e0903485a.png)

## View dry-run output
The dry-run output will show you the GitHub Actions yml that will be migrated to GitHub.

### Example
![dryrunyml](https://user-images.githubusercontent.com/26442605/161108244-28da94d6-c28d-4484-bc08-cb3392d7745e.png)

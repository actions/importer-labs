# Audit Azure DevOps pipelines using the Valet audit command
In this lab, you will use Valet to audit Azure DevOps pipelines in an Azure DevOps project.

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)

## Perform an audit
You will use the codespace preconfigured in this repository to perform the audit.

1. Navigate to the codespace Visual Studio Code terminal 
2. Verify you are in the scripts directory
3. Now, from the `./scripts` folder in your repository, run Valet to verify your Azure DevOps configuration:
  
```
cd scripts
valet audit azure-devops --output-dir . 
```
### Example
![runaudit](https://user-images.githubusercontent.com/26442605/160930617-d4d2f4a8-7b39-47d6-ab2c-60868cb56e5f.png)

4. Valet displays green log files to indicate a successful audit  

### Example
![audit-output](https://user-images.githubusercontent.com/26442605/161104845-3d9d7493-794f-4787-9a89-3dd3c15a8a8d.png)

## View audit output
The audit summary, logs, Azure DevOps yml, and GitHub yml should all be located in the scripts folder.

1. Under the `scripts` folder find the `audit_summary.md`
2. Right-click the `auditsummary.md` file and select `Open Preview`
3. The file contains the audit summary details about what can and can't be migrated to GitHub Actions.
4. Review the file.

### Example
![audit-summary](https://user-images.githubusercontent.com/26442605/161105335-4c38ea73-b5a5-4edc-9d89-d6febcae46d4.png)

## Review the pipelines
The `audit` command grabs the yml, classic, and release pipelines from Azure DevOps and converts them to GitHub Actions.

### Example
View the source yml and the proposed GitHub yml
![audit-pipelines](https://user-images.githubusercontent.com/26442605/161105649-dd20235d-bb98-4949-baa3-dac561427257.png)

# Audit Azure DevOps pipelines using the Valet audit command
In this lab, you will use Valet to `audit` an Azure DevOps organization. The `audit` command can be used to scan a CI server and output a summary of the current pipelines. This summary can then be used to plan the timeline and effort required to migrate to GitHub Actions.

- [Prerequisites](#prerequisites)
- [Perform an audit](#perform-an-audit)
- [View audit output](#view-audit-output)
- [Review the pipelines](#review-the-pipelines)

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)
3. Verify or add the following values to the `valet/.env.local` file. All values were created [here](/labs/azure_devops#readme)
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

## Perform an audit
You will use the codespace preconfigured in this repository to perform the audit.

1. Navigate to the codespace Visual Studio Code terminal 
2. Verify you are in the `valet` directory
3. Now, from the `valet` folder in your repository, run Valet to verify your Azure DevOps configuration:
  
```
gh valet audit azure-devops --output-dir . 
```
### Example
![valet-audit-1](https://user-images.githubusercontent.com/26442605/169615028-696dad13-ff83-41a7-b475-0ab8c0bbcd65.png)

4. Valet displays green log files to indicate a successful audit  

### Example
![valet-audit-2](https://user-images.githubusercontent.com/26442605/169615218-a8a3199d-a436-4d70-8c1e-17a61b089eb6.png)

## View audit output
The audit summary, logs, Azure DevOps yml, and GitHub yml should all be located in the `valet` folder.

1. Under the `valet` folder find the `audit_summary.md`
2. Right-click the `audit_summary.md` file and select `Open Preview`
3. The file contains details about your current pipelines and what can be migrated 100% automatically vs. what will need some manual intervention or aren't supported by GitHub Actions.
4. Review the file.

### Example
![valet-audit-3](https://user-images.githubusercontent.com/26442605/169615428-26f7a962-2064-46d0-8206-ea930109b252.png)

## Review the pipelines
The `audit` command grabs the yml, classic, and release pipelines from Azure DevOps and converts them to GitHub Actions.

### Example
View the source yml and the proposed GitHub yml
![valet-audit-4](https://user-images.githubusercontent.com/26442605/169615630-8d700081-c631-4b2a-ab1c-e52503f7838f.png)


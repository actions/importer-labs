# Valet labs for Azure DevOps

This lab bootstraps a Valet environment using GitHub Codespaces and enables you to create an Azure DevOps project against which to run the Valet CI/CD migration tool.

- [Use this Repo as a template](#repo-template)
- [Prerequisites](#prerequisites)
- [Azure DevOps project creation](#azure-devops-project-creation)
- [Use Valet with a codespace](#use-valet-with-a-codespace)
- [Labs for Azure DevOps](#labs-for-azure-devops)

## Repo template

1. Click `Use this template` to create this repository inside your GitHub organization.

## Prerequisites
1. Azure DevOps organization. Please identify or create an Azure DevOps organization to use: [Click to create an Azure DevOps Org](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?toc=%2Fazure%2Fdevops%2Fget-started%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fget-started%2Fbreadcrumb%2Ftoc.json&view=azure-devops)
    - Note and store the organization name for later.
2. Create an Azure DevOps personal access token with the following scopes:
    -   To do so, navigate to Sign in to your organization `https://dev.azure.com/{yourorganization}`.
    -   From your home page, open `user settings`, and then select `Personal access tokens`.
    -   Select `+ New Token`
    -   Name your token, select the organization where you want to use the token, and then set your token to automatically expire after a set number of days.
    -   Select the following scopes:
        -   Agents Pool: `Read`
        -   Build: `Read & Execute`
        -   Code: `Full, Execute`
        -   Project and Team: `Read, Write, & Manage`
        -   Release: `Read`
        -   Service Connections: `Read`
        -   Variable Groups: `Read`
    -   Click `Create`
    -   Copy the PAT somewhere safe and temporary.
3. Create a GitHub personal access token. 
    - To do so, navigate to your GitHub `Settings` - click your profile photo and then click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens`
    - Click `Generate new token` -> `Legacy tokens`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the PAT somewhere safe and temporary.
4. Add GitHub personal access token to the CODESPACES **Secrets** tab.
    - Navigate to the `Settings` tab in your repo
    - Find `Secrets` and click the down arrow
    - Click `Codespaces`
    - Click `New Codespaces Secret` to create a new secret.
    - Name the secret `VALET_PASSWORD`
    - Paste in the GitHub PAT generated previously
    - Click `Add Secret`

## Azure DevOps project creation

1. Add your Azure DevOps personal access token to the Actions **Secrets** tab.
    - Navigate to the `Settings` tab in this repo
    - Find `Secrets` and click the down arrow
    - Click `Actions`
    - Click `New Repository Secret` to create a new secret.
    - Name the secret `AZDOPAT`
    - Paste in the Azure DevOps PAT generated previously
    - Click `Add Secret`

2. Add Azure DevOps personal access token, project, and org to the CODESPACES **Secrets** tab.
    - Navigate to the `Settings` tab in your repo
    - Find `Secrets` and click the down arrow
    - Click `Codespaces`
    - Click `New Codespaces Secret` to create a new secret.
    - Name the secret `AZDO_TOKEN`
    - Paste in the Azure DevOps PAT generated previously
    - Click `Add Secret`
    - Click `New Codespaces Secret` to create another secret.
    - Name the secret `AZDO_PROJECT`
    - Type in the Azure DevOps project name. This should be `ValetBootstrap`
    - Click `Add Secret`
    - Click `New Codespaces Secret` to create a new secret.
    - Name the secret `AZDO_ORG`
    - Type in the Azure DevOps organization name
    - Click `Add Secret`
    
3. Run the Actions workflow
    - CLick the `Actions` tab
    - Select the `Valet Bootstrap for Azure DevOps` action
    - Click `Run Workflow`
    - Input the Azure DevOps Organization name identified above
    - Input the Azure DevOps user name of the user that created the Azure DevOps PAT above. This will be an email address
    - Accept the default Azure DevOps project name or change it to one of your preference
    - Click `Run Workflow`
    - Verify the workflow completed successfully

### Example ###
![runaction](https://user-images.githubusercontent.com/26442605/167679930-9bdf6f4f-2e94-4145-aed3-8ee3e8e91d90.png)


## Use Valet with a codespace

1. Start the codespace
    - Click the `Code` button above repository
    - Click the `Codespaces` tab
    - Click `New Codespace`
    - Wait a couple minutes, then verify that the codespace starts up. Once it is fully booted up, the termininal should be present.
2. Run Valet
    - Verify you are in the Visual Studio Code terminal
    - Change to the Valet directory by typing `cd scripts`
    - Run the valet command by typing `valet`. Verify that Valet details all commands.
    - Start using Valet

## Labs for Azure DevOps
Perform the following labs to test-drive Valet
- [Audit Azure DevOps pipelines using the Valet audit command](valet-audit-lab.md)
- [Dry run the migration of an Azure DevOps pipeline to GitHub Actions](valet-dry-run-lab.md)
- [Migrate an Azure DevOps pipeline to GitHub Actions](valet-migrate-lab.md)
- [Migrate an Azure DevOps pipeline to GitHub Actions with a custom transformer](valet-migrate-custom-lab.md)
- [Forecast: Valet forecast lab](valet-forecast-lab.md)

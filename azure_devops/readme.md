# Valet labs for Azure DevOps

This lab bootstraps a Valet environment using GitHub Codespaces and enables you to create an Azure DevOps project against which to run the Valet CI/CD migration tool.

- [Use this Repo as a template](#repo-template)
- [Prerequisites](#prerequisites)
- [Codespace secrets](#codespace-secrets)
- [Action secrets](#action-secrets)
- [Azure DevOps project creation](#azure-devops-project-creation)
- [Use Valet with a codespace](#use-valet-with-a-codespace)
- [Labs for Azure DevOps](#labs-for-azure-devops)

## Repo template

1. Verify you are in your own Repository created from the landing page [Valet Labs](https://github.com/valet-customers/labs).

## Prerequisites
1. Azure DevOps organization. Please identify or create an Azure DevOps organization to use: [Click to create an Azure DevOps Org](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?toc=%2Fazure%2Fdevops%2Fget-started%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fget-started%2Fbreadcrumb%2Ftoc.json&view=azure-devops)
    - Note and store the Azure DevOp sorganization name for later.
    - Note and store the user name you use for your Azure DevOps Organization. It will be an email address.
2. Azure DevOps Project. The default project name for this lab is `ValetBootstrap` There is an Action workflow that will create and populate the Azure DevOps project. No need to create it yourself. Note: The project has to be unique in the Azure DevOps organization. If you already have a project name `ValetBootstrap` please pick a different unique project name. 
    - Note and store the Azure DevOps project name for later.
3. Create an Azure DevOps personal access token with the following scopes:
    -   To do so, navigate to Sign in to your organization `https://dev.azure.com/{yourorganization}`.
    -   Click your `Account management` icon
    -   Click `user settings`
    -   Click `Personal access tokens`.
    -   Select `+ New Token`
    -   Name your token, select the organization where you want to use the token, and then set your token to automatically expire after a set number of days.
    -   Select the following scopes (Click `Show more scopes` if you don't see all of the below):
        -   Agents Pool: `Read`
        -   Build: `Read & Execute`
        -   Code: `Read & Write`
        -   Project and Team: `Read, Write, & Manage`
        -   Release: `Read`
        -   Service Connections: `Read`
        -   Task Groups (Read)
        -   Variable Groups: `Read`
    -   Click `Create`
    -   Copy the PAT somewhere safe and temporary.
4. Create a GitHub personal access token. 
    - To do so, navigate to your GitHub `Settings` - click your profile photo and then click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the PAT somewhere safe and temporary.

## Codespace secrets
Please add the following Codespace secrets.

- `VALET_GHCR_PASSWORD`: Add `VALET_GHCR_PASSWORD` as the `Name` and the GitHub personal access token created above as the value.
- `AZURE_DEVOPS_ACCESS_TOKEN`: Add `AZURE_DEVOPS_ACCESS_TOKEN` as the `Name` and the Azure DevOps personal access token created above as the value.
- `AZURE_DEVOPS_ORGANIZATION`: Add `AZURE_DEVOPS_ORGANIZATION` as the `Name` and the Azure DevOps organization noted above as the value.
- `AZURE_DEVOPS_PROJECT`: Add `AZURE_DEVOPS_PROJECT` as the `Name` and the Azure DevOps project noted above as the value.

Steps to create the Codespace secrets. Complete for secret noted above:

- Navigate to the `Settings` tab in this repo
- Find `Secrets` and click the down arrow
- Click `Codespaces`
- Click `New Repository Secret` to create a new secret
- Name the secret as noted above
- Paste in the value noted above
- Click `Add Secret`

## Action secrets
Please add the following Action secrets.

- `AZURE_DEVOPS_ACCESS_TOKEN`: Add `AZURE_DEVOPS_ACCESS_TOKEN` as the `Name` and the Azure DevOps personal access token created above as the value.

Steps to create the Actions secret. Complete for secret noted above:

- Navigate to the `Settings` tab in this repo
- Find `Secrets` and click the down arrow
- Click `Actions`
- Click `New Repository Secret` to create a new secret
- Name the secret as noted above
- Paste in the value noted above
- Click `Add Secret`

## Azure DevOps project creation

Run the Actions workflow:
- CLick the `Actions` tab
- Select the `Valet Bootstrap for Azure DevOps` action
- Click `Run Workflow`
- Input the Azure DevOps Organization name identified above
- Input the Azure DevOps user name of the user that created the Azure DevOps PAT above. This will be an email address
- Accept the default Azure DevOps project name or change it to one of your preference
   - NOTE: The default project name is `ValetBootstrap`. This must be unique in your Azure DevOps Organization. If not, please choose a unique name.
- Click `Run Workflow`
- Verify the workflow completed successfully. If the workflow did not run successfully you will see a detailed error message.

### Example ###
![runaction](https://user-images.githubusercontent.com/26442605/167679930-9bdf6f4f-2e94-4145-aed3-8ee3e8e91d90.png)


## Use Valet with a codespace

1. Start the codespace
    - Click the `Code` with button down arrow above repository on the repository's landing page.
    - Click the `Codespaces` tab
    - Click `Create codespaces on main` to create the codespace. If you are in another branch then the `main` branch, the codespace will button will have the current branch specified.
    - Wait a couple minutes, then verify that the codespace starts up. Once it is fully booted up, the termininal should be present.
2. Verify Valet CLI is installed and working. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
    -  Verify Valet CLI is installed and working
    -  Run `gh valet version` in the Visual Studio Code terminal and verify the output looks like the below image. Note the valet version will be different than below as the latest version gets pulled down.
       -  If `gh valet version` did not produce a similar image with a version please follow these instructions [Troubleshoot GH Valet extension](#troubleshoot-gh-valet-extension)
    -  Start using Valet by following along with the [Labs for Azure DevOps](#labs-for-azure-devops)
    
### Example ###
![gh-valet-version](https://user-images.githubusercontent.com/26442605/170106559-e69e669f-a1f6-4c2c-8998-3f089b899704.png)

## Labs for Azure DevOps
Perform the following labs to test-drive Valet
- [Audit Azure DevOps pipelines using the Valet audit command](valet-audit-lab.md)
- [Dry run the migration of an Azure DevOps pipeline to GitHub Actions](valet-dry-run-lab.md)
- [Migrate an Azure DevOps pipeline to GitHub Actions](valet-migrate-lab.md)
- [Migrate an Azure DevOps pipeline to GitHub Actions with a custom transformer](valet-migrate-custom-lab.md)
- [Forecast: Valet forecast lab](valet-forecast-lab.md)

## Troubleshoot GH Valet extension
Manually Install the GitHub CLI Valet extension. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
-  Verify you are in the Visual Studio Code terminal
-  Run this command to install the GitHub Valet extension
-  `gh extension install github/gh-valet`
-  Verify the result of the install is: `✓ Installed extension github/gh-valet`
-  If you get a similiar error to the following, click the link to authorize the token
      ![linktolcickauth](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
   - Restart Codespace after clicking the link
-  Verify Valet CLI is installed and working

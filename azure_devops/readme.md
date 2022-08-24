# Valet labs for Azure DevOps

This lab bootstraps a Valet environment using GitHub Codespaces and enables you to create an Azure DevOps project against which to run the Valet CI/CD migration tool.

- [Use this Repo as a template](#repo-template)
- [Bootstrap an Azure DevOps organization](#bootstrap-your-azure-devops-organization)
- [Labs for Azure DevOps](#labs-for-azure-devops)

## Repo template

1. Verify you are in your own Repository created from the landing page [Valet Labs](https://github.com/valet-customers/labs).

## Use Valet with a codespace

1. Start the codespace

- Click the `Code` with button down arrow above repository on the repository's landing page.
- Click the `Codespaces` tab
- Click `Create codespaces on main` to create the codespace. If you are in another branch then the `main` branch, the codespace will button will have the current branch specified.
- Wait a couple minutes, then verify that the codespace starts up. Once it is fully booted up, the termininal should be present.

2. Verify the [extension](https://github.com/github/gh-valet) to the official GitHub CLI for Valet is installed and working.

- Run `gh valet version` in the Visual Studio Code terminal and verify the output looks like the below image. Note the valet version will be different than below as the latest version gets pulled down.
- If `gh valet version` did not produce a similar image with a version please follow these instructions [Troubleshoot GH Valet extension](#troubleshoot-gh-valet-extension)

-----

## Bootstrap your Azure DevOps organization

1. Create an Azure DevOps personal access token with the following scopes:

- To do so, navigate to your organization `https://dev.azure.com/{organization}`.
- Click `User settings` in the top right corner of the screen.
- Click `Personal access tokens`.
- Select `+ New Token`
- Name your token, select the organization where you want to use the token, and then set your token to automatically expire after a set number of days.
- Select the following scopes (Click `Show more scopes` if you don't see all of the below):
  - Agents Pool: `Read`
  - Build: `Read & Execute`
  - Code: `Read & Write`
  - Project and Team: `Read, Write, & Manage`
  - Release: `Read`
  - Service Connections: `Read`
  - Task Groups: `Read`
  - Variable Groups: `Read`
- Click `Create`
- Copy the PAT somewhere safe and temporary.

2. Run the Azure DevOps setup script. This script will create an Azure DevOps project and ensure it is ready to be used in the following labs. This script should only need to be run once.

- Navigate to the terminal within your Codespace.
- Run `./azure_devops/bootstrap/setup --organization :organization --project :project --access-token :access-token` while replacing these values:
  - `:organization`: the name of your existing Azure DevOps organization
  - `:project`: the name of the project to be created in your Azure DevOps organization
  - `:access_token`: the PAT created in step 1 above
- Once this script completes, you will see a new project in your Azure DevOps organization that is populated with some pipelines.

## Labs for Azure DevOps

Perform the following labs to learn how to migrate Azure DevOps pipelines to GitHub Actions using Valet:

- [Audit Azure DevOps pipelines using the Valet audit command](valet-audit-lab.md)
- [Dry run the migration of an Azure DevOps pipeline to GitHub Actions](valet-dry-run-lab.md)
- [Migrate an Azure DevOps pipeline to GitHub Actions](valet-migrate-lab.md)
- [Migrate an Azure DevOps pipeline to GitHub Actions with a custom transformer](valet-migrate-custom-lab.md)
- [Forecast: Valet forecast lab](valet-forecast-lab.md)

## Troubleshoot GH Valet extension

Manually installing the [extension](https://github.com/github/gh-valet) to the official GitHub CLI for Valet:

- Verify you are in the Visual Studio Code terminal
- Run this command to install the GitHub Valet extension
- `gh extension install github/gh-valet`
- Verify the result of the install is: `✓ Installed extension github/gh-valet`
- If you get a similiar error to the following, click the link to authorize the token
      ![linktolcickauth](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
  - Restart Codespace after clicking the link
- Verify the Valet CLI is installed and working by running the `gh valet version` command

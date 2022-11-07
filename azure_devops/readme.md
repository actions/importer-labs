# Azure Pipelines migrations powered by GitHub Actions Importer

These instructions will guide you through configuring the GitHub Codespaces environment that you will use in these labs to learn how to use GitHub Actions Importer to migrate Azure DevOps pipelines to GitHub Actions.

These steps **must** be completed prior to starting other labs.

## Create your own repository for these labs

- Ensure that you have created a repository using [actions/importer-labs](https://github.com/actions/importer-labs) as a template.

## Configure your codespace

1. Start a new codespace.

    - Click the `Code` button on your repository's landing page.
    - Click the `Codespaces` tab.
    - Click `Create codespaces on main` to create the codespace.
    - After the codespace has initialized there will be a terminal present.

2. Verify the GitHub Actions Importer CLI is installed and working. More information on the GitHub Actions Importer extension for the official GitHub CLI can be found [here](https://github.com/github/gh-actions-importer).

    - Run the following command in the codespace terminal:

      ```bash
      gh actions-importer version
      ```

    - Verify the output is similar to below.

      ```console
      $ gh actions-importer version
      gh version 2.14.3 (2022-07-26)
      gh actions-importer        github/gh-actions-importer v0.1.12
      actions-importer/cli       unknown
      ```

    - If `gh actions-importer version` did not produce similar output, please refer to the [troubleshooting section](#troubleshoot-the-github-actions-importer-cli).

## Bootstrap your Azure DevOps organization

1. Create an Azure DevOps personal access token (PAT):

    - Navigate to your existing organization (<https://dev.azure.com/:organization>) in your browser.
    - In the top right corner of the screen, click `User settings`.
    - Click `Personal access tokens`.
    - Select `+ New Token`
    - Name your token, select the organization where you want to use the token, and set your token to automatically expire after a set number of days.
    - Select the following scopes (you may need to select `Show all scopes` at the bottom of the page to reveal all scopes):
      - Agents Pool: `Read`
      - Build: `Read & execute`
      - Code: `Read & write`
      - Project and Team: `Read, write, & manage`
      - Release: `Read`
      - Service Connections: `Read`
      - Task Groups: `Read`
      - Variable Groups: `Read`
    - Click `Create`.
    - Copy the generated API token and save it in a safe location.

2. Execute the Azure DevOps setup script that will create a new Azure DevOps project in your organization to be used in the following labs. This script should only be run once.

    - Run the following command from the codespace terminal, replacing the values accordingly:
      - `:organization`: the name of your existing Azure DevOps organization
      - `:project`: the name of the project to be created in your Azure DevOps organization
      - `:access_token`: the PAT created in step 1 above

      ```bash
      ./azure_devops/bootstrap/setup --organization :organization --project :project --access-token :access-token
      ```

3. Open the newly created Azure DevOps project in your browser (<https://dev.azure.com/:organization/:project>)

    - Once authenticated, you will see an Azure DevOps project with a few predefined pipelines.

## Labs for Azure DevOps

Perform the following labs to learn how to migrate Azure DevOps pipelines to GitHub Actions using GitHub Actions Importer:

1. [Configure credentials for GitHub Actions Importer](1-configure.md)
2. [Perform an audit of an Azure DevOps project](2-audit.md)
3. [Forecast potential build runner usage](3-forecast.md)
4. [Perform a dry-run migration of an Azure DevOps pipeline](4-dry-run.md)
5. [Use custom transformers to customize GitHub Actions Importer's behavior](5-custom-transformers.md)
6. [Perform a production migration of a Azure DevOps pipeline](6-migrate.md)

## Troubleshoot the GitHub Actions Importer CLI

The CLI extension for GitHub Actions Importer can be manually installed by following these steps:

- Verify you are in the codespace terminal
- Run this command from within the codespace terminal:

  ```bash
  gh extension install github/gh-actions-importer
  ```

- Verify the result of the install contains:

  ```console
  $ gh extension install github/gh-actions-importer
  ✓ Installed extension github/gh-actions-importer
  ```

- Verify GitHub Actions Importer CLI extension is installed and working by running the following command from the codespace terminal:

  ```bash
  gh actions-importer version
  ```

# Azure Pipelines to Actions migrations powered by Valet

These instructions will guide you through configuring the GitHub Codespaces environment that will be used in these labs to demonstrate how to use Valet to migrate Azure DevOps pipelines to GitHub Actions.

These steps **must** be completed prior to starting other labs.

## Create your own repository for these labs

- Ensure that you have created a repository using [valet-customers/labs](https://github.com/valet-customers/labs) as a template.

## Configure your codespace

1. Start a new codespace.

    - Click the `Code` button on your repository's landing page.
    - Click the `Codespaces` tab.
    - Click `Create codespaces on main` to create the codespace.
    - After the codespace has initialized there will be a terminal present.

2. Verify the Valet CLI is installed and working. More information on the Valet extension for the official GitHub CLI can be found [here](https://github.com/github/gh-valet).

    - Run the following command in the codespace terminal:

      ```bash
      gh valet version
      ```

    - Verify the output is similar to below.

      ```console
      $ gh valet version
      gh version 2.14.3 (2022-07-26)
      gh valet        github/gh-valet v0.1.12
      valet-cli       unknown
      ```

    - If `gh valet version` did not produce similar output, please refer to the troubleshooting [guide](#troubleshoot-the-valet-cli).

## Bootstrap your Azure DevOps organization

1. Create an Azure DevOps personal access token (PAT):

    - Navigate to your existing organization (<https://dev.azure.com/:organization>) in your browser.
    - In the top right corner of the screen, click `User settings`.
    - Click `Personal access tokens`.
    - Select `+ New Token`
    - Name your token, select the organization where you want to use the token, and set your token to automatically expire after a set number of days.
    - Select the following scopes (you may need to `Show all scopes` at the bottom of the page to reveal all scopes):
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

Perform the following labs to learn how to migrate Azure DevOps pipelines to GitHub Actions using Valet:

1. [Configure credentials for Valet](1-configure.md)
2. [Perform an audit of an Azure DevOps project](2-audit.md)
3. [Forecast potential build runner usage](3-forecast.md)
4. [Perform a dry-run migration of an Azure DevOps pipeline](4-dry-run.md)
5. [Use custom transformers to customize Valet's behavior](5-custom-transformers.md)
6. [Perform a production migration of a Azure DevOps pipeline](6-migrate.md)

## Troubleshoot the Valet CLI

The CLI extension for Valet can be manually installed by following these steps:

- Verify you are in the codespace terminal
- Run this command from within the codespace terminal:

  ```bash
  gh extension install github/gh-valet
  ```

- Verify the result of the install contains:

  ```console
  $ gh extension install github/gh-valet
  ✓ Installed extension github/gh-valet
  ```

- If you get an error similar to the image below, click the link in the terminal output to authorize the token.
  - Restart the codespace after clicking the link.
  ![img](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
- Verify Valet CLI extension is installed and working by running the following command from the codespace terminal:

  ```bash
  gh valet version
  ```

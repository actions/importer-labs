# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with Azure DevOps and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Create an Azure DevOps Personal Access Token (PAT).
    1. __Note__: you may skip this step if you still have the PAT created during the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization).
    2. Navigate to your existing organization (<https://dev.azure.com/:organization>) in your browswer.
    3. Click `User settings` in the top right corner of the screen.
    4. Click `Personal access tokens`.
    5. Select `+ New Token`
    6. Name your token, select the organization where you want to use the token, and set your token to automatically expire after a set number of days.
    7. Select the following scopes (you may need to `Show more scopes` to reveal all scopes):
      - Agents Pool: `Read`
      - Build: `Read & Execute`
      - Code: `Read & Write`
      - Project and Team: `Read, Write, & Manage`
      - Release: `Read`
      - Service Connections: `Read`
      - Task Groups: `Read`
      - Variable Groups: `Read`
    8. Click `Create`.
    9. Copy the generated API token and save in a safe location.

2. Create a GitHub Personal Access Token (PAT):
    1. Open github.com in a new browser tab.
    2. Click your profile photo in the top right of the UI and click `Settings`.
    3. Click on `Developer Settings` in the left hand panel.
    4. Click `Personal Access Tokens` and then `Legacy tokens` (if present).
    5. Click `Generate new token` and then `Legacy tokens`. You may be required to authenticate with GitHub during this step.
    6. Select the following scopes: `read:packages` and `workflow`.
    7. Click `Generate token`.
    8. Copy the generated PAT and save in a safe location.

3. Run the `configure` CLI command:
   - Select the `TERMINAL` tab from within the codespace terminal window.
   - Run the following command: `gh valet configure`.
   - Using the down arrow key to highlight `Azure DevOps`, press the spacebar to select, and then hit enter to continue.
   - At the GitHub Container Registry prompt enter the GitHub PAT generated in step 2 and press enter.
   - At the GitHub PAT prompt enter the GitHub PAT generated in step 2 and press enter.
   - At the GitHub url prompt enter the GitHub instance url or hit enter to accept the default value (`https://github.com`).
   - At the Azure DevOps token prompt enter the access token from step 1 and press enter.
   - At the Azure DevOps url prompt enter your Azure DevOps url or hit enter to accept the default value (`https://dev.azure.com`).
   - At the prompt enter your Azure Devops organization name. This should be the same organization used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization).
   - At the prompt enter your Azure Devops project name. This should be the same project name used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization).

   ![img](https://user-images.githubusercontent.com/18723510/187771230-27c97889-d98a-48f7-af01-c1a9f8df6423.png)

## Verify your environment

To verify our environment is configured correctly, we are going to run the `update` CLI command. The `update` CLI command will download the latest version of Valet to your codespace.

1. In the codespace terminal run the following command:

   ```bash
   gh valet update
   ```

2. You should see a confirmation that you were logged into the GitHub Container Registry and Valet was updated to the latest version.

   ```bash
   Login Succeeded
   latest: Pulling from valet-customers/valet-cli
   Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
   Status: Image is up to date for ghcr.io/valet-customers/valet-cli:latest
   ghcr.io/valet-customers/valet-cli:latest
   ```

### Next lab

[Perform an audit of an Azure DevOps project](2-audit.md)

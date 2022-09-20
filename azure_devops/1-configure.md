# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with Azure DevOps and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Create an Azure DevOps personal access token (PAT).
      __Note__: you can skip this step if you still have the PAT created during the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization).
      - Navigate to your existing organization (<https://dev.azure.com/:organization>) in your browser.
      - In the top right corner of your screen, click `User settings`.
      - Click `Personal access tokens`.
      - Select `+ New Token`
      - Name your token, select the organization where you want to use the token, and set your token to automatically expire after a set number of days.
      - Select the following scopes (you may need to `Show all scopes` to reveal all scopes):
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

2. Create a GitHub personal access token (PAT):
      - Open github.com in a new browser tab.
      - In the top right corner of the UI, click your profile photo and then click `Settings`.
      - In the left panel, click `Developer Settings`.
      - Click `Personal access tokens` and then `Legacy tokens` (if present).
      - Click `Generate new token` and then `Generate new legacy token`. You may be required to authenticate with GitHub during this step.
      - Name your token in the `Note` field.
      - Select the following scopes: `workflow` and `read:packages`.
      - Click `Generate token`.
      - Copy the generated PAT and save it in a safe location.

3. Run the `configure` CLI command:
      - Select the `TERMINAL` tab from within the codespace terminal.
      - Run the following command: `gh valet configure`.
      - Use the down arrow key to highlight `Azure DevOps`, press the spacebar to select, and then press enter to continue.
      - At the GitHub handle prompt, enter the GitHub handle used to generate the GitHub PAT in step 2 and press enter.
      - At the GitHub Container Registry prompt, enter the GitHub PAT generated in step 2 and press enter.
      - At the GitHub PAT prompt, enter the GitHub PAT generated in step 2 and press enter.
      - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
      - At the Azure DevOps token prompt, enter the access token from step 1 and press enter.
      - At the Azure DevOps URL prompt, enter your Azure DevOps URL or press enter to accept the default value (`https://dev.azure.com`).
      - At the prompt, enter your Azure DevOps organization name. This should be the same organization used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization).
      - At the prompt, enter your Azure DevOps project name. This should be the same project name used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization).

         ```console
         $ gh valet configure
         ✔ Which CI providers are you configuring?: Azure DevOps
         Enter the following values (leave empty to omit):
         ✔ GitHub handle used to authenticate with the GitHub Container Registry: mona
         ✔ Personal access token to authenticate with the GitHub Container Registry: ***************
         ✔ Personal access token for GitHub: ***************
         ✔ Base url of the GitHub instance: https://github.com
         ✔ Personal access token for Azure DevOps: ***************
         ✔ Base url of the Azure DevOps instance: https://dev.azure.com
         ✔ Azure DevOps organization name: :organization
         ✔ Azure DevOps project name: :project
         Environment variables successfully updated.
         ```

## Verify your environment

To verify our environment is configured correctly, run the `update` CLI command. The `update` CLI command will download the latest version of Valet to your codespace.

1. In the codespace terminal, run the following command:

   ```bash
   gh valet update
   ```

2. You should see a confirmation that you were logged into the GitHub Container Registry and Valet was updated to the latest version.

   ```console
   $ gh valet update
   Login Succeeded
   latest: Pulling from valet-customers/valet-cli
   Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
   Status: Image is up to date for ghcr.io/valet-customers/valet-cli:latest
   ghcr.io/valet-customers/valet-cli:latest
   ```

### Next lab

[Perform an audit of an Azure DevOps project](2-audit.md)

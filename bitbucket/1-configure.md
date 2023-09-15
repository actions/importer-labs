# Configure credentials for GitHub Actions Importer

In this lab, you will use the `configure` CLI command to set the required credentials and information for GitHub Actions Importer to use when working with Bitbucket and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Create a GitHub personal access token (PAT):
   - Open github.com in a new browser tab.
   - In the top right of the UI, click your profile photo and then click `Settings`.
   - In the left panel, click `Developer Settings`.
   - Click `Personal access tokens` and then `Tokens (classic)` (if present).
   - Click `Generate new token` and then `Generate new token (classic)`. You may be required to authenticate with GitHub during this step.
   - Select the following scope: `workflow`.
   - Click `Generate token`.
   - Copy the generated PAT and save in a safe location.
2. Follow Bitbucket's [documentation](https://support.atlassian.com/bitbucket-cloud/docs/create-a-workspace-access-token/) to generate a workspace access token with read scopes for pipeline, project, and repository, and ensure that you store the token securely.  This step is optional since we are using source files in this lab.

3. Run the `configure` CLI command:
   - Select the `TERMINAL` tab from within the codespace terminal window.
   - Run the following command: `gh actions-importer configure`.
   - Using the down arrow key to highlight `Bitbucket`, press the spacebar to select, and then press enter to continue.
   - At the GitHub PAT prompt, enter the GitHub PAT generated in step 1 and press enter.
   - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
   - At the Bitbucket token prompt, enter the Bitbucket access token from step 2 or any random string if no token was generated, and press enter.

            ```console
            $ gh actions-importer configure
            ✔ Which CI providers are you configuring?: Bitbucket
            Enter the following values (leave empty to omit):
            ✔ Personal access token for GitHub: ***************
            ✔ Base url of the GitHub instance: https://github.com
            ✔ Personal access token for Bitbucket: ***************
            Environment variables successfully updated.
            ```

## Verify your environment

To verify your environment is configured correctly, you are going to run the `update` CLI command. The `update` CLI command will download the latest version of GitHub Actions Importer to your codespace.

1. In the codespace terminal run the following command:

   ```bash
   gh actions-importer update
   ```

2. You should see a confirmation that you were logged into the GitHub Container Registry and the image was updated to the latest version.

   ```console
   $ gh actions-importer update
   Login Succeeded
   latest: Pulling from actions-importer/cli
   Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
   Status: Image is up to date for ghcr.io/actions-importer/cli:latest
   ghcr.io/actions-importer/cli:latest
   ```

### Next lab

[Perform an audit of Bitbucket](./2-audit.md)

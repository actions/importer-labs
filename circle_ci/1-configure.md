# Configure credentials for GitHub Actions Importer

In this lab, you will use the `configure` CLI command to set the required credentials and information for GitHub Actions Importer to use when working with CircleCI and GitHub.

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

3. Create a CircleCI personal API token using CircleCI's [documentation](https://circleci.com/docs/managing-api-tokens#creating-a-personal-api-token) and store the token in a safe location.

2. Run the `configure` CLI command:
   - Select the `TERMINAL` tab from within the codespace terminal window.
   - Run the following command: `gh actions-importer configure`.
   - Using the down arrow key to highlight `CircleCI`, press the spacebar to select, and then press enter to continue.
   - At the GitHub PAT prompt, enter the GitHub PAT generated in step 1 and press enter.
   - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
   - At the CircleCI token prompt, enter the CircleCI access token from step 2 and press enter.
   - At the CircleCI base URL prompt, press enter to accept the default value (`https://circleci.com`).
   - At the CircleCI organization name prompt, enter `actions-importer-labs`. This is the organization you'll be using throughout these labs.

            ```console
            $ gh actions-importer configure
            ✔ Which CI providers are you configuring?: CircleCI
            Enter the following values (leave empty to omit):
            ✔ Personal access token for GitHub: ***************
            ✔ Base url of the GitHub instance: https://github.com
            ✔ Personal access token for CircleCI: ***************
            ✔ Base url of the CircleCI instance: https://circleci.com
            ✔ CircleCI organization name: actions-importer-labs
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

[Perform an audit of CircleCI](./2-audit.md)

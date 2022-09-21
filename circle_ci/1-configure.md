# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with CircleCI and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Create a GitHub Personal Access Token (PAT):
        - Open github.com in a new browser tab.
        - Click your profile photo in the top right of the UI and click `Settings`.
        - Click on `Developer Settings` in the left hand panel.
        - Click `Personal Access Tokens` and then `Legacy tokens` (if present).
        - Click `Generate new token` and then `Legacy tokens`. You may be required to authenticate with GitHub during this step.
        - Select the following scopes: `read:packages` and `workflow`.
        - Click `Generate token`.
        - Copy the generated PAT and save in a safe location.

3. Create a CircleCI personal API token using CircleCI's [documentation](https://circleci.com/docs/managing-api-tokens#creating-a-personal-api-token) and store the token in a safe location.

2. Run the `configure` CLI command:
        - Select the `TERMINAL` tab from within the codespace terminal window.
        - Run the following command: `gh valet configure`.
        - Using the down arrow key to highlight `CircleCI`, press the spacebar to select, and then hit enter to continue.
        - At the GitHub handle prompt, enter the GitHub username used to generate the GitHub PAT in step 2 and press enter.
        - At the GitHub Container Registry prompt, enter the GitHub PAT generated in step 1 and press enter.
        - At the GitHub PAT prompt, enter the GitHub PAT generated in step 1 and press enter.
        - At the GitHub url prompt, enter the GitHub instance url or hit enter to accept the default value (`https://github.com`).
        - At the CircleCI token prompt, enter the CircleCI access token from step 2 and press enter.
        - At the CircleCI base url prompt, hit enter to accept the default value (`https://circleci.com`).
        - At the CircleCI organization name prompt, enter `valet-labs`. This is the organization we'll be using throughout these labs.

            ```console
            $ gh valet configure
            ✔ Which CI providers are you configuring?: CircleCI
            Enter the following values (leave empty to omit):
            ✔ GitHub handle used to authenticate with the GitHub Container Registry: mona
            ✔ Personal access token to authenticate with the GitHub Container Registry: ***************
            ✔ Personal access token for GitHub: ***************
            ✔ Base url of the GitHub instance: https://github.com
            ✔ Personal access token for CircleCI: ***************
            ✔ Base url of the CircleCI instance: https://circleci.com
            ✔ CircleCI organization name: valet-labs
            Environment variables successfully updated.
            ```

## Verify your environment

To verify our environment is configured correctly, we are going to run the `update` CLI command. The `update` CLI command will download the latest version of Valet to your codespace.

1. In the codespace terminal run the following command:

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

[Perform an audit of CircleCI](./2-audit.md)

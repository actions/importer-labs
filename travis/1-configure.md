# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with Travis CI and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Create a GitHub personal access token (PAT):
        - Open github.com in a new browser tab.
        - In the top right corner of the UI, click your profile photo and then click `Settings`.
        - In the left panel, click `Developer Settings`.
        - Click `Personal access tokens` and then `Legacy tokens` (if present).
        - Click `Generate new token` and then `Generate new legacy token`. You may be required to authenticate with GitHub during this step.
        - Name your token in the `Note` field.
        - Select the following scopes: `workflow` and `read:packages`.
        - Click `Generate token`.
        - Copy the generated PAT and save it in a safe location.

3. Create a Travis CI personal access token (PAT):
        - Open app.travis-ci.com in a new browser tab.
        - Click on your profile icon in the top right hand corner to reveal a dropdown menu.
        - Click `Settings`.
        - Click on the `Settings` tab.
        - Click on the `COPY TOKEN` button under the "API authentication" header and save it in a safe location.

2. Run the `configure` CLI command:
        - Select the `TERMINAL` tab from within the codespace terminal.
        - Run the following command: `gh valet configure`.
        - Use the down arrow key to highlight `Travis CI`, press the spacebar to select, and then press enter to continue.
        - At the GitHub handle prompt, enter the GitHub username used to generate the GitHub PAT in step 3 and press enter.
        - At the GitHub Container Registry prompt, enter the GitHub PAT generated in step 2 and press enter.
        - At the GitHub PAT prompt, enter the GitHub PAT generated in step 2 and press enter.
        - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
        - At the Travis CI token prompt, enter the Travis CI access token from step 2 and press enter.
        - At the Travis CI base url prompt, hit enter to accept the default value (`https://travis-ci.com`).
        - At the Travis CI organization name, enter `valet-labs`.

            ```console
            $ gh valet configure
            ✔ Which CI providers are you configuring?: Travis CI
            Enter the following values (leave empty to omit):
            ✔ GitHub handle used to authenticate with the GitHub Container Registry: mona
            ✔ Personal access token to authenticate with the GitHub Container Registry: ***************
            ✔ Personal access token for GitHub: ***************
            ✔ Base url of the GitHub instance: https://github.com
            ✔ Personal access token for Travis CI: ***************
            ✔ Base url of the Travis CI instance: https://travis-ci.com
            ✔ Travis CI organization name: valet-labs
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

[Perform an audit of a Travis CI organization](./2-audit.md)

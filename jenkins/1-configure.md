# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with Jenkins and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

- [Configuring credentials](#configuring-credentials)
- [Verify your environment](#verify-your-environment)
- [Next Lab](#next-lab)

## Configuring credentials

1. Open the Jenkins server in a new browser tab:
   1. Click the `PORTS` tab in the codespace terminal window.
   2. In the `PORTS` tab find the row for port 8080.
   3. Hover over the address under the `Local Address` column and click the globe to "open in browser".

2. Create a Jenkins API token:
   1. Click the `admin` button in the top right menu bar.
   2. Click on the `Configure` gear located on the left hand panel.
   3. Click the `Add new Token` button in the `API token` section and click `Generate`.
   4. Copy the generated API token and save in a safe location.

   ![img](https://user-images.githubusercontent.com/19557880/184041667-d06cb7f2-a885-474e-b728-7567314aeaf3.png)

3. Create a GitHub Personal Access Token (PAT):
    1. Open github.com in a new browser tab.
    2. Click your profile photo in the top right of the UI and click `Settings`.
    3. Click on `Developer Settings` in the left hand panel.
    4. Click `Personal Access Tokens` and then `Legacy tokens` (if present).
    5. Click `Generate new token` and then `Legacy tokens`. You may be required to authenticate with GitHub during this step.
    6. Select the following scopes: `read:packages` and `workflow`.
    7. Click `Generate token`.
    8. Copy the generated PAT and save in a safe location.
4. Run the `configure` CLI command:
   - Select the `TERMINAL` tab from within the codespace terminal window.
   - Run the following command: `gh valet configure`.
   - Using the down arrow key to highlight `Jenkins`, press the spacebar to select, and then hit enter to continue.
   - At the prompt enter your GitHub Username and press enter.
   - At the GitHub Container Registry prompt enter the GitHub PAT generated in step 3 and press enter.
   - At the GitHub PAT prompt enter the GitHub PAT generated in step 3 and press enter.
   - At the GitHub url prompt enter the GitHub instance url or hit enter to accept the default value (`https://github.com`).
   - At the Jenkins token prompt enter the Jenkins access token from step 2 and press enter.
   - At the Jenkins url prompt enter `http://localhost:8080/` and press enter.
   - At the Personal access token to fetch source code in GitHub prompt hit enter to accept the default value.
   ![img](https://user-images.githubusercontent.com/19557880/184041328-ce54ea22-b0cd-4c84-b02c-10ad7b09ad89.png)

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

### Next Lab

[Perform an audit of a Jenkins server](2-audit.md#perform-an-audit-of-a-jenkins-server)

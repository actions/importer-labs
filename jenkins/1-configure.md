# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with Jenkins and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Open the Jenkins server in a new browser tab:
      - Click the `PORTS` tab in the codespace terminal window.
      - In the `PORTS` tab, find the row for port 8080.
      - Hover over the address under the `Local Address` column and click the globe to "open in browser".

2. Create a Jenkins API token:
      - In the top right menu bar, click the `admin` button.
      - In the left panel, click the `Configure` gear.
      - In the `API token` section, click the `Add new Token` button and click `Generate`.
      - Copy the generated API token and save it in a safe location.

         ![img](https://user-images.githubusercontent.com/19557880/184041667-d06cb7f2-a885-474e-b728-7567314aeaf3.png)

3. Create a GitHub personal access token (PAT):
      - Open github.com in a new browser tab.
      - In the top right corner of the UI, click your profile photo and click `Settings`.
      - In the left panel, click `Developer Settings`.
      - Click `Personal access tokens` and then `Legacy tokens` (if present).
      - Click `Generate new token` and then `Generate new legacy token`. You may be required to authenticate with GitHub during this step.
      - Name your token in the `Note` field.
      - Select the following scopes: `workflow` and `read:packages`.
      - Click `Generate token`.
      - Copy the generated PAT and save it in a safe location.

4. Run the `configure` CLI command:
      - Select the `TERMINAL` tab from within the codespace terminal window.
      - Run the following command: `gh valet configure`.
      - Use the down arrow key to highlight `Jenkins`, press the spacebar to select, and then press enter to continue.
      - At the GitHub handle prompt, enter the GitHub username used to generate the GitHub PAT in step 3 and press enter.
      - At the GitHub Container Registry prompt, enter the GitHub PAT generated in step 3 and press enter.
      - At the GitHub PAT prompt, enter the GitHub PAT generated in step 3 and press enter.
      - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
      - At the Jenkins token prompt, enter the Jenkins access token from step 2 and press enter.
      - At the Jenkins username prompt, enter `admin`  and press enter.
      - At the Jenkins URL prompt, enter `http://localhost:8080/` and press enter.

            ```console
            $ gh valet configure
            ✔ Which CI providers are you configuring?: Jenkins
            Enter the following values (leave empty to omit):
            ✔ GitHub handle used to authenticate with the GitHub Container Registry: mona
            ✔ Personal access token to authenticate with the GitHub Container Registry: ***************
            ✔ Personal access token for GitHub: ***************
            ✔ Base url of the GitHub instance: https://github.com
            ✔ Personal access token for Jenkins: *************** 
            ✔ Username of Jenkins user: admin
            ✔ Base url of the Jenkins instance: https://localhost
            Environment variables successfully updated.
            ```

## Verify your environment

To verify your environment is configured correctly, run the `update` CLI command. The `update` CLI command will download the latest version of Valet to your codespace.

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

[Perform an audit of a Jenkins server](2-audit.md#perform-an-audit-of-a-jenkins-server)

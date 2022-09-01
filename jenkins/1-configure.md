# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with Jenkins and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

- [Configuring credentials](#configuring-credentials)
- [Verify Valet Works](#verify-valet-works)
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

To verify Valet works we are going to run a `update` and `dry-run` command.  We will go further into details about the `dry-run` command in a later lab, but for now we want to get the latest version of Valet and confirm that Valet can perform a dry-run with no errors.

1. In the codespace terminal update Valet by running `gh valet update`
2. In the terminal you should see a confirmation that it logged into the GitHub Container Registry and pulled the latest version.

      ```
      Login Succeeded
      latest: Pulling from valet-customers/valet-cli
      Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
      Status: Image is up to date for ghcr.io/valet-customers/valet-cli:latest
      ghcr.io/valet-customers/valet-cli:latest
      ```

3. Next, lets run the dry-run command in the codespaces terminal, to verify we can talk to Jenkins

    ```
    gh valet dry-run jenkins --source-url https://localhost:8080/job/test_pipeline/ --output-dir ./tmp/dry-run-lab
    ```

4. In the terminal you should see the command was successful, if not it is a good time to practice the configure command again and make sure the access tokens values are correct and were generated with the correct permissions.
  ![configure-dry-run](https://user-images.githubusercontent.com/19557880/184255620-8e9b120e-5de0-41df-9cb6-c52028de3b0f.png)

### Next Lab

[Audit Jenkins using the Valet audit command](2-audit.md#audit-jenkins-pipelines-using-the-valet-audit-command)

# Configure credentials for GitHub Actions Importer

In this lab, you will use the `configure` CLI command to set the required credentials and information for GitHub Actions Importer to use when working with Bamboo and GitHub.

You will need to complete all of the [setup instructions](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Create a GitHub personal access token (PAT):
   - Open github.com in a new browser tab.
   - In the top right corner of the UI, click your profile photo and then click `Settings`.
   - In the left panel, click `Developer Settings`.
   - Click `Personal access tokens` and then `Tokens (classic)` (if present).
   - Click `Generate new token` and then `Generate new token (classic)`. You may be required to authenticate with GitHub during this step.
   - Name your token in the `Note` field.
   - Select the following scope: `workflow`.
   - Click `Generate token`.
   - Copy the generated PAT and save it in a safe location.

2. Create a Bamboo personal access token using the Bamboo [documentation](https://confluence.atlassian.com/bamboo/personal-access-tokens-976779873.html).  This step is optional since we are using local files throughout the labs and a random value can be used instead.  

3. Run the `configure` CLI command:
      - Select the `TERMINAL` tab from within the codespace terminal.
      - Run the following command: `gh actions-importer configure`.
      - Use the down arrow key to highlight `Bamboo`, press the spacebar to select, and then press enter to continue.
      - At the GitHub PAT prompt, enter the GitHub PAT generated in step 1 and press enter.
      - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
      - At the Bamboo token prompt, enter the access token from step 2 and press enter.
      - At the Bamboo URL prompt, enter your Bamboo Base URL.

## Verify your environment

To verify your environment is configured correctly, run the `update` CLI command. The `update` CLI command will download the latest version of GitHub Actions Importer to your codespace.

1. In the codespace terminal, run the following command:

   ```bash
   gh actions-importer update
   ```

2. You should see a confirmation that you were logged into the GitHub Container Registry and the image was updated to the latest version.

   ```console
   $ gh actions-importer update
   Updating ghcr.io/actions-importer/cli:latest...
   ghcr.io/actions-importer/cli:latest up-to-date
   ```

### Next lab

[Perform an audit of audit of a Bamboo project](2-audit.md)

# GitLab to Actions migrations powered by Valet
The instructions below will guide you through configuring a GitHub Codespace environment that will be used in subsequent labs that demonstrate how to use Valet to migrate GitLab pipelines to GitHub Actions.

These steps **must** be completed prior to starting other labs.

## Create your own repository for these labs
1. Ensure that you have created a repository using the [valet-customers/labs](https://github.com/valet-customers/labs) as a template.

## Configure your Codespace

1. Start the codespace

- Click the `Code` button down arrow above the repository on the repository's landing page.
- Click the `Codespaces` tab.
- Click `Create codespaces on main` to create the codespace.
- After the Codespace has initialized there will be a terminal present.

2. Verify the Valet CLI is installed and working. More information on the Valet extension for the official GitHub CLI can be found [here](https://github.com/github/gh-valet).

- Run the following command in the codespace's terminal:

```bash
gh valet version
```

- Verify the output is similar to below, if not try manually installing the valet extension, using the [troubleshooting](#troubleshooting) section.

```bash
gh version 2.14.3 (2022-07-26)
gh valet        github/gh-valet v0.1.12
valet-cli       unknown
```

3. Run the GitLab setup script.  This script will set up GitLab and ensure it is ready to use.  In general, this script should be run first if you are starting a new codespace or restarting an existing one.  

-  from the codespace terminal run `source gitlab/bootstrap/setup.sh`.

4. Verify you can login to the GitLab Server.

- Click the `PORTS` tab in the codespace terminal window.
- In the row that starts with `80` mouse over the address under the column heading `Local Address`, and click the globe icon.
- Verify a new browser tab opened to the GitLab login screen.
- Login with the username: `root` and password: `valet-labs!`.
- Verify that you can see the auto populated projects in GitLab, under the `valet` namespace by clicking the `Menu` icon in GitLab, then `Your projects`.

## Labs for GitLab
Perform the following labs to test-drive Valet
1. [Configure credentials for Valet](1-configure.md)
2. [Perform an audit on GitLab pipelines](2-audit.md)
3. [Perform a dry-run of a GitLab pipeline](3-dry-run.md)
4. [Use custom transformers to customize Valet's behavior](4-custom-transformers.md)
5. [Forecast potential build runner usage](5-forecast.md)
6. [Perform a production migration of a GitLab pipeline](6-migrate.md)

## Troubleshooting
-  **GitHub CLI Valet extension is not installed**. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
   -  Verify you are in the codespace terminal
   -  Run `gh extension install github/gh-valet`
   -  Verify the result of the command is: `✓ Installed extension github/gh-valet`
   -  If you get a similar error to the following, click the link to authorize the token
      ![linktolcickauth](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
   - Restart the codespace after clicking the link
- **Port 80 is not being forwarded for GitLab server**. This should be auto detected by codespaces, but can be manually setup by:
  - In the codespace terminal click the PORTS tab
  - Click the "Add Port" button
  - Enter 80 and hit enter

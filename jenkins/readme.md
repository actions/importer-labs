# Jenkins migrations powered by GitHub Actions Importer

These instructions will guide you through configuring a GitHub Codespaces environment that you will use in subsequent labs to learn how to use GitHub Actions Importer to migrate Jenkins pipelines to GitHub Actions.

These steps **must** be completed prior to starting other labs.

## Create your own repository for these labs

- Ensure that you have created a repository using the [actions/importer-labs](https://github.com/actions/importer-labs) as a template.

## Configure your codespace

1. Start a new codespace.

    - Click the `Code` button on your repository's landing page.
    - Click the `Codespaces` tab.
    - Click `Create codespaces on main` to create the codespace.
    - After the codespace has initialized there will be a terminal present.

2. Verify the GitHub Actions Importer CLI is installed and working. More information on the GitHub Actions Importer extension for the official GitHub CLI can be found [here](https://github.com/github/gh-actions-importer).

    - Run the following command in the codespace's terminal:

      ```bash
      gh actions-importer version
      ```

    - Verify the output is similar to below.

      ```console
      $ gh actions-importer version
      gh version 2.14.3 (2022-07-26)
      gh actions-importer        github/gh-actions-importer v0.1.12
      actions-importer/cli       unknown
      ```

    - If `gh actions-importer version` did not produce similar output, refer to the [troubleshooting section](#troubleshoot-the-github-actions-importer-cli).

## Bootstrap a Jenkins server

1. Execute the Jenkins setup script that will start a container with a Jenkins server running inside of it. This script should be executed when starting a new codespace or restarting an existing one.

    - Run the following command from the codespace's terminal to start a Jenkins server:

      ```bash
      ./jenkins/bootstrap/setup.sh
      ```

    - After some time, a pop-up box should appear with a link to the URL for your Jenkins server.

    - You can also access the URL by going to the `Ports` tab in your terminal. Right-click the URL listed under the `Local Address` and click the `Open in Browser` tab.

2. Open the Jenkins server in your browser and use the following credentials to authenticate:

    - Username: `admin`
    - Password: `password`

3. Once authenticated, you should see a Jenkins server with a few predefined pipelines.

## Labs for Jenkins

Perform the following labs to learn more about Actions migrations with GitHub Actions Importer:

1. [Configure credentials for GitHub Actions Importer](1-configure.md)
2. [Perform an audit of a Jenkins server](2-audit.md)
3. [Forecast potential build runner usage](3-forecast.md)
4. [Perform a dry-run migration of a Jenkins pipeline](4-dry-run.md)
5. [Use custom transformers to customize GitHub Actions Importer's behavior](5-custom-transformers.md)
6. [Perform a production migration of a Jenkins pipeline](6-migrate.md)

## Troubleshoot the GitHub Actions Importer CLI

The CLI extension for GitHub Actions Importer can be manually installed by following these steps:

- Verify you are in the codespace terminal
- Run this command from within the codespace terminal:

  ```bash
  gh extension install github/gh-actions-importer
  ```

- Verify the result of the install contains:

  ```console
  $ gh extension install github/gh-actions-importer
  ✓ Installed extension github/gh-actions-importer
  ```

- Verify the GitHub Actions Importer CLI extension is installed and working by running the following command from the codespace terminal:

  ```bash
  gh actions-importer version
  ```

## Troubleshooting the Jenkins server

Follow these steps if the Jenkins server does not start correctly after running the setup script:

1. On the left side of the codespace, navigate to the `Docker` tab.
2. Under the `Containers` tab you should see a docker container named `jenkins:actions-importer` listed with a green play button.

   - If you see the `jenkins:actions-importer` container, but it has a red stopped symbol next to it, right-click the container and click `start`. The container should begin running again.
   - If the container does not start even after trying to start it manually, right-click the `jenkins:actions-importer` container and click `remove`. Then, attempt to start the Jenkins server again by following the steps [here](#bootstrap-a-jenkins-server).

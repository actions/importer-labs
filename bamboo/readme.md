# Bamboo Server migrations powered by GitHub Actions Importer

The instructions below will guide you through configuring a GitHub Codespace environment to learn how to use GitHub Actions Importer to migrate Bamboo pipelines to GitHub Actions.

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
      gh actions-importer	github/gh-actions-importer	v1.3.4
      actions-importer/cli:latest	v1.3.20618
      ```

    - If `gh actions-importer version` did not produce similar output, refer to the [troubleshooting section](#troubleshoot-the-github-actions-importer-cli).

## Labs for Bamboo

Perform the following labs to learn more about Actions migrations with GitHub Actions Importer:

1. [Configure credentials for GitHub Actions Importer](1-configure.md)
2. [Perform an audit on Bamboo](2-audit.md)
3. [Forecast potential build runner usage](3-forecast.md)
4. [Perform a dry-run migration of a Bamboo pipeline](4-dry-run.md)
5. [Use custom transformers to customize GitHub Actions Importer's behavior](5-custom-transformers.md)
6. [Perform a production migration of a Bamboo pipeline](6-migrate.md)



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

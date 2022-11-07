# CircleCI migrations powered by GitHub Actions Importer

The instructions below will guide you through configuring a GitHub Codespace environment that you will use in subsequent labs to learn how to use GitHub Actions Importer to migrate CircleCI pipelines to GitHub Actions.

These steps **must** be completed prior to starting other labs.

## Create your own repository for these labs

1. Ensure that you have created a repository using the [actions/importer-labs](https://github.com/actions/importer-labs) as a template.

## Configure your Codespace

1. Start a new Codespace.

    - Click the `Code` button on your repository's landing page.
    - Click the `Codespaces` tab.
    - Click `Create codespaces on main` to create the codespace.
    - After the Codespace has initialized there will be a terminal present.

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

## Labs for CircleCI

Perform the following labs to learn how to migrate CircleCI pipelines to GitHub Actions using GitHub Actions Importer:

1. [Configure credentials for GitHub Actions Importer](1-configure.md)
2. [Perform an audit of CircleCI](2-audit.md)
3. [Forecast potential build runner usage](3-forecast.md)
4. [Perform a dry-run of a CircleCI pipeline](4-dry-run.md)
5. [Use custom transformers to customize GitHub Actions Importer's behavior](5-custom-transformers.md)
6. [Perform a production migration of a CircleCI pipeline](6-migrate.md)

## Troubleshoot the GitHub Actions Importer CLI

The CLI extension for GitHub Actions Importer can be manually installed by following these steps:

- Verify you are in the codespace terminal
- Run this command from within the codespace's terminal:

  ```bash
  gh extension install github/gh-actions-importer
  ```

- Verify the result of the install contains:

  ```console
  $ gh extension install github/gh-actions-importer
  ✓ Installed extension github/gh-actions-importer
  ```

- Verify GitHub Actions Importer CLI extension is installed and working by running the following command from the codespace's terminal:

  ```bash
  gh actions-importer version
  ```

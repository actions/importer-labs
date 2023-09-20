# Perform an audit of an Bamboo plan

In this lab, you will use the `audit` command to get a high-level view of all pipelines in a Bamboo config file. This lab uses local config files to demonstrate the actions-importer functionality.

The `audit` command will perform the following steps:

1. Determine the build plans and deployment projects defined in a local config file.
2. Convert each pipeline to their equivalent GitHub Actions workflow.
3. Generate a report that summarizes how complete and complex of a migration is possible with GitHub Actions Importer.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and bootstrap a Bamboo project.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

## Perform an audit

You will audit the configured Bamboo pipelines. Answer the following questions before running this command:

1. Where is the local configuration file?
    - __bamboo/bootstrap/config.yml__

2. Where do you want to store the result?
    - __tmp/audit__
        - This can be any path within the working directory from which GitHub Actions Importer commands are executed.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer audit bamboo -o tmp/audit --config-file-path bamboo/bootstrap/config.yml
    ```
    > Note: The `--config-file-path` option is not required and is used throughout these labs to convert files that are stored locally for this lab. When performing a migration on your own Bamboo Server, `config-file-path` can be omitted and GitHub Actions Importer will programmatically fetch pipelines using the Bambooo REST APIs.

3. The command will list all the files written to disk in green when the command succeeds.

## Inspect the output files

1. Find the `audit_summary.md` file in the file explorer.
2. Right-click the `audit_summary.md` file and select `Open Preview`.
3. This file contains details that summarize what percentage of your pipelines were converted automatically.

### Review audit summary

#### Pipelines

The pipeline summary section contains high level statistics regarding the conversion rate done by GitHub Actions Importer:

```md
## Pipelines

Total: **2**

- Successful: **2 (100%)**
- Partially successful: **0 (0%)**
- Unsupported: **0 (0%)**
- Failed: **0 (0%)**
```

Here are some key terms in the "Pipelines" section:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items (e.g. build tasks or build triggers) that were not converted automatically to their GitHub Actions equivalent.
- __Unsupported__ pipelines are definition types that are not supported by GitHub Actions Importer.
- __Failed__ pipelines encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in Bamboo.
  - GitHub Actions Importer encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

#### Job Types
The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by GitHub Actions Importer.

```
### Job types

Supported: **2 (100%)**

- build: **2**
```

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by GitHub Actions Importer.

```md
### Build steps

Total: **15**

Known: **15 (100%)**

- checkout: **6**
- script: **4**
- any-task/plugin-key/com.atlassian.bamboo.plugins.atlassian-bamboo-plugin-aws-codedeploy:task.aws.codeDeploy: **2**
- any-task/plugin-key/com.atlassian.bamboo.plugins.bamboo-nodejs-plugin:task.reporter.mocha: **1**
- test-parser/type/junit: **1**
- any-task/plugin-key/com.atlassian.bamboo.plugins.bamboo-nodejs-plugin:task.builder.npm: **1**

Actions: **17**

- actions/checkout@v3.5.0: **6**
- run: **6**
- EnricoMi/publish-unit-test-result-action@v2.9.0: **2**
- actions/setup-node@v3.7.0: **1**
- aws-actions/configure-aws-credentials@v2.2.0: **1**
- actions/upload-artifact@v3.1.1: **1**
```

Here are some key terms in the "Build steps" section:

- A __known__ build step is a step that was automatically converted to an equivalent action.
- An __unknown__ build step is a step that was not automatically converted to an equivalent action.
- An __unsupported__ build step is a step that is either:
  - A step that is fundamentally not supported by GitHub Actions.
  - A step that is configured in a way that is incompatible with GitHub Actions.
- An __action__ is a list of the actions that were used in the converted workflows. This is important for the following scenarios:
  - Gathering the list of actions to sync to your appliance if you use GitHub Enterprise Server.
  - Defining an organization-level allowlist of actions that can be used. This list of actions is a comprehensive list of which actions their security and/or compliance teams will need to review.

There is an equivalent breakdown of build triggers, environment variables, and other uncategorized items displayed in the audit summary file.

#### Manual Tasks

The manual tasks summary section presents an overview of the manual tasks that you will need to perform that GitHub Actions Importer is not able to complete automatically.

```
### Manual tasks

Total: **3**

Secrets: **3**

- `${{ secrets.AWS_ACCESS_KEY_ID }}`: **1**
- `${{ secrets.AWS_SECRET_ACCESS_KEY }}`: **1**
- `${{ secrets.AWS_S3_BUCKET_KEY }}`: **1**
```

Here are some key terms in the "Manual tasks" section:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit.

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in Bamboo.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage .csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:

    ```csv
    Pipeline,Action,File path
    sam/sample,actions/checkout@v3.5.0,tmp/audit/build/sam/sample/.github/workflows/sample.yml
    sam/sample,actions/upload-artifact@v3.1.1,tmp/audit/build/sam/sample/.github/workflows/sample.yml
    demo/mar,actions/checkout@v3.5.0,tmp/audit/build/demo/mar/.github/workflows/mar.yml
    demo/mar,actions/setup-node@v3.7.0,tmp/audit/build/demo/mar/.github/workflows/mar.yml
    demo/mar,EnricoMi/publish-unit-test-result-action@v2.9.0,tmp/audit/build/demo/mar/.github/workflows/mar.yml
    demo/mar,aws-actions/configure-aws-credentials@v2.2.0,tmp/audit/build/demo/mar/.github/workflows/mar.yml

    Pipeline,Secret,File path
    demo/mar,${{ secrets.AWS_ACCESS_KEY_ID }},tmp/audit/build/demo/mar/.github/workflows/mar.yml
    demo/mar,${{ secrets.AWS_SECRET_ACCESS_KEY }},tmp/audit/build/demo/mar/.github/workflows/mar.yml
    demo/mar,${{ secrets.AWS_S3_BUCKET_KEY }},tmp/audit/build/demo/mar/.github/workflows/mar.yml

    Pipeline,Runner,File path
    ```

The contents of this file can be useful in answering questions similar to the following:

- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

### Next lab

[Forecast potential build runner usage](3-forecast.md)

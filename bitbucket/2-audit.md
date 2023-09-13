# Perform an audit of Bitbucket

In this lab, you will use the `audit` command to get a high-level view of all pipelines in your Bitbucket workspace.

The `audit` command will perform the following steps:

1. Fetch all of the pipelines in the Bitbucket workspace.
2. Convert each pipeline to its equivalent GitHub Actions workflow(s).
3. Generate a report that summarizes how complete and complex of a migration is possible with GitHub Actions Importer.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

## Perform an audit

Answer the following questions before running this command:

1. What workspace do you want to audit?
    - __actions-importer__. In this example we will be instructing Actions Importer to audit the `actions-importer` workspace.

2. Where do you want to store the result?
    - __tmp/audit__.  This can be any path within the working directory from which GitHub Actions Importer commands are executed.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer audit bitbucket --output-dir tmp/audit --workspace actions-importer --config-file-path bitbucket/bootstrap/config.yml
    ```
    > Note: The `--config-file-path` option is not required and is used throughout these labs to convert files that are stored locally for this lab. When performing a migration on your own workspace, it can be omitted and GitHub Actions Importer will programmatically fetch pipelines using the Bitbucket REST APIs.
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

Total: **4**

- Successful: **4 (100%)**
- Partially successful: **0 (0%)**
- Unsupported: **0 (0%)**
- Failed: **0 (0%)**

### Job types

Supported: **4 (100%)**

- YAML: **4**
```

Here are some key terms in the “Pipelines” section:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items (e.g. build tasks or build triggers) that were not converted automatically to their GitHub Actions equivalent.
- __Unsupported__ pipelines are definition types that are not supported by GitHub Actions Importer.
- __Failed__ pipelines encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in Bitbucket.
  - GitHub Actions Importer encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by GitHub Actions Importer.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by GitHub Actions Importer.

```md
### Build steps

Total: **22**

Known: **22 (100%)**

- script: **11**
- atlassian/git-secrets-scan: **3**
- cache-node: **3**
- cache-docker: **2**
- atlassian/aws-cloudfront-invalidate: **1**
- atlassian/aws-s3-deploy: **1**
- cache-pip: **1**

Actions: **40**

- run: **15**
- actions/checkout@v3.6.0: **14**
- actions/cache@v3.3.1: **6**
- actions/upload-artifact@v3.1.1: **2**
- actions/download-artifact@v3.0.1: **2**
- aws-actions/configure-aws-credentials@v3.0.1: **1**

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

```md
### Manual tasks

Total: **2**

Self hosted runners: **2**

- `my.custom.label`: **2**
```

Here are some key terms in the “Manual tasks” section:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
### Successful

#### actions-importer/python

- [actions-importer/python/.github/workflows/default.yml](actions-importer/python/.github/workflows/default.yml)
- [actions-importer/python/config.json](actions-importer/python/config.json)
- [actions-importer/python/source.yml](actions-importer/python/source.yml)

#### actions-importer/ruby

- [actions-importer/ruby/.github/workflows/default.yml](actions-importer/ruby/.github/workflows/default.yml)
- [actions-importer/ruby/config.json](actions-importer/ruby/config.json)
- [actions-importer/ruby/source.yml](actions-importer/ruby/source.yml)

#### actions-importer/docker

- [actions-importer/docker/.github/workflows/default.yml](actions-importer/docker/.github/workflows/default.yml)
- [actions-importer/docker/.github/workflows/branches-master.yml](actions-importer/docker/.github/workflows/branches-master.yml)
- [actions-importer/docker/config.json](actions-importer/docker/config.json)
- [actions-importer/docker/source.yml](actions-importer/docker/source.yml)

#### actions-importer/react-deploy

- [actions-importer/react-deploy/.github/workflows/default.yml](actions-importer/react-deploy/.github/workflows/default.yml)
- [actions-importer/react-deploy/.github/workflows/branches-master.yml](actions-importer/react-deploy/.github/workflows/branches-master.yml)
- [actions-importer/react-deploy/config.json](actions-importer/react-deploy/config.json)
- [actions-importer/react-deploy/source.yml](actions-importer/react-deploy/source.yml)
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in Bitbucket.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can be used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage .csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:
  
    ```csv
    Pipeline,Action,File path
    actions-importer/python,actions/checkout@v3.6.0,tmp/audit/actions-importer/python/.github/workflows/default.yml
    actions-importer/python,actions/cache@v3.3.1,tmp/audit/actions-importer/python/.github/workflows/default.yml
    actions-importer/ruby,actions/checkout@v3.6.0,tmp/audit/actions-importer/ruby/.github/workflows/default.yml
    actions-importer/docker,actions/checkout@v3.6.0,tmp/audit/actions-importer/docker/.github/workflows/default.yml
    actions-importer/docker,actions/cache@v3.3.1,tmp/audit/actions-importer/docker/.github/workflows/default.yml
    actions-importer/docker,actions/upload-artifact@v3.1.1,tmp/audit/actions-importer/docker/.github/workflows/default.yml
    actions-importer/docker,actions/download-artifact@v3.0.1,tmp/audit/actions-importer/docker/.github/workflows/default.yml
    actions-importer/react-deploy,actions/checkout@v3.6.0,tmp/audit/actions-importer/react-deploy/.github/workflows/default.yml
    actions-importer/react-deploy,actions/cache@v3.3.1,tmp/audit/actions-importer/react-deploy/.github/workflows/default.yml
    actions-importer/react-deploy,actions/upload-artifact@v3.1.1,tmp/audit/actions-importer/react-deploy/.github/workflows/default.yml
    actions-importer/react-deploy,aws-actions/configure-aws-credentials@v3.0.1,tmp/audit/actions-importer/react-deploy/.github/workflows/default.yml
    actions-importer/react-deploy,actions/download-artifact@v3.0.1,tmp/audit/actions-importer/react-deploy/.github/workflows/default.yml

    Pipeline,Secret,File path


    Pipeline,Runner,File path
    actions-importer/python,my.custom.label,tmp/audit/actions-importer/python/.github/workflows/default.yml
    ```

The contents of this file can be useful in answering questions similar to the following:

- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

### Next lab

[Forecast potential build runner usage](3-forecast.md)

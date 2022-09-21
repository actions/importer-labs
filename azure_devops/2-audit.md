# Perform an audit of an Azure DevOps project

In this lab, you will use the `audit` command to get a high-level view of all pipelines in an Azure DevOps organization or project.

The `audit` command will perform the following steps:
1. Fetch all of the projects defined in an Azure DevOps organization.
2. Convert each pipeline to their equivalent GitHub Actions workflow.
3. Generate a report that summarizes how complete and complex of a migration is possible with Valet.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and bootstrap an Azure DevOps project.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

## Perform an audit

You will now perform an audit against the bootstrapped Azure DevOps project. Answer the following questions before running this command:

1. What is the Azure DevOps organization name that you want to audit?
    - __:organization__. This should be the same organization used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization)

2. What is the Azure DevOps project name that you want to audit?
    - __:project__. This should be the same project name used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization)

3. Where do you want to store the result?
    - __tmp/audit__.  This can be any path within the working directory from which Valet commands are executed.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh valet audit azure-devops --output-dir tmp/audit
    ```

    __Note__: The Azure DevOps organization and project name can be omitted from the `audit` command because they were persisted in the `.env.local` file in the [configure lab](./1-configure.md). You can optionally provide these arguments on the command line with the `--azure-devops-organization` and `--azure-devops-project` CLI options.

3. The command will list all the files written to disk in green when the command succeeds.

## Inspect the output files

1. Find the `audit_summary.md` file in the file explorer.
2. Right-click the `audit_summary.md` file and select `Open Preview`.
3. This file contains details that summarize what percentage of your pipelines were converted automatically.

### Review audit summary

#### Pipelines

The pipeline summary section contains high level statistics regarding the conversion rate done by Valet:

```md
## Pipelines

Total: **5**

- Successful: **5 (100%)**
- Partially successful: **0 (0%)**
- Unsupported: **0 (0%)**
- Failed: **0 (0%)**

### Job types

Supported: **5 (100%)**

- designer: **2**
- YAML: **3**
```

Here are some key terms in the "Pipelines" section in the above example:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items (e.g. build tasks or build triggers) that were not converted automatically to their GitHub Actions equivalent.
- __Unsupported__ pipelines are definition types that are not supported by Valet. The following Azure DevOps pipeline types are supported:
  - Classic (designer)
  - YAML
  - Release
- __Failed__ pipelines encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in Azure DevOps.
  - Valet encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by Valet.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by Valet.

```md
### Build steps

Total: **14**

Known: **14 (100%)**

- script: **4**
- DotNetCoreCLI@2: **2**
- 2c65196a-54fd-4a02-9be8-d9d1837b7c5d@0: **2**
- 333b11bd-d341-40d9-afcf-b32d5ce6f23b@2: **2**
- e213ff0f-5d5c-4791-802d-52ea3e7be1f1@2: **2**
- NodeTool@0: **1**
- checkout: **1**

Actions: **19**

- run: **10**
- actions/checkout@v2: **6**
- nuget/setup-nuget@v1: **2**
- actions/setup-node@v2: **1**
```

Here are some key terms in the "Build steps" section in the above example:

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

The manual tasks summary section presents an overview of the manual tasks that you will need to perform that Valet is not able to complete automatically.

```md
### Manual tasks

Total: **1**

Self hosted runners: **1**

- `mechamachine`: **1**
```

Here are some key terms in the "Manual tasks" section in the above example:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
### Successful

#### valet-bootstrap/valet-classic-test-import1

- [valet-bootstrap/valet-classic-test-import1.yml](valet-bootstrap/valet-classic-test-import1.yml)
- [valet-bootstrap/valet-classic-test-import1.config.json](valet-bootstrap/valet-classic-test-import1.config.json)

#### valet-bootstrap/valet-classic-test-import2

- [valet-bootstrap/valet-classic-test-import2.yml](valet-bootstrap/valet-classic-test-import2.yml)
- [valet-bootstrap/valet-classic-test-import2.config.json](valet-bootstrap/valet-classic-test-import2.config.json)

#### valet-bootstrap/pipelines/valet-pipeline1

- [valet-bootstrap/pipelines/valet-pipeline1.yml](valet-bootstrap/pipelines/valet-pipeline1.yml)
- [valet-bootstrap/pipelines/valet-pipeline1.config.json](valet-bootstrap/pipelines/valet-pipeline1.config.json)
- [valet-bootstrap/pipelines/valet-pipeline1.source.yml](valet-bootstrap/pipelines/valet-pipeline1.source.yml)
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in Azure DevOps.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:
  
    ```csv
    Pipeline,Action,File path
    lab-test/pipelines/valet-pipeline2,actions/checkout@v2,/data/tmp/adoa/lab-test/pipelines/valet-pipeline2.yml
    lab-test/pipelines/valet-pipeline1,actions/checkout@v2,/data/tmp/adoa/lab-test/pipelines/valet-pipeline1.yml
    lab-test/pipelines/valet-custom-transformer-example,actions/checkout@v2,/data/tmp/adoa/lab-test/pipelines/valet-custom-transformer-example.yml
    lab-test/pipelines/valet-custom-transformer-example,actions/setup-node@v2,/data/tmp/adoa/lab-test/pipelines/valet-custom-transformer-example.yml

    Pipeline,Secret,File path


    Pipeline,Runner,File path
    lab-test/pipelines/valet-pipeline2,mechamachine,/data/tmp/adoa/lab-test/pipelines/valet-pipeline2.yml
    lab-test/pipelines/valet-custom-transformer-example,mechamachine,/data/tmp/adoa/lab-test/pipelines/valet-custom-transformer-example.yml
    ```

The contents of this file can be useful in answering questions similar to the following:
- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

### Next lab

[Forecast potential build runner usage](3-forecast.md)

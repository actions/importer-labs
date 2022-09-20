# Perform an audit of a GitLab server

In this lab, you will use the `audit` command to get a high-level view of all pipelines in a GitLab server.

The `audit` command will perform the following steps:
1. Fetch all of the projects defined in a GitLab group.
2. Convert each pipeline to their equivalent GitHub Actions workflow.
3. Generate a report that summarizes how complete and complex of a migration is possible with Valet.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and start a GitLab server.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

## Perform an audit

You will be performing an audit against your preconfigured GitLab server. Answer the following questions before running this command:

1. What namespace (e.g. group) do you want to audit?
    - __valet__. In this example you will be auditing the `valet` group. In the future, you could add additional groups and subgroups to the audit command.

2. Where do you want to store the result?
    - __tmp/audit__.  This can be any path within the working directory from which Valet commands are executed.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh valet audit gitlab --output-dir tmp/audit --namespace valet
    ```

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

Total: **11**

- Successful: **10 (90%)**
- Partially successful: **0 (0%)**
- Unsupported: **1 (9%)**
- Failed: **0 (0%)**

### Job types

Supported: **10 (90%)**

- YAML: **10**

Unsupported: **1 (9%)**

- Auto DevOps: **1**
```

Here are some key terms in the “Pipelines” section in the above example:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items (e.g. build tasks or build triggers) that were not converted automatically to their GitHub Actions equivalent.
- __Unsupported__ pipelines are definition types that are not supported by Valet. Auto DevOps pipelines are not supported.
- __Failed__ pipelines encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in GitLab.
  - Valet encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by Valet.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by Valet.

```md
### Build steps

Total: **134**

Known: **133 (99%)**

- script: **62**
- checkout: **35**
- before_script: **19**
- artifacts: **5**
- after_script: **4**
- dependencies: **4**
- cache: **3**
- pages: **1**

Unsupported: **1 (0%)**

- artifacts.terraform: **1**

Actions: **135**

- run: **85**
- actions/checkout@v2: **35**
- actions/upload-artifact@v2: **5**
- actions/download-artifact@v2: **4**
- actions/cache@v2: **3**
- ./.github/workflows/a-.gitlab-ci.yml: **1**
- ./.github/workflows/b-.gitlab-ci.yml: **1**
- JamesIves/github-pages-deploy-action@4.1.5: **1**
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

Secrets: **1**

- `${{ secrets.PASSWORD }}`: **1**
```

Here are some key terms in the “Manual tasks” section in the above example:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
### Successful

#### valet/included-files-example

- [valet/included-files-example.yml](valet/included-files-example.yml)
- [valet/included-files-example.config.json](valet/included-files-example.config.json)
- [valet/included-files-example.source.yml](valet/included-files-example.source.yml)

#### valet/terraform-example

- [valet/terraform-example.yml](valet/terraform-example.yml)
- [valet/terraform-example.config.json](valet/terraform-example.config.json)
- [valet/terraform-example.source.yml](valet/terraform-example.source.yml)

#### valet/child-parent-example

- [valet/child-parent-example.yml](valet/child-parent-example.yml)
- [.github/workflows/a-.gitlab-ci.yml](.github/workflows/a-.gitlab-ci.yml)
- [.github/workflows/b-.gitlab-ci.yml](.github/workflows/b-.gitlab-ci.yml)
- [valet/child-parent-example.config.json](valet/child-parent-example.config.json)
- [valet/child-parent-example.source.yml](valet/child-parent-example.source.yml)
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in GitLab.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can be used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:
  
    ```csv
    Pipeline,Action,File path
    valet/included-files-example,actions/checkout@v2,/data/tmp/audit/valet/included-files-example.yml
    valet/terraform-example,actions/checkout@v2,/data/tmp/audit/valet/terraform-example.yml
    valet/child-parent-example,actions/checkout@v2,/data/tmp/audit/valet/child-parent-example.yml
    valet/child-parent-example,./.github/workflows/a-.gitlab-ci.yml,/data/tmp/audit/valet/child-parent-example.yml
    valet/child-parent-example,./.github/workflows/b-.gitlab-ci.yml,/data/tmp/audit/valet/child-parent-example.yml
    valet/include-file-example,actions/checkout@v2,/data/tmp/audit/valet/include-file-example.yml
    valet/basic-pipeline-example,actions/checkout@v2,/data/tmp/audit/valet/basic-pipeline-example.yml
    valet/gatsby-example,actions/checkout@v2,/data/tmp/audit/valet/gatsby-example.yml
    valet/gatsby-example,actions/cache@v2,/data/tmp/audit/valet/gatsby-example.yml
    valet/gatsby-example,actions/upload-artifact@v2,/data/tmp/audit/valet/gatsby-example.yml
    valet/gatsby-example,actions/download-artifact@v2,/data/tmp/audit/valet/gatsby-example.yml
    valet/gatsby-example,JamesIves/github-pages-deploy-action@4.1.5,/data/tmp/audit/valet/gatsby-example.yml
    valet/android-example,actions/checkout@v2,/data/tmp/audit/valet/android-example.yml
    valet/android-example,actions/upload-artifact@v2,/data/tmp/audit/valet/android-example.yml
    valet/android-example,actions/download-artifact@v2,/data/tmp/audit/valet/android-example.yml
    valet/dotnet-example,actions/checkout@v2,/data/tmp/audit/valet/dotnet-example.yml
    valet/dotnet-example,actions/upload-artifact@v2,/data/tmp/audit/valet/dotnet-example.yml
    valet/dotnet-example,actions/download-artifact@v2,/data/tmp/audit/valet/dotnet-example.yml
    valet/node-example,actions/checkout@v2,/data/tmp/audit/valet/node-example.yml
    valet/node-example,actions/cache@v2,/data/tmp/audit/valet/node-example.yml
    valet/rails-example,actions/checkout@v2,/data/tmp/audit/valet/rails-example.yml

    Pipeline,Secret,File path
    valet/rails-example,${{ secrets.PASSWORD }},/data/tmp/audit/valet/rails-example.yml

    Pipeline,Runner,File path
    ```

The contents of this file can be useful in answering questions similar to the following:
- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

### Next lab

[Forecast potential build runner usage](3-forecast.md)

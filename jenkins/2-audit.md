# Perform an audit of a Jenkins server

In this lab, you will use the `audit` command to get a high-level view of all pipelines in a Jenkins server.

The `audit` command will perform the following steps:

1. Fetch all of the projects defined in a Jenkins server.
2. Convert each pipeline to its equivalent GitHub Actions workflow.
3. Generate a report that summarizes how complete and complex of a migration is possible with GitHub Actions Importer.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and start a Jenkins server.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

## Perform an audit

You will be performing an audit against your preconfigured Jenkins server. Answer the following questions before running this command:

1. Do you want to audit the entire Jenkins instance or just a single folder?
    - In this example you will audit the entire Jenkins instance, but in the future if you wanted to configure a specific folder to be audited add the `-f <folder_path>` flag to the `audit` command.

2. Where do you want to store the result?
    - __tmp/audit__. This can be any path within the working directory from which GitHub Actions Importer commands are executed.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer audit jenkins --output-dir tmp/audit
    ```

3. The command will list all the files written to disk in green when the command succeeds.

    ```console
    $ gh actions-importer audit jenkins --output-dir tmp/audit
    [2022-08-20 22:08:20] Logs: 'tmp/audit/log/actions-importer-20220916-015817.log'
    [2022-08-20 22:08:20] Auditing 'http://localhost:8080/'
    [2022-08-20 22:08:20] Output file(s):==========================================|
    [2022-09-28 20:08:48]   tmp/audit/demo_pipeline/.github/workflows/demo_pipeline.yml
    [2022-09-28 20:08:48]   tmp/audit/demo_pipeline/config.json
    [2022-09-28 20:08:48]   tmp/audit/demo_pipeline/jenkinsfile
    [2022-09-28 20:08:48]   tmp/audit/groovy_script/error.txt
    [2022-09-28 20:08:48]   tmp/audit/groovy_script/config.json
    [2022-09-28 20:08:48]   tmp/audit/monas_dev_work/monas_freestyle/.github/workflows/monas_freestyle.yml
    [2022-09-28 20:08:48]   tmp/audit/monas_dev_work/monas_freestyle/config.json
    [2022-09-28 20:08:48]   tmp/audit/monas_dev_work/monas_pipeline/.github/workflows/monas_pipeline.yml
    [2022-09-28 20:08:48]   tmp/audit/monas_dev_work/monas_pipeline/config.json
    [2022-09-28 20:08:48]   tmp/audit/monas_dev_work/monas_pipeline/jenkinsfile
    [2022-09-28 20:08:48]   tmp/audit/test_freestyle_project/.github/workflows/test_freestyle_project.yml
    [2022-09-28 20:08:48]   tmp/audit/test_freestyle_project/config.json
    [2022-09-28 20:08:48]   tmp/audit/test_mutlibranch_pipeline/config.json
    [2022-09-28 20:08:48]   tmp/audit/test_pipeline/.github/workflows/test_pipeline.yml
    [2022-09-28 20:08:48]   tmp/audit/test_pipeline/config.json
    [2022-09-28 20:08:48]   tmp/audit/test_pipeline/jenkinsfile
    [2022-09-28 20:08:48]   tmp/audit/workflow_usage.csv
    [2022-09-28 20:08:48]   tmp/audit/audit_summary.md
    ```

## Inspect the output files

The audit summary, logs, config files, jenkinsfiles, and transformed workflows will be located within the `tmp/audit` folder.

1. Find the `audit_summary.md` file in the file explorer.
2. Right-click the `audit_summary.md` file and select `Open Preview`.
3. This file contains details that summarize what percentage of your pipelines were converted automatically.

### Review the audit summary

#### Pipelines

The pipeline summary section contains high level statistics regarding the conversion rate done by GitHub Actions Importer:

```md
## Pipelines

Total: **7**

- Successful: **3 (42%)**
- Partially successful: **3 (42%)**
- Unsupported: **1 (14%)**
- Failed: **0 (0%)**

### Job types

Supported: **6 (85%)**

- flow-definition: **3**
- project: **2**
- org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject: **1**

Unsupported: **1 (14%)**

- scripted: **1**
```

Here are some key terms in the “Pipelines” section:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items (e.g. build tasks or build triggers) that were not converted automatically to their GitHub Actions equivalent.
- __Unsupported__ pipelines are definition types that are not supported by GitHub Actions Importer. The following Jenkins pipeline types are supported:
  - Flow Definition
  - Project (declarative Jenkinsfile pipelines)
  - Multibranch Project
- __Failed__ pipelines encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in Jenkins.
  - GitHub Actions Importer encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by GitHub Actions Importer.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by GitHub Actions Importer.

```md
### Build steps

Total: **17**

Known: **13 (76%)**

- echo: **6**
- hudson.tasks.Shell: **3**
- junit: **2**
- archiveArtifacts: **1**
- sh: **1**

Unknown: **3 (17%)**

- sleep: **2**
- hudson.plugins.git.GitPublisher: **1**

Unsupported: **1 (5%)**

- hudson.tasks.Mailer: **1**

Actions: **22**

- run: **10**
- actions/checkout@v2: **9**
- EnricoMi/publish-unit-test-result-action@v1.7: **2**
- actions/upload-artifact@v2: **1**
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

#### Manual tasks

The manual tasks summary section presents an overview of the manual tasks that you will need to perform that GitHub Actions Importer is not able to complete automatically.

```md
### Manual tasks

Total: **9**

Secrets: **2**

- `${{ secrets.SECRET_TEST_EXPRESSION_VAR }}`: **1**
- `${{ secrets.EXPRESSION_FIRST_VAR }}`: **1**

Self hosted runners: **7**

- `TeamARunner`: **6**
- `DemoRunner`: **1**
```

Here are some key terms in the “Manual tasks” section:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
### Successful

#### demo_pipeline

- [demo_pipeline/.github/workflows/demo_pipeline.yml](demo_pipeline/.github/workflows/demo_pipeline.yml)
- [demo_pipeline/config.json](demo_pipeline/config.json)
- [demo_pipeline/jenkinsfile](demo_pipeline/jenkinsfile)

#### monas_dev_work/monas_freestyle

- [monas_dev_work/monas_freestyle/.github/workflows/monas_freestyle.yml](monas_dev_work/monas_freestyle/.github/workflows/monas_freestyle.yml)
- [monas_dev_work/monas_freestyle/config.json](monas_dev_work/monas_freestyle/config.json)

#### test_mutlibranch_pipeline

- [test_mutlibranch_pipeline/config.json](test_mutlibranch_pipeline/config.json)

### Partially successful

#### monas_dev_work/monas_pipeline

- [monas_dev_work/monas_pipeline/.github/workflows/monas_pipeline.yml](monas_dev_work/monas_pipeline/.github/workflows/monas_pipeline.yml)
- [monas_dev_work/monas_pipeline/config.json](monas_dev_work/monas_pipeline/config.json)
- [monas_dev_work/monas_pipeline/jenkinsfile](monas_dev_work/monas_pipeline/jenkinsfile)

#### test_freestyle_project

- [test_freestyle_project/.github/workflows/test_freestyle_project.yml](test_freestyle_project/.github/workflows/test_freestyle_project.yml)
- [test_freestyle_project/config.json](test_freestyle_project/config.json)

#### test_pipeline

- [test_pipeline/.github/workflows/test_pipeline.yml](test_pipeline/.github/workflows/test_pipeline.yml)
- [test_pipeline/config.json](test_pipeline/config.json)
- [test_pipeline/jenkinsfile](test_pipeline/jenkinsfile)

### Failed

#### groovy_script

- [groovy_script/error.txt](groovy_script/error.txt)
- [groovy_script/config.json](groovy_script/config.json)
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in Jenkins.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage .csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:
  
    ```csv
    Pipeline,Action,File path
    demo_pipeline,actions/checkout@v2,tmp/audit/demo_pipeline/.github/workflows/demo_pipeline.yml
    demo_pipeline,actions/upload-artifact@v2,tmp/audit/demo_pipeline/.github/workflows/demo_pipeline.yml
    demo_pipeline,EnricoMi/publish-unit-test-result-action@v1.7,tmp/audit/demo_pipeline/.github/workflows/demo_pipeline.yml
    monas_dev_work/monas_freestyle,actions/checkout@v2,tmp/audit/monas_dev_work/monas_freestyle/.github/workflows/monas_freestyle.yml
    monas_dev_work/monas_pipeline,actions/checkout@v2,tmp/audit/monas_dev_work/monas_pipeline/.github/workflows/monas_pipeline.yml
    test_freestyle_project,actions/checkout@v2,tmp/audit/test_freestyle_project/.github/workflows/test_freestyle_project.yml
    test_pipeline,actions/checkout@v2,tmp/audit/test_pipeline/.github/workflows/test_pipeline.yml
    test_pipeline,EnricoMi/publish-unit-test-result-action@v1.7,tmp/audit/test_pipeline/.github/workflows/test_pipeline.yml

    Pipeline,Secret,File path
    monas_dev_work/monas_freestyle,${{ secrets.SECRET_TEST_EXPRESSION_VAR }},tmp/audit/monas_dev_work/monas_freestyle/.github/workflows/monas_freestyle.yml
    test_freestyle_project,${{ secrets.EXPRESSION_FIRST_VAR }},tmp/audit/test_freestyle_project/.github/workflows/test_freestyle_project.yml

    Pipeline,Runner,File path
    demo_pipeline,TeamARunner,tmp/audit/demo_pipeline/.github/workflows/demo_pipeline.yml
    test_freestyle_project,DemoRunner,tmp/audit/test_freestyle_project/.github/workflows/test_freestyle_project.yml
    test_pipeline,TeamARunner,tmp/audit/test_pipeline/.github/workflows/test_pipeline.yml
    ```

The contents of this file can be useful in answering questions similar to the following:

- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

## Next lab

[Forecast potential build runner usage](3-forecast.md)

# Perform an audit of CircleCI

In this lab, you will use the `audit` command to get a high-level view of all projects in a CircleCI organization.

The `audit` command will perform the following steps:

1. Fetch all of the projects defined in a CircleCI organization.
2. Convert each pipeline to its equivalent GitHub Actions workflow.
3. Generate a report that summarizes how complete and complex of a migration is possible with GitHub Actions Importer.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment.
2. Completed the [configure lab](./1-configure.md).

## Perform an audit

You will be performing an `audit` for the __actions-importer-labs__ CircleCI organization that was created for the purposes of these labs. Your environment was configured to use this organization during the [configure lab](./1-configure.md). The remaining information needed to perform an `audit` is:

1. Where do you want to store the result?
    - __tmp/audit__.  This can be any path within the working directory that GitHub Actions Importer commands are executed from.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer audit circle-ci --output-dir tmp/audit
    ```

3. The command will list all the files written to disk in green when the command succeeds.

   **Note**:  It is expected that you will see "Resource not found" warnings in the output. These warnings are present because you are not a member of the CircleCI organization actions-importer-labs.
   
## Inspect the output files

1. Find the `audit_summary.md` file in the file explorer.
2. Right-click the `audit_summary.md` file and select `Open Preview`.
3. This file contains details that summarize what percentage of your pipelines were converted automatically.

### Review audit summary

#### Pipelines

The pipeline summary section contains high level statistics regarding the conversion rate done by GitHub Actions Importer:

```md
## Pipelines

Total: **6**

- Successful: **6 (100%)**
- Partially successful: **0 (0%)**
- Unsupported: **0 (0%)**
- Failed: **0 (0%)**

### Job types

Supported: **6 (100%)**

- 2.1: **5**
- 2: **1**
```

Here are some key terms that can appear in the “Pipelines” section:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items that were not converted automatically to their GitHub Actions equivalent.
- __Failed pipelines__ encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in CircleCI.
  - GitHub Actions Importer encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by GitHub Actions Importer.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by GitHub Actions Importer.

```md
### Build steps

Total: **42**

Known: **42 (100%)**

- run: **10**
- checkout: **6**
- circleci_node_install_packages: **6**
- circleci_node_job_test: **5**
- store_artifacts: **3**
- circleci_python_install_packages: **3**
- circleci_ruby_install_deps: **2**
- restore_cache: **2**
- attach_workspace: **1**
- persist_to_workspace: **1**
- store_test_results: **1**
- circleci_ruby_rspec_test: **1**
- circleci_ruby_rubocop_check: **1**

Actions: **45**

- run: **23**
- actions/checkout@v2: **7**
- actions/cache@v2: **6**
- actions/upload-artifact@v2: **5**
- ruby/setup-ruby@v1: **2**
- actions/download-artifact@v2: **1**
- ./.github/actions/greeting: **1**
```

Here are some key terms that can appear in "Build steps" section:

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

Total: **1**

Self hosted runners: **1**

- `medium+`: **1**
```

Here are some key terms that can appear in “Manual tasks” section:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
### Successful

#### actions-importer-labs/circleci-hello-world

- [actions-importer-labs/circleci-hello-world/.github/workflows/say-hello-workflow.yml](actions-importer-labs/circleci-hello-world/.github/workflows/say-hello-workflow.yml)
- [actions-importer-labs/circleci-hello-world/config.json](actions-importer-labs/circleci-hello-world/config.json)
- [actions-importer-labs/circleci-hello-world/source.yml](actions-importer-labs/circleci-hello-world/source.yml)

#### actions-importer-labs/circleci-command-example

- [actions-importer-labs/circleci-command-example/.github/workflows/my-workflow.yml](actions-importer-labs/circleci-command-example/.github/workflows/my-workflow.yml)
- [actions-importer-labs/circleci-command-example/.github/actions/greeting/action.yml](actions-importer-labs/circleci-command-example/.github/actions/greeting/action.yml)
- [actions-importer-labs/circleci-command-example/config.json](actions-importer-labs/circleci-command-example/config.json)
- [actions-importer-labs/circleci-command-example/source.yml](actions-importer-labs/circleci-command-example/source.yml)

#### actions-importer-labs/circleci-python-example

- [actions-importer-labs/circleci-python-example/.github/workflows/sample.yml](actions-importer-labs/circleci-python-example/.github/workflows/sample.yml)
- [actions-importer-labs/circleci-python-example/config.json](actions-importer-labs/circleci-python-example/config.json)
- [actions-importer-labs/circleci-python-example/source.yml](actions-importer-labs/circleci-python-example/source.yml)

#### actions-importer-labs/circleci-demo-java-spring

- [actions-importer-labs/circleci-demo-java-spring/.github/workflows/workflow.yml](actions-importer-labs/circleci-demo-java-spring/.github/workflows/workflow.yml)
- [actions-importer-labs/circleci-demo-java-spring/config.json](actions-importer-labs/circleci-demo-java-spring/config.json)
- [actions-importer-labs/circleci-demo-java-spring/source.yml](actions-importer-labs/circleci-demo-java-spring/source.yml)

#### actions-importer-labs/circleci-demo-ruby-rails

- [actions-importer-labs/circleci-demo-ruby-rails/.github/workflows/build_and_test.yml](actions-importer-labs/circleci-demo-ruby-rails/.github/workflows/build_and_test.yml)
- [actions-importer-labs/circleci-demo-ruby-rails/config.json](actions-importer-labs/circleci-demo-ruby-rails/config.json)
- [actions-importer-labs/circleci-demo-ruby-rails/source.yml](actions-importer-labs/circleci-demo-ruby-rails/source.yml)

### Partially successful

#### actions-importer-labs/circleci-node-example

- [actions-importer-labs/circleci-node-example/.github/workflows/sample.yml](actions-importer-labs/circleci-node-example/.github/workflows/sample.yml)
- [actions-importer-labs/circleci-node-example/config.json](actions-importer-labs/circleci-node-example/config.json)
- [actions-importer-labs/circleci-node-example/source.yml](actions-importer-labs/circleci-node-example/source.yml)
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in GitHub.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage .csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:
  
    ```csv
    Pipeline,Action,File path
    actions-importer-labs/circleci-hello-world,actions/checkout@v2,tmp/audit/actions-importer-labs/circleci-hello-world/.github/workflows/say-hello-workflow.yml
    actions-importer-labs/circleci-command-example,./.github/actions/greeting,tmp/audit/actions-importer-labs/circleci-command-example/.github/workflows/my-workflow.yml
    actions-importer-labs/circleci-node-example,actions/checkout@v2,tmp/audit/actions-importer-labs/circleci-node-example/.github/workflows/sample.yml
    actions-importer-labs/circleci-node-example,actions/cache@v2,tmp/audit/actions-importer-labs/circleci-node-example/.github/workflows/sample.yml
    actions-importer-labs/circleci-python-example,actions/checkout@v2,tmp/audit/actions-importer-labs/circleci-python-example/.github/workflows/sample.yml
    actions-importer-labs/circleci-python-example,actions/cache@v2,tmp/audit/actions-importer-labs/circleci-python-example/.github/workflows/sample.yml
    actions-importer-labs/circleci-demo-java-spring,actions/checkout@v2,tmp/audit/actions-importer-labs/circleci-demo-java-spring/.github/workflows/workflow.yml
    actions-importer-labs/circleci-demo-java-spring,actions/cache@v2,tmp/audit/actions-importer-labs/circleci-demo-java-spring/.github/workflows/workflow.yml
    actions-importer-labs/circleci-demo-java-spring,actions/upload-artifact@v2,tmp/audit/actions-importer-labs/circleci-demo-java-spring/.github/workflows/workflow.yml
    actions-importer-labs/circleci-demo-java-spring,actions/download-artifact@v2,tmp/audit/actions-importer-labs/circleci-demo-java-spring/.github/workflows/workflow.yml
    actions-importer-labs/circleci-demo-ruby-rails,ruby/setup-ruby@v1,tmp/audit/actions-importer-labs/circleci-demo-ruby-rails/.github/workflows/build_and_test.yml
    actions-importer-labs/circleci-demo-ruby-rails,actions/checkout@v2,tmp/audit/actions-importer-labs/circleci-demo-ruby-rails/.github/workflows/build_and_test.yml
    actions-importer-labs/circleci-demo-ruby-rails,actions/cache@v2,tmp/audit/actions-importer-labs/circleci-demo-ruby-rails/.github/workflows/build_and_test.yml

    Pipeline,Secret,File path


    Pipeline,Runner,File path
    ```

The contents of this file can be useful in answering questions similar to the following:

- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

### Next lab

[Forecast potential build runner usage](3-forecast.md)

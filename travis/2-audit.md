# Perform an audit of CircleCI

In this lab, you will use the `audit` command to get a high-level view of all projects in a Travis CI organization.

The `audit` command operates by performing the following:

- Fetching all of the projects defined in a Travis CI organization.
- Converting each to their equivalent GitHub Actions workflow.
- Generating a report that summarizes how complete and complex of a migration is possible with Valet.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment.
2. Completed the [configure lab](./1-configure.md#configure-credentials-for-valet).

## Perform an audit

You will be performing an audit against the **valet-labs** Travis CI organization that was created for the purposes of this lab. Your environment was configured to use this organization during the [configure lab](./1-configure.md). The remaining information needed to perform an `audit` is:

1. Where do we want to store the result?
    - **tmp/audit**.  This can be any path within the working directory that Valet commands are executed from.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh valet audit travis-ci --output-dir tmp/audit
    ```

3. The command will list all the files written to disk in green when the command succeeds.

## Inspect the output files

1. Find the `audit_summary.md` file in the file explorer.
2. Right-click the `audit_summary.md` file and select `Open Preview`.
3. This file contains details that summarizes what percentage of your pipelines were converted automatically.

### Review audit summary

#### Pipelines

The pipeline summary section contains high level statistics regarding the conversion rate done by Valet:

```md
# Audit summary

Summary for [Travis CI instance](https://travis-ci.com/valet-labs)

- Valet version: **0.1.0.13539 (5bb6c723d6db3688ea0653e14bbf3c63df445bfc)**
- Performed at: **9/16/22 at 20:01**

## Pipelines

Total: **5**

- Successful: **0 (0%)**
- Partially successful: **5 (100%)**
- Unsupported: **0 (0%)**
- Failed: **0 (0%)**

### Job types

Supported: **5 (100%)**

- php: **1**
- nodejs: **1**
- ruby: **2**
- python: **1**

### Build steps

Total: **25**

Known: **22 (88%)**

- install: **6**
- script: **5**
- before_script: **3**
- rvm: **2**
- after_deploy: **2**
- pushover: **1**
- irc: **1**
- before_deploy: **1**
- php: **1**

Unknown: **1 (4%)**

- codedeploy: **1**

Unsupported: **2 (8%)**

- sudo: **2**

Actions: **28**

- run: **17**
- actions/checkout@v2: **6**
- ruby/setup-ruby@v1: **2**
- rectalogic/notify-irc@v1: **1**
- shivammathur/setup-php@v2: **1**
- desiderati/github-action-pushover@v1: **1**

### Triggers

Total: **30**

Known: **30 (100%)**

- crons: **5**
- branches: **5**
- config_validation: **5**
- build_pull_requests: **5**
- build_pushes: **5**
- builds_only_with_travis_yml: **5**

Actions: **10**

- pull_request: **5**
- push: **5**

### Environment

Total: **1**

Known: **1 (100%)**

- DB: **1**

Actions: **1**

- DB: **1**

### Other

Total: **15**

Known: **10 (66%)**

- auto_cancel_pull_requests: **5**
- auto_cancel_pushes: **5**

Unknown: **5 (33%)**

- maximum_number_of_builds: **5**

Actions: **3**

- matrix: **2**
- DB: **1**

### Manual tasks

Total: **1**

Secrets: **1**

- `${{ secrets.PUSHOVER_USER_KEY }}`: **1**

### Partially successful

#### valet-labs/travisci-php-example

- [valet-labs/travisci-php-example.yml](valet-labs/travisci-php-example.yml)
- [valet-labs/travisci-php-example.config.json](valet-labs/travisci-php-example.config.json)
- [valet-labs/travisci-php-example.source.yml](valet-labs/travisci-php-example.source.yml)

#### valet-labs/travisci-nodejs-example

- [valet-labs/travisci-nodejs-example.yml](valet-labs/travisci-nodejs-example.yml)
- [valet-labs/travisci-nodejs-example.config.json](valet-labs/travisci-nodejs-example.config.json)
- [valet-labs/travisci-nodejs-example.source.yml](valet-labs/travisci-nodejs-example.source.yml)

#### valet-labs/travisci-ruby-example

- [valet-labs/travisci-ruby-example.yml](valet-labs/travisci-ruby-example.yml)
- [valet-labs/travisci-ruby-example.config.json](valet-labs/travisci-ruby-example.config.json)
- [valet-labs/travisci-ruby-example.source.yml](valet-labs/travisci-ruby-example.source.yml)

#### valet-labs/travisci-python-example

- [valet-labs/travisci-python-example.yml](valet-labs/travisci-python-example.yml)
- [valet-labs/travisci-python-example.config.json](valet-labs/travisci-python-example.config.json)
- [valet-labs/travisci-python-example.source.yml](valet-labs/travisci-python-example.source.yml)

#### valet-labs/travisci-deploy-example

- [valet-labs/travisci-deploy-example.yml](valet-labs/travisci-deploy-example.yml)
- [valet-labs/travisci-deploy-example.config.json](valet-labs/travisci-deploy-example.config.json)
- [valet-labs/travisci-deploy-example.source.yml](valet-labs/travisci-deploy-example.source.yml)
```

Here are some key terms that can appear in the “Pipelines” section:

- **Successful** pipelines had 0% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- **Partially successful** pipelines had 100% of all of the pipeline constructs converted, however, there were some individual items that were not converted automatically to their GitHub Actions equivalent.
- **Failed pipelines** encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in Travis CI.
  - Valet encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by Valet.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by Valet.

```md
Total: **25**

Known: **22 (88%)**

- install: **6**
- script: **5**
- before_script: **3**
- rvm: **2**
- after_deploy: **2**
- pushover: **1**
- irc: **1**
- before_deploy: **1**
- php: **1**

Unknown: **1 (4%)**

- codedeploy: **1**

Unsupported: **2 (8%)**

- sudo: **2**

Actions: **28**

- run: **17**
- actions/checkout@v2: **6**
- ruby/setup-ruby@v1: **2**
- rectalogic/notify-irc@v1: **1**
- shivammathur/setup-php@v2: **1**
- desiderati/github-action-pushover@v1: **1**
```

Here are some key terms that can appear in "Build steps" section:

- A **known** build step is a step that was automatically converted to an equivalent action.
- An **unknown** build step is a step that was not automatically converted to an equivalent action.
- An **unsupported** build step is a step that is either:
  - A step that is fundamentally not supported by GitHub Actions.
  - A step that is configured in a way that is incompatible with GitHub Actions.
- An **action** is a list of the actions that were used in the converted workflows. This is important for the following scenarios:
  - Gathering the list of actions to sync to your appliance if you use GitHub Enterprise Server.
  - Defining an organization-level allowlist of actions that can be used. This list of actions is a comprehensive list of which actions their security and/or compliance teams will need to review.

There is an equivalent breakdown of build triggers, environment variables, and other uncategorized items displayed in the audit summary file.

#### Manual Tasks

The manual tasks summary section presents an overview of the manual tasks that you will need to perform that Valet is not able to complete automatically.

```md
### Manual tasks

Total: **1**

Secrets: **1**

- `${{ secrets.PUSHOVER_USER_KEY }}`: **1**
```

Here are some key terms that can appear in “Manual tasks” section:

- A **secret** refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A **self-hosted runner** refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
### Partially successful

#### valet-labs/travisci-php-example

- [valet-labs/travisci-php-example.yml](valet-labs/travisci-php-example.yml)
- [valet-labs/travisci-php-example.config.json](valet-labs/travisci-php-example.config.json)
- [valet-labs/travisci-php-example.source.yml](valet-labs/travisci-php-example.source.yml)

#### valet-labs/travisci-nodejs-example

- [valet-labs/travisci-nodejs-example.yml](valet-labs/travisci-nodejs-example.yml)
- [valet-labs/travisci-nodejs-example.config.json](valet-labs/travisci-nodejs-example.config.json)
- [valet-labs/travisci-nodejs-example.source.yml](valet-labs/travisci-nodejs-example.source.yml)

#### valet-labs/travisci-ruby-example

- [valet-labs/travisci-ruby-example.yml](valet-labs/travisci-ruby-example.yml)
- [valet-labs/travisci-ruby-example.config.json](valet-labs/travisci-ruby-example.config.json)
- [valet-labs/travisci-ruby-example.source.yml](valet-labs/travisci-ruby-example.source.yml)

#### valet-labs/travisci-python-example

- [valet-labs/travisci-python-example.yml](valet-labs/travisci-python-example.yml)
- [valet-labs/travisci-python-example.config.json](valet-labs/travisci-python-example.config.json)
- [valet-labs/travisci-python-example.source.yml](valet-labs/travisci-python-example.source.yml)

#### valet-labs/travisci-deploy-example

- [valet-labs/travisci-deploy-example.yml](valet-labs/travisci-deploy-example.yml)
- [valet-labs/travisci-deploy-example.config.json](valet-labs/travisci-deploy-example.config.json)
- [valet-labs/travisci-deploy-example.source.yml](valet-labs/travisci-deploy-example.source.yml)
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in GitHub.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

## Inspect the workflow usage csv file

1. Open the `tmp/audit/workflow_usage.csv` file in the file explorer.
2. This file contains a comma-separated list of all actions, secrets, and runners that are used by each successfully converted pipeline:
  
    ```csv
    Pipeline,Action,File path
    valet-labs/travisci-php-example,actions/checkout@v2,/data/tmp/audit/valet-labs/travisci-php-example.yml
    valet-labs/travisci-php-example,shivammathur/setup-php@v2,/data/tmp/audit/valet-labs/travisci-php-example.yml
    valet-labs/travisci-php-example,rectalogic/notify-irc@v1,/data/tmp/audit/valet-labs/travisci-php-example.yml
    valet-labs/travisci-nodejs-example,actions/checkout@v2,/data/tmp/audit/valet-labs/travisci-nodejs-example.yml
    valet-labs/travisci-ruby-example,actions/checkout@v2,/data/tmp/audit/valet-labs/travisci-ruby-example.yml
    valet-labs/travisci-ruby-example,ruby/setup-ruby@v1,/data/tmp/audit/valet-labs/travisci-ruby-example.yml
    valet-labs/travisci-python-example,actions/checkout@v2,/data/tmp/audit/valet-labs/travisci-python-example.yml
    valet-labs/travisci-deploy-example,actions/checkout@v2,/data/tmp/audit/valet-labs/travisci-deploy-example.yml
    valet-labs/travisci-deploy-example,desiderati/github-action-pushover@v1,/data/tmp/audit/valet-labs/travisci-deploy-example.yml

    Pipeline,Secret,File path
    valet-labs/travisci-deploy-example,${{ secrets.PUSHOVER_USER_KEY }},/data/tmp/audit/valet-labs/travisci-deploy-example.yml

    Pipeline,Runner,File path
    ```

The contents of this file can be useful in answering questions similar to the following:
- What workflows will depend on which actions?
- What workflows use an action that must go through a security review?
- What workflows use specific secrets?
- What workflows use specific runners?

### Next lab

[Forecast potential build runner usage](3-forecast.md)

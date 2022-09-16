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

You will be performing an audit against the **labs-data** Travis CI organization that was created for the purposes of this lab. Your environment was configured to use this organization during the [configure lab](./1-configure.md). The remaining information needed to perform an `audit` is:

1. Where do we want to store the result?
    - **./tmp/audit**.  This can be any path within the working directory that Valet commands are executed from.

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

Summary for [Travis CI instance](https://travis-ci.com/valet-travis-labs)

- Valet version: **0.1.0.13539 (5bb6c723d6db3688ea0653e14bbf3c63df445bfc)**
- Performed at: **9/15/22 at 22:24**

## Pipelines

Total: **6**

- Successful: **0 (0%)**
- Partially successful: **6 (100%)**
- Unsupported: **0 (0%)**
- Failed: **0 (0%)**

### Job types

Supported: **6 (100%)**

- ruby: **2**
- c: **1**
- nodejs: **1**
- php: **1**
- python: **1**

### Build steps

Total: **29**

Known: **26 (89%)**

- script: **7**
- install: **6**
- before_script: **3**
- rvm: **2**
- after_deploy: **2**
- ccache: **1**
- pushover: **1**
- dependencies: **1**
- before_deploy: **1**
- php: **1**
- irc: **1**

Unknown: **1 (3%)**

- codedeploy: **1**

Unsupported: **2 (6%)**

- sudo: **2**

Actions: **32**

- run: **19**
- actions/checkout@v2: **7**
- ruby/setup-ruby@v1: **2**
- actions/cache@v2: **1**
- desiderati/github-action-pushover@v1: **1**
- shivammathur/setup-php@v2: **1**
- rectalogic/notify-irc@v1: **1**

### Triggers

Total: **36**

Known: **36 (100%)**

- crons: **6**
- branches: **6**
- config_validation: **6**
- build_pull_requests: **6**
- build_pushes: **6**
- builds_only_with_travis_yml: **6**

Actions: **12**

- pull_request: **6**
- push: **6**

### Environment

Total: **1**

Known: **1 (100%)**

- DB: **1**

Actions: **1**

- DB: **1**

### Other

Total: **18**

Known: **12 (66%)**

- auto_cancel_pull_requests: **6**
- auto_cancel_pushes: **6**

Unknown: **6 (33%)**

- maximum_number_of_builds: **6**

Actions: **3**

- matrix: **2**
- DB: **1**

### Manual tasks

Total: **1**

Secrets: **1**

- `${{ secrets.PUSHOVER_USER_KEY }}`: **1**

### Partially successful

#### valet-travis-labs/deploy-example

- [valet-travis-labs/deploy-example.yml](valet-travis-labs/deploy-example.yml)
- [valet-travis-labs/deploy-example.config.json](valet-travis-labs/deploy-example.config.json)
- [valet-travis-labs/deploy-example.source.yml](valet-travis-labs/deploy-example.source.yml)

#### valet-travis-labs/c-sharp-example

- [valet-travis-labs/c-sharp-example.yml](valet-travis-labs/c-sharp-example.yml)
- [valet-travis-labs/c-sharp-example.config.json](valet-travis-labs/c-sharp-example.config.json)
- [valet-travis-labs/c-sharp-example.source.yml](valet-travis-labs/c-sharp-example.source.yml)

#### valet-travis-labs/ruby-example

- [valet-travis-labs/ruby-example.yml](valet-travis-labs/ruby-example.yml)
- [valet-travis-labs/ruby-example.config.json](valet-travis-labs/ruby-example.config.json)
- [valet-travis-labs/ruby-example.source.yml](valet-travis-labs/ruby-example.source.yml)

#### valet-travis-labs/nodejs-example

- [valet-travis-labs/nodejs-example.yml](valet-travis-labs/nodejs-example.yml)
- [valet-travis-labs/nodejs-example.config.json](valet-travis-labs/nodejs-example.config.json)
- [valet-travis-labs/nodejs-example.source.yml](valet-travis-labs/nodejs-example.source.yml)

#### valet-travis-labs/php-example

- [valet-travis-labs/php-example.yml](valet-travis-labs/php-example.yml)
- [valet-travis-labs/php-example.config.json](valet-travis-labs/php-example.config.json)
- [valet-travis-labs/php-example.source.yml](valet-travis-labs/php-example.source.yml)

#### valet-travis-labs/python

- [valet-travis-labs/python.yml](valet-travis-labs/python.yml)
- [valet-travis-labs/python.config.json](valet-travis-labs/python.config.json)
- [valet-travis-labs/python.source.yml](valet-travis-labs/python.source.yml)

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
Total: **29**

Known: **26 (89%)**

- script: **7**
- install: **6**
- before_script: **3**
- rvm: **2**
- after_deploy: **2**
- ccache: **1**
- pushover: **1**
- dependencies: **1**
- before_deploy: **1**
- php: **1**
- irc: **1**

Unknown: **1 (3%)**

- codedeploy: **1**

Unsupported: **2 (6%)**

- sudo: **2**

Actions: **32**

- run: **19**
- actions/checkout@v2: **7**
- ruby/setup-ruby@v1: **2**
- actions/cache@v2: **1**
- desiderati/github-action-pushover@v1: **1**
- shivammathur/setup-php@v2: **1**
- rectalogic/notify-irc@v1: **1**
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

#### valet-travis-labs/deploy-example

- [valet-travis-labs/deploy-example.yml](valet-travis-labs/deploy-example.yml)
- [valet-travis-labs/deploy-example.config.json](valet-travis-labs/deploy-example.config.json)
- [valet-travis-labs/deploy-example.source.yml](valet-travis-labs/deploy-example.source.yml)

#### valet-travis-labs/c-sharp-example

- [valet-travis-labs/c-sharp-example.yml](valet-travis-labs/c-sharp-example.yml)
- [valet-travis-labs/c-sharp-example.config.json](valet-travis-labs/c-sharp-example.config.json)
- [valet-travis-labs/c-sharp-example.source.yml](valet-travis-labs/c-sharp-example.source.yml)

#### valet-travis-labs/ruby-example

- [valet-travis-labs/ruby-example.yml](valet-travis-labs/ruby-example.yml)
- [valet-travis-labs/ruby-example.config.json](valet-travis-labs/ruby-example.config.json)
- [valet-travis-labs/ruby-example.source.yml](valet-travis-labs/ruby-example.source.yml)

#### valet-travis-labs/nodejs-example

- [valet-travis-labs/nodejs-example.yml](valet-travis-labs/nodejs-example.yml)
- [valet-travis-labs/nodejs-example.config.json](valet-travis-labs/nodejs-example.config.json)
- [valet-travis-labs/nodejs-example.source.yml](valet-travis-labs/nodejs-example.source.yml)

#### valet-travis-labs/php-example

- [valet-travis-labs/php-example.yml](valet-travis-labs/php-example.yml)
- [valet-travis-labs/php-example.config.json](valet-travis-labs/php-example.config.json)
- [valet-travis-labs/php-example.source.yml](valet-travis-labs/php-example.source.yml)

#### valet-travis-labs/python

- [valet-travis-labs/python.yml](valet-travis-labs/python.yml)
- [valet-travis-labs/python.config.json](valet-travis-labs/python.config.json)
- [valet-travis-labs/python.source.yml](valet-travis-labs/python.source.yml)

```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in GitHub.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

### Next lab

[Perform a dry-run of a Travis CI pipeline](3-dry-run.md)

# Perform a dry-run migration of a GitLab pipeline

In this lab you will use the `dry-run` command to convert a GitLab pipeline to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment and start a GitLab server.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

You will be performing a dry run against a pipeline in your preconfigured GitLab server. Answer the following questions before running this command:

1. What project do you want to convert?
    - __basic-pipeline-example__

2. What is the namespace for that project?
    - __Valet__

3. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory from which Valet commands are executed.

### Steps

1. Navigate to your codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh valet dry-run gitlab --output-dir tmp/dry-run --namespace valet --project basic-pipeline-example
    ```

3. The command will list all the files written to disk when the command succeeds.

    ![img](https://user-images.githubusercontent.com/18723510/184173635-aec28d1c-8c61-4dcf-a743-f86cbdc836c5.png)

4. View the converted workflow:
    - Find `tmp/dry-run/valet` in the file explorer pane in your codespace.
    - Click `basic-pipeline-example.yml` to open.

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the given GitLab pipeline. The GitLab pipeline and converted workflow can be seen below:

<details>
  <summary><em>GitLab pipeline 👇</em></summary>

```yaml
stages:
  - build
  - test
  - deploy

image: alpine

build_a:
  stage: build
  script:
    - echo "This job builds something."
    - sleep 100

build_b:
  stage: build
  script:
    - echo "This job builds something else."
    - sleep 70

test_a:
  stage: test
  script:
    - echo "This job tests something. It will only run when all jobs in the"
    - echo "build stage are complete."

test_b:
  stage: test
  script:
    - echo "This job tests something else. It will only run when all jobs in the"
    - echo "build stage are complete too. It will start at about the same time as test_a."
    - sleep 300

deploy_a:
  stage: deploy
  script:
    - echo "This job deploys something. It will only run when all jobs in the"
    - echo "test stage complete."
    - sleep 600

deploy_b:
  stage: deploy
  script:
    - echo "This job deploys something else. It will only run when all jobs in the"
    - echo "test stage complete. It will start at about the same time as deploy_a."
    - sleep 400

```

</details>

<details>
  <summary><em>Converted workflow 👇</em></summary>

```yaml
name: valet/basic-pipeline-example
on:
  push:
  workflow_dispatch:
concurrency:
  group: "${{ github.ref }}"
  cancel-in-progress: true
jobs:
  build_a:
    runs-on: ubuntu-latest
    container:
      image: alpine
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: echo "This job builds something."
    - run: sleep 100
  build_b:
    runs-on: ubuntu-latest
    container:
      image: alpine
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: echo "This job builds something else."
    - run: sleep 70
  test_a:
    needs:
    - build_a
    - build_b
    runs-on: ubuntu-latest
    container:
      image: alpine
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: echo "This job tests something. It will only run when all jobs in the"
    - run: echo "build stage are complete."
  test_b:
    needs:
    - build_a
    - build_b
    runs-on: ubuntu-latest
    container:
      image: alpine
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: echo "This job tests something else. It will only run when all jobs in the"
    - run: echo "build stage are complete too. It will start at about the same time as test_a."
    - run: sleep 300
  deploy_a:
    needs:
    - test_a
    - test_b
    runs-on: ubuntu-latest
    container:
      image: alpine
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: echo "This job deploys something. It will only run when all jobs in the"
    - run: echo "test stage complete."
    - run: sleep 600
  deploy_b:
    needs:
    - test_a
    - test_b
    runs-on: ubuntu-latest
    container:
      image: alpine
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: echo "This job deploys something else. It will only run when all jobs in the"
    - run: echo "test stage complete. It will start at about the same time as deploy_a."
    - run: sleep 400
```

</details>

Despite these two pipelines using different syntax they will function equivalently.

## Perform a dry-run migration of a pipeline using `include`'d files

The previous example demonstrated a basic pipeline that mapped exactly to concepts in GitHub Actions. In this section, you will perform a dry run of the `included-files-example` pipeline that uses the `include` statement in GitLab:

```yaml
include:
  - local: /config/build.gitlab-ci.yml
  - local: /config/test.gitlab-ci.yml
```

Run the following command from the root directory:

```bash
gh valet dry-run gitlab --output-dir tmp/dry-run --namespace valet --project included-files-example
```

The output of the command above can be seen below:

```yaml
name: valet/included-files-example
on:
  push:
  pull_request:
  workflow_dispatch:
concurrency:
  group: "${{ github.ref }}"
  cancel-in-progress: true
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 50
        lfs: true
    - run: echo "[BEFORE_SCRIPT] this is from test.gitlab-ci.yml"
    - run: echo "this is from a local file"
  test:
    needs: build
    runs-on: ubuntu-latest
    timeout-minutes: 60
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 50
        lfs: true
    - run: echo "[BEFORE_SCRIPT] this is from test.gitlab-ci.yml"
    - run: echo "this is from a local file"
```

It's important to note that Valet converted this into a single workflow without templates. This is because of fundamental differences in how GitLab templates and GitHub Actions templates (i.e. Reusable Workflows and Composite Actions) function in regards to job ordering. Unfortunately, elements of reusability will be sacrificed in order for the converted pipelines to function the same. It is likely that the output of Valet could be refactored to use [reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows) at a later date.

As an added challenge, try constructing and running the `dry-run` command yourself. Hint, you should only have to change the project name.

## Next lab

[Use custom transformers to customize Valet's behavior](./5-custom-transformers.md)

# Dry run the migration of an GitLab pipeline to GitHub Actions
In this lab, you will use the Valet `dry-run` command to convert a GitLab pipeline to it's equivalent GitHub Actions workflow. 
The end result of this command will be the actions workflow writen to your local filesystem.

- [Prerequisites](#prerequisites)
- [Perform a dry run](#perform-a-dry-run)
- [Review dry-run output](#review-dry-run-output)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)


## Perform a dry run
We will be performing a dry-run against a preconfigured project in the GitLab instance. Before running the command we need to collect some information:
  1. What is the project we want to convert? __basic-pipeline-example__
  2. What is the namespace for that project? __Valet.  In this case the namespace is the same as the group the project is in__
  3. Where do we want to store the result? __./tmp/dry-run-lab.  This can be any valid path on the system.  In the case of codespaces it is generally best to use `./tmp/SOME_DIRECTORY_HERE` so the files show in explorer__

#### Steps
1. Navigate to the codespace terminal 
2. Run the dry-run command using the values determined above
   ```
   gh valet dry-run gitlab --output-dir ./tmp/dry-run-lab --namespace valet --project basic-pipeline-example
   ```
3. When the command finishes the output files should be printed to the terminal. 
    <img width="1112" alt="dry-run-terminal" src="https://user-images.githubusercontent.com/18723510/184173635-aec28d1c-8c61-4dcf-a743-f86cbdc836c5.png">
4. Open generated actions workflow
   - Find `./tmp/dry-run-lab/valet` in the file explorer pane in codespaces.
   - Click `basic-pipeline-example.yml` to opendr
   <img width="231" alt="dry-run-explorer" src="https://user-images.githubusercontent.com/18723510/184177477-747905a8-32f3-4c15-8955-32079844a509.png">


## Review dry-run output
The dry-run output will show you the GitHub Actions yaml that would be migrated to GitHub with the `migrate` command. We will now take a quick look at what was generated.

__Click to Expand__
<details>
  <summary><em>GitLab Pipeline</em> </summary>
 
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
  <summary><em>Actions Workflow</em></summary>
  
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

In the GitLab pipeline we had 3 stages and 6 jobs that run on a alpine image

In the Actions workflow we have the same jobs (`build_a`, `build_b`, `test_a`, `test_b`, `deploy_a`, `deploy_b`) and the stages are now being enforced using the `needs` keyword.  We can see this if we examine the `needs` for `test_a` and `test_b`, which make the test jobs depend on the build jobs.
```diff
- stages: test
+ needs:
+ - build_a
+ - build_b
```

The `image` in the GitLab pipeline has be transformed to `container` on each of the jobs.  
```diff
- image: alpine
+ container:
+   image: alpine
```
And `script` has been transformed to `run`
```diff
- script:
-  - echo "This job builds something."
+ run: echo "This job builds something."
```

## Includes Dry-Run
In the previous dry-run we migrated a basic pipeline that map very nicely to concepts in GitHub Actions.  In this section we will dry-run a pipeline that does not map directly to Actions.  The `include-file-example` pipeline

## Next Lab
TBD



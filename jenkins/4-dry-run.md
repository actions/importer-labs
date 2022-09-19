# Perform a dry-run migration of a Jenkins pipeline

In this lab you will use the `dry-run` command to convert a Jenkins pipeline to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and start a Jenkins server.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

You will be performing a dry run against a pipeline in your preconfigured Jenkins server. Answer the following questions before running this command:

1. What is the name of the pipeline you want to convert?
    - __test_pipeline__

2. What is the URL of the pipeline you want to convert?
    - __<http://localhost:8080/job/test_pipeline>__

3. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory from which Valet commands are executed.

### Steps

1. Navigate to your codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline --output-dir tmp/dry-run
    ```

3. The command will list all the files written to disk when the command succeeds.

    ```console
    $ gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline --output-dir tmp/dry-run
    [2022-08-20 22:08:20] Logs: 'tmp/dry-run/log/valet-20220916-022338.log'
    [2022-08-20 22:08:20] Output file(s):
    [2022-08-20 22:08:20]   tmp/dry-run/test_pipeline.yml
    ```

4. View the converted workflow:
    - Find `tmp/dry-run` in the file explorer pane in your codespace.
    - Click `test_pipeline.yml` to open

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the given Jenkins pipeline. The Jenkins pipeline and converted workflow can be seen below:

<details>
  <summary><em>Jenkins pipeline 👇</em></summary>

```groovy
pipeline {
    agent {
        label 'TeamARunner'
    }

    environment {
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
    }

    stages {
        stage('build') {
            steps {
                echo "Database engine is ${DB_ENGINE}"
                sleep 80
                echo "DISABLE_AUTH is ${DISABLE_AUTH}"
            }
        }
        stage('test') {
            steps{
                junit '**/target/*.xml'
            }
        }
    }
}
```

</details>

<details>
  <summary><em>Converted workflow 👇</em></summary>

```yaml
name: test_pipeline
on:
  push:
    paths: "*"
  schedule:
  - cron: 0-29/10 * * * *
env:
  DISABLE_AUTH: 'true'
  DB_ENGINE: sqlite
jobs:
  build:
    runs-on:
      - self-hosted
      - TeamARunner
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: echo message
      run: echo "Database engine is ${{ env.DB_ENGINE }}"
#     # This item has no matching transformer
#     - sleep:
#       - key: time
#         value:
#           isLiteral: true
#           value: 80
    - name: echo message
      run: echo "DISABLE_AUTH is ${{ env.DISABLE_AUTH }}"
  test:
    runs-on:
      - self-hosted
      - TeamARunner
    needs: build
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: Publish test results
      uses: EnricoMi/publish-unit-test-result-action@v1.7
      if: always()
      with:
        files: "**/target/*.xml"
```

</details>

These two pipelines function equivalently despite using different syntax. In this case, the pipeline conversion was “partially successful” (i.e. there were item(s) not automatically converted) and the unconverted item was placed as comment in the location the Jenkins pipeline used it. For example:

```diff
- sleep 80
+ #     # This item has no matching transformer
+ #     - sleep:
+ #       - key: time
+ #         value:
+ #           isLiteral: true
+ #           value: 80
```

In the next lab, you'll learn how to override Valet's default behavior and customize the converted workflow that is generated.

Try running the `dry-run` command for different pipelines in the Jenkins server. As a hint, you only have to change the `--source-url` CLI option.

## Next lab

[Use custom transformers to customize Valet's behavior](5-custom-transformers.md)

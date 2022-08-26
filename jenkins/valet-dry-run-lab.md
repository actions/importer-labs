# Dry-run the migration of a Jenkins pipeline to GitHub Actions

In this lab, you will use the Valet `dry-run` command to convert a Jenkins pipeline to its equivalent GitHub Actions workflow.
The end result of this command will be the actions workflow written to your local filesystem.

- [Prerequisites](#prerequisites)
- [Perform a dry-run](#perform-a-dry-run)
- [Review dry-run output](#review-dry-run-output)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed the steps [here](../jenkins/readme.md#valet-labs-for-jenkins) to set up your Codespace environment and start a Jenkins server.
2. Completed the [configure lab](../jenkins/valet-configure-lab.md#configure-valet-to-work-with-jenkins) to configure the Valet CLI.
3. Completed the [audit lab](../Jenkins/valet-audit-lab.md#audit-jenkins-pipelines-using-the-valet-audit-command).

## Perform a dry-run

We will be performing a dry-run against a preconfigured pipeline in the Jenkins instance. Before running the command we need to collect some information:

  1. What is the name of the pipeline we want to convert? __test_pipeline__
  2. What is the source URL of the pipeline we want to convert? __<http://localhost:8080/job/test_pipeline>__
  3. Where do we want to store the result? __./tmp/dry-run-lab.  This can be any valid path on the system.  In the case of codespaces it is generally best to use `./tmp/SOME_DIRECTORY_HERE` so the files show in explorer__

### Steps

1. Navigate to the codespace terminal
2. Run the dry-run command using the values determined above

   ```
   gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run
   ```

3. When the command finishes the output files should be printed to the terminal.
    <img width="915" alt="Screen Shot 2022-08-16 at 9 54 26 AM" src="https://user-images.githubusercontent.com/19557880/184935603-5c2d4dfe-66ef-4cb1-9398-e96954ca72e3.png">
4. Open generated actions workflow
   - Find `./tmp/dry-run-lab/valet` in the file explorer pane in codespaces.
   - Click `test_pipeline.yml` to open

  <img width="234" alt="Screen Shot 2022-08-16 at 9 55 44 AM" src="https://user-images.githubusercontent.com/19557880/184935840-d4bdcbc9-75e5-4918-a055-28b765eac50c.png">

## Review dry-run output

The dry-run output will show you the GitHub Actions yaml that would be migrated to GitHub with the `migrate` command. We will now take a quick look at what was generated.

__Click to Expand__
<details>
  <summary><em>Jenkins Pipeline</em> </summary>

```yaml
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
  <summary><em>Actions Workflow</em></summary>

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

In the Jenkins pipeline we have 2 stages and 4 steps that run on the self-hosted runner labeled `TeamARunner`.

In the Actions workflow we have the same steps and the stages are now being enforced using the `needs` keyword.  We can see this if we examine the `test` job, it has `needs: build`, which makes it depend on the `build` job.

```diff
- stages: test
+ needs: build
```

The `agent` in the Jenkins pipeline has been transformed to `runs-on` on each of the jobs.  

```diff
- agent {
-   label 'TeamARunner'
- }
+ runs-on:
+   - self-hosted
+   - TeamARunner
```

And the `echo` commands remain mostly the same

```diff
- echo "Database engine is ${DB_ENGINE}"
+ - name: echo message
+   run: echo "DISABLE_AUTH is ${{ env.DISABLE_AUTH }}"
```

Note how Valet was not able to find a suitable conversion for the `sleep` command, and it added a comment to the yaml so this information was not lost, and it could be addressed manually later if needed.

```diff
- sleep 80
+ #     # This item has no matching transformer
+ #     - sleep:
+ #       - key: time
+ #         value:
+ #           isLiteral: true
+ #           value: 80
```

Lastly, the `junit` command was transformed using a third party action `EnricoMi/publish-unit-test-result-action@v1.7`

```diff
- junit '**/target/*.xml' 
+ - name: Publish test results
+   uses: EnricoMi/publish-unit-test-result-action@v1.7
+   if: always()
+   with:
+     files: "**/target/*.xml"
```

Try constructing and running the `dry-run` command yourself. Hint, you should just have to change the project name.

## Next Lab

[Using Custom Transformers in a dry-run](valet-custom-transformers-lab.md#using-custom-transformers-in-a-dry-run)

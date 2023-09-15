# Perform a dry-run migration of a Bitbucket pipeline

In this lab you will use the `dry-run` command to convert a Bitbucket pipeline to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

Before executing the dry-run command we will need to answer the following questions.

1. What repository is that pipeline in?
    - __react-deploy__

2. What is the workspace for that repository?
    - __actions-importer__

3. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory from which GitHub Actions Importer commands are executed.

### Steps

1. Navigate to your codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh actions-importer dry-run bitbucket --output-dir tmp/dry-run --workspace actions-importer --repository react-deploy --source-file-path ./bitbucket/bootstrap/source_files/react_deploy.yml
    ```
     > Note: The `--source-file-path` option is not required and is used throughout this lab to convert a pipeline that is stored locally. This can be omitted and GitHub Actions Importer will programmatically fetch pipelines using the Bitbucket REST APIs

3. The command will list all the files written to disk when the command succeeds.

    ```console
    ❯ gh actions-importer dry-run bitbucket --output-dir tmp/dry-run --workspace actions-importer --repository react-deploy --source-file-path ./bitbucket/bootstrap/source_files/react_deploy.yml 
    [2023-09-07 19:00:29] Logs: 'tmp/dry-run/log/valet-20230907-190029.log'         
    [2023-09-07 19:00:29] Output file(s):                                           
    [2023-09-07 19:00:29]   tmp/dry-run/actions-importer/react-deploy/.github/workflows/default.yml
    [2023-09-07 19:00:29]   tmp/dry-run/actions-importer/react-deploy/.github/workflows/branches-master.yml
    ```

4. View the converted workflows:
    - Find `tmp/dry-run/actions-importer/react-deploy/.github/workflows` in the file explorer pane in your codespace.
    - Click `default.yml` to open the workflow that was generated for the __default__ start condition.
    - Click `branches-master.yml` to open workflow that was generated for the __master branch__ start condition.

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflows for the given Bitbucket pipeline. The Bitbucket pipeline and converted workflows can be seen below:

<details>
  <summary><em>Bitbucket pipelines 👇</em></summary>

```yaml
pipelines:
  default:
    - parallel:
      - step:
          name: Build and Test
          caches:
            - node
          script:
            - npm install
            - npm test
      - step:
          name: Lint the node package
          script:
            - npm install eslint
            - npx eslint src
          caches:
            - node
  branches:
    master:
      - parallel:
        - step:
            name: Build and Test
            caches:
              - node
            script:
              - npm install
              - npm test
              - npm run build
            artifacts:
              - build/**
        - step:
            name: Security Scan
            script:
              - pipe: atlassian/git-secrets-scan:0.5.1
      - step:
          name: Deploy to Production
          deployment: Production
          trigger: manual
          clone:
            enabled: false
          script:
            - pipe: atlassian/aws-s3-deploy:1.1.0
              variables:
                AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
                AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
                AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION
                S3_BUCKET: 'my-bucket-name'
                LOCAL_PATH: 'build'
            - pipe: atlassian/aws-cloudfront-invalidate:0.6.0
              variables:
                AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
                AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
                AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION
                DISTRIBUTION_ID: '123xyz'
```

</details>

<details>
  <summary><em>Converted default workflow 👇</em></summary>

default.yml
```yaml
name: default
on:
  push:
    branches:
    - "!master"
jobs:
  parallel_job_1:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.6.0
    - name: Cache node
      uses: actions/cache@v3.3.1
      with:
        key: "${{ runner.os }}-node-${{ hashFiles('node_modules') }}"
        path: node_modules
    - name: Build and Test
      run: |-
        npm install
        npm test
  parallel_job_2:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.6.0
    - name: Cache node
      uses: actions/cache@v3.3.1
      with:
        key: "${{ runner.os }}-node-${{ hashFiles('node_modules') }}"
        path: node_modules
    - name: Lint the node package
      run: |-
        npm install eslint
        npx eslint src

```

</details>

<details>
  <summary><em>Converted master branch workflow 👇</em></summary>

default.yml
```yaml
name: branches-master
on:
  push:
    branches: master
jobs:
  parallel_job_1:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.6.0
    - name: Cache node
      uses: actions/cache@v3.3.1
      with:
        key: "${{ runner.os }}-node-${{ hashFiles('node_modules') }}"
        path: node_modules
    - name: Build and Test
      run: |-
        npm install
        npm test
        npm run build
    - uses: actions/upload-artifact@v3.1.1
      with:
        name: parallel_job_1
        path: build/**
  parallel_job_2:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.6.0
    - uses: actions/checkout@v3.6.0
      with:
        path: git-secrets
        repository: awslabs/git-secrets
    - run: |
        cd git-secrets
        sudo make install
        git secrets --register-aws --global
        cd ..
    # This transformed result does custom secret scanning using AWS, however the recommended way
    # to do this is to use the GitHub secret scanning feature.
    # See https://docs.github.com/en/code-security/secret-scanning/protecting-pushes-with-secret-scanning for more information.
    - run: git secrets --scan --recursive .
  step_job_3:
    runs-on: ubuntu-latest
    environment:
      name: Production
    needs:
    - parallel_job_2
    - parallel_job_1
    steps:
    - uses: actions/checkout@v3.6.0
    - uses: aws-actions/configure-aws-credentials@v3.0.1
      with:
        aws-access-key-id: "$AWS_ACCESS_KEY_ID"
        aws-secret-access-key: "$AWS_SECRET_ACCESS_KEY"
        aws-region: "$AWS_DEFAULT_REGION"
    - uses: actions/download-artifact@v3.0.1
      with:
        name: parallel_job_1
    - run: aws s3 sync build s3://my-bucket-name
    - name: Invalidate Cloudfront Distribution
      run: aws cloudfront create-invalidation --distribution-id 123xyz
```

</details>

Let's compare the Bitbucket pipeline with the generated workflows and identify some key differences:

- Two workflows were created for a single Bitbucket pipeline. This is because GitHub Actions defines triggers at the workflow level, and the Bitbucket pipeline had two triggers (or start conditions).

- The default start condition's parallel steps have been split into two jobs, `parallel_job_1` and `parallel_job_2`. This modification was made to align more closely with GitHub Actions, where steps cannot run in parallel but jobs can.

  ```yaml
  jobs:
  parallel_job_1:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.6.0
    - name: Cache node
      uses: actions/cache@v3.3.1
      with:
        key: "${{ runner.os }}-node-${{ hashFiles('node_modules') }}"
        path: node_modules
    - name: Build and Test
      run: |-
        npm install
        npm test
  parallel_job_2:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3.6.0
    - name: Cache node
      uses: actions/cache@v3.3.1
      with:
        key: "${{ runner.os }}-node-${{ hashFiles('node_modules') }}"
        path: node_modules
    - name: Lint the node package
      run: |-
        npm install eslint
        npx eslint src
  ```

Despite these differences they will function equivalently.
## Next lab

[Use custom transformers to customize GitHub Actions Importer's behavior](./5-custom-transformers.md)

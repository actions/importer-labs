# Perform a dry-run of a CircleCI pipeline

In this lab you will use the `dry-run` command to convert a CircleCI pipeline to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment and start a GitLab server.
2. Completed the [configure lab](./1-configure-lab.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

We will be performing a dry-run against a CircleCI project. We will need to answer the following questions before running this command:

1. What is the name of the project we want to convert?
    - __circleci-demo-ruby-rails__.  This is one of the sample projects avaiable in the CircleCI labs-data organization.

2. Where do we want to store the result?
    - __./tmp/dry-run-lab__. This can be any path within the working directory that Valet commands are executed from.

### Steps

1. Navigate to the codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh valet dry-run circle-ci --output-dir ./tmp/dry-run-lab --circle-ci-project circleci-demo-ruby-rails
    ```

3. The command will list all the files written to disk when the command succeeds.

    ADD_IMAGE_HERE

4. View the converted workflow:
    - Find `./tmp/dry-run-lab/labs-data/circleci-demo-ruby-rails` in the file explorer pane in codespaces.
    - Click `build_and_test.yml` to open.
   
## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the CircleCI project. The CircleCI configuration and converted workflow can be seen below:

<details>
  <summary><em>CircleCI configuration 👇</em></summary>

```yaml
# ADD YAML
```

</details>

<details>
  <summary><em>Converted workflow 👇</em></summary>
  
```yaml
# ADD YAML
```
</details>

Despite these 2 pipelines using different syntax they will function equivalently.

## Next lab

[Use custom transformers to customize Valet's behavior](./4-custom-transformers.md)

# Using Custom Transformers in a `dry-run`
In this lab we want to do a `dry-run` of the `terraform-example` project.  Since we have already taken the `dry-run` lab we easily run the command and generate the GitHub workflow, but to our dismay Valet did not know how to transform the artifact report for Terraform and it shows as unsupported.  After some research we determine that the action `actions/upload-artifact` would be an adequate substitute for it.  This change will also require us to change the environment variable `PLAN_JSON` to point to a new value `custom_plan.json`.  We need to make this change in many pipelines and a automated way to apply this would be ideal.  Well, we are in luck we can use the `--custom-transformers` option of the `dry-run` command.  This will allow us to change the behavior of Valet using a simple ruby file.

- [Prerequisites](#prerequisites)
- [Write Custom Transformers](#write-custom-transformers)
- [Run with Custom Transformers](#run-with-custom-transformers)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)
3. Completed the [dry-run lab](../gitlab/valet-dry-run-lab.md)

## Write Custom Transformer
- Lets run the `dry-run` command to see what information we can get from the generated action yaml.
  ```
  gh valet dry-run gitlab --output-dir tmp --namespace valet --project custom-transformer
  ```
- Open the resulting GitHub Actions workflow
```
name: valet/custom-transformer
on:
  push:
  workflow_dispatch:
concurrency:
  group: "${{ github.ref }}"
  cancel-in-progress: true
jobs:
  plan:
    runs-on: ubuntu-latest
    timeout-minutes: 60
    env:
      PLAN: plan.cache
      PLAN_JSON: plan.json
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 20
        lfs: true
    - run: terraform plan -out=$PLAN
    - run: terraform show --json $PLAN | convert_report > $PLAN_JSON
#     # 'artifacts.terraform' was not transformed because there is no suitable equivalent in GitHub Actions
```
- We can see from the last line of the yaml that `artifacts.terraform` was not transformed.  In order for us to fix this we need to write a custom transformer.  The important information in this comment is the identifier `artifacts.terraform`.  This is how our custom transformer will target this step.  
## Run with Customer Transformers

## Next Lab

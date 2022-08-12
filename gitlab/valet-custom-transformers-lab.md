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
  ```bash
  gh valet dry-run gitlab --output-dir tmp --namespace valet --project custom-transformer
  ```
- Open the resulting GitHub Actions workflow
```yaml
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
- We can see from the last line that `artifacts.terraform` was not transformed.  In order for us to write a custom transformer we need to know the identifier which in general is the value between the back ticks `artifacts.terraform`.  This is how our custom transformer will target the correct step.
- The custom transformers file can have any name, but it is recommend that you use a `.rb` extension so the codespaces editor knows it is a ruby file.
- we have chosen the `actions/upload-artifacts` as our replacement so we should look at the [docs](https://github.com/marketplace/actions/upload-a-build-artifact) to determine the correct final yaml
  ```yaml
  - uses: actions/upload-artifact@v3
    with:
      path: VALUE_FROM_GITLAB
  ```
- Now we know the final yaml we can write the ruby file.  In this file we will call the `transform` method.  This is a special method that Valet exposes, that takes the identifier we determined earlier and returns a Hash, which is basically the JSON version of the yaml we want.  Valet will call that method when it encounters the identifer and pass in an `item`.  The `item` is the values defined for that step in GitLab.  In this case the path of the terraform report.
  ```ruby
  transform "artifacts.terraform" do |item|
    {
      uses: "actions/upload-artifact@v2",
      with: {
        path: item
      }
    }
  end
  ```

- Custom transformers files also let up replace value of `variables` by using the `env` method.  Lets replace the value for `PLAN_JSON` by adding the this line to the top of our ruby file. The first value of the `env` method is the target variable name and the second is the new value.
  ```ruby
  env "PLAN_JSON", "custom_plan.json"
  ```
- create a new file in the root of the workspace called `transformers.rb` with below contents 
  ```ruby
  env "PLAN_JSON", "custom_plan.json"

  transform "artifacts.terraform" do |item|
    {
      uses: "actions/upload-artifact@v2",
      with: {
        path: item
      }
    }
  end
  ```
## Run with Customer Transformers
To run the `dry-run` with our custom transformer we add the `--custom-transformers` option followed by the path of the file
```bash
gh valet dry-run gitlab --output-dir tmp --namespace valet --project custom-transformer --custom-transformers transformers.rb
```

The customer tranformer worked and now we have the `upload-artifact` in the place of the unsupported result.
```diff
- #     # 'artifacts.terraform' was not transformed because there is no suitable equivalent in GitHub Actions
+ uses: actions/upload-artifact@v2
+ with:
+   path: "$PLAN_JSON"
```
Also we can see the `PLAN_JSON` env has been updated to `custom_plan.json`
```diff
 env:
   PLAN: plan.cache
-  PLAN_JSON: plan.json
+  PLAN_JSON: custom_plan.json
```

Now that we have this custom transformers file we can add additional `transform` methods it need and reuse while running other `dry-run` and `migrate` commands

## Next Lab
[Audit a GitLab Namespace](../gitlab/valet-audit-lab.md)

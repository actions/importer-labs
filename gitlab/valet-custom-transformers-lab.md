# Using Custom Transformers in a `dry-run`
In this lab we want to do a `dry-run` of the `terraform-example` project.  We can now perform a `dry-run` of this project, however, we have discovered that the output will need to be customized to transform the Terraform artifact report.  After some research, we have determined that the `actions/upload-artifact` action will be an adequate substitute for it.  Additionally, we will need to change the environment variable `PLAN_JSON` to use to a different value: `custom_plan.json`.  This customization will be present in many pipelines and an automated way to apply this would be ideal.  In this lab, we will use the `--custom-transformers` option to change the behavior of Valet using its DSL built on top of the Ruby language.

- [Prerequisites](#prerequisites)
- [Write Custom Transformers](#write-custom-transformers)
- [Run with Custom Transformers](#run-with-custom-transformers)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)
3. Completed the [dry-run lab](../gitlab/valet-dry-run-lab.md)

## Write Custom Transformers
- Let’s run the `dry-run` command to see what information we can get from the generated action yaml.
  ```bash
  gh valet dry-run gitlab --output-dir tmp --namespace valet --project terraform-example
  ```
- Open the resulting GitHub Actions workflow by navigating to `tmp/valet/custom-transformer.yml` from the explorer
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
- We can see from the last line that `artifacts.terraform` was not transformed.  In order for us to write a custom transformer for this we need to know the identifier. In general, the identifier will be the value between the backticks, which in this case is `artifacts.terraform`.  This is how our custom transformer will target the correct step.
- The custom transformers file can have any name, but it is recommended that you use an `.rb` extension so the codespaces editor knows it is a ruby file and can provide syntax highlighting.
- we have chosen the `actions/upload-artifacts` as our replacement so we should look at the action's [documentation](https://github.com/marketplace/actions/upload-a-build-artifact) to determine the correct final yaml
  ```yaml
  - uses: actions/upload-artifact@v3
    with:
      path: VALUE_FROM_GITLAB
  ```
- Now that we know the final yaml needed for the transformer, we can start to write the ruby file.  In the custom transformers file we will call the `transform` method.  This is a special method that Valet exposes, that takes the identifier we determined earlier and returns a ruby Hash of the final YAML for the pipeline.  The ruby Hash can be thought of as the JSON representation of the YAML we want. Valet will call that method when it encounters the identifier and pass in an `item`.  The `item` is the values defined for that step in GitLab.  In this case the item is the path of the terraform report. 

Note: If you were unsure what `item` represents, you could use some basic ruby to print `item` to the terminal. You can achieve this by adding the following line in the transform method:
`puts "This is the item: #{item}"`
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

- The custom transformers file also lets you replace values of `variables` by using the `env` method.  Let’s replace the value for `PLAN_JSON` by using the below line. The first value of the `env` method is the target variable name and the second is the new value to be used.
  ```ruby
  env "PLAN_JSON", "custom_plan.json"
  ```
- create a new file in the root of the workspace called `transformers.rb` with the following contents 
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
## Run Again with Customer Transformers
To run the `dry-run` with our custom transformer we will add the `--custom-transformers` flag followed by the path of the custom transformer ruby file
```bash
gh valet dry-run gitlab --output-dir tmp --namespace valet --project terraform-example --custom-transformers transformers.rb
```

The custom transformer worked and now we have the `upload-artifact` in the place of the unsupported result.
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

Now that we have this custom transformers file we can add additional `transform`and `env` methods as needed and reuse it while running other `dry-run` and `migrate` commands.  

Note: The custom transformers will only affect the pipeline being transformed if they contain the matching identifiers. If you believe a custom transformer should have altered the output, double check that the identifier is correct.  

## Next Lab
[Migrating a GitLab Pipeline](../gitlab/valet-migrate-lab.md)

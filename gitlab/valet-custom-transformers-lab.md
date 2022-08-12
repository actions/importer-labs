# Using Custom Transformers in a `dry-run`
In this lab we want to do a `dry-run` of the `terraform-example` project.  Since we have already taken the `dry-run` lab we easily run the command and generate the GitHub workflow, but to our dismay Valet did not know how to transform the artifact report for Terraform and it shows as unsupported.  After some research we determine that the action `actions/upload-artifact` would be an adequate substitute for it.  This change will also require us to change the environment variable `PLAN_JSON` to point to a new value `custom_plan.json`.  We need to make this change in many pipelines and a automated way to apply this would be ideal.  Well, we are in luck we can use the `--custom-transformers` option of the `dry-run` command.  This will allow us to change the behavior of Valet using a simple ruby file.

- [Prerequisites](#prerequisites)
- [Run without Custom Transformers](#run-without-custom-transformers)
- [Run with Custom Transformers](#run-with-custom-transformers)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)
3. Completed the [dry-run lab](../gitlab/valet-dry-run-lab.md)

## Run without Custom Transformers

## Run with Customer Transformers

## Next Lab

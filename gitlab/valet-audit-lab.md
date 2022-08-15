# Audit GitLab using the Valet audit command

In this lab, you will use Valet to `audit` a GitLab namespace. The `audit` command can be used to scan a CI server and output a summary of the current pipelines.
What happens behind the scenes is that Valet will perform a `dry-run` on each of the pipelines.  Once that is complete, Valet will perform an aggregation of all of the transformed workflows. This aggregate summary can be used as a planning tool and help understand how complete of a migration is possible with Valet.
By the end of this lab you will have performed an audit on the demo GitLab instance, and have a good understanding of the components that make up an audit.

- [Prerequisites](#prerequisites)
- [Perform an audit](#perform-an-audit)
- [View audit output](#view-audit-output)
- [Review the pipelines](#review-the-pipelines)
- [Next Lab](#next-lab)

## Prerequisites

1. Follow all steps [here](../gitlab#readme) to set up your environment.
2. Follow all steps [here](../gitlab#valet-configure-lab) to configure Valet.

## Perform an audit

We will be performing an audit against a preconfigured GitLab instance. Before running the command we need to collect some information:

  1. What namespace do we want to audit? __valet__
  2. Where do we want to store the result? __tmp/audit__

### Steps

1. Navigate to the codespace terminal.
2. Now, from root directory, run the following Valet audit command:
  
```
gh valet audit gitlab --output-dir tmp/audit --namespace valet
```

3. Valet will print the locations of the audit results in the terminal when complete
   ADD_SCREENSHOT_HERE

## View audit output

## Review the pipelines

### Next Lab

# Audit GitLab using the Valet audit command

In this lab, you will use Valet to `audit` a GitLab namespace. The `audit` command will scan the GitLab namespace provided for all projects with pipelines that have run at least once, perform a `dry-run` on each of those pipelines, and finally perform an aggregation of all of the transformed workflows. This aggregate summary can be used as a planning tool and help understand how complete of a migration is possible with Valet.
The goal of this lab is to performed an audit on the demo GitLab instance, and gain a good understanding of the components that make up an audit output.

- [Prerequisites](#prerequisites)
- [Perform an audit](#perform-an-audit)
- [Audit Files](#audit-files)
- [Review audit summary](#review-audit-summary)
- [Review the pipelines](#review-the-pipelines)
- [Next Lab](#next-lab)

## Prerequisites

1. Follow all steps [here](../gitlab#readme) to set up your environment.
2. Follow all steps [here](../gitlab#valet-configure-lab) to configure Valet.

## Perform an audit
Before running the command we need to collect some information:

  1. What namespace or group do we want to audit? __valet__
  2. Where do we want to store the result? __tmp/audit__

### Steps

1. Navigate to the codespace terminal.
2. Run the following Valet audit command with the provided answers above:
  
```
gh valet audit gitlab --output-dir tmp/audit --namespace valet
```

3. Valet will print the locations of the audit results in the terminal when complete
   ADD_SCREENSHOT_HERE

## Audit Files
The `audit` command outputs the following files

| File Type  |  Naming Convention |  Description |
| ----------------- | ------------------------- | ---------------------------- |
| GitLab Pipeline source | PROJECT_NAME.source.yml | The `.gitlab-ci.yml` file in the GitLab Project |
| GitLab Project configuration | PROJECT_NAME.config.json | Contains meta data retrieved for the GitLab Project |
| Valet log file | valet-TIMESTAMP.log |  Log generated during an audit. Mainly used for troubleshooting |
| GitHub Action workflows | PROJECT_NAME.yml | GitHub Actions workflow that would be migrated to GitHub |
| Error file | PROJECT_NAME.error.txt | Created when there is a error transforming the pipeline |
| Audit Summary | audit_summary.md | Contains a summary of audit results and the main file of interest to understand the how complete of a migration can be done with Valet |
| GitHub Actions Reusable Workflows & Composite Actions | .github/workflows/NAME_HERE.yml | These files will only appear if Valet encountered a pipeline that would generated them. These files would be part of the migration to GitHub if they existed |

## Review audit summary
1. Under the `audit` folder find the `audit_summary.md`
2. Right-click the `audit_summary.md` file and select `Open Preview`
3. This file contains details about what can be migrated 100% automatically vs. what will need some manual intervention or aren't supported by GitHub Actions.
4. Review the file, it should look like the image below:
   ADD_SCREENSHOT_HERE
   
## Review the pipelines

### Next Lab

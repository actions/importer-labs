# Dry run the migration of an GitLab pipeline to GitHub Actions
In this lab, you will use the Valet `dry-run` command to convert a GitLab pipeline to it's equivalent GitHub Actions workflow. 
The end result of this command will the actions workflow writen to your local filesystem.

- [Prerequisites](#prerequisites)
- [Perform a dry run](#perform-a-dry-run)
- [View dry-run output](#view-dry-run-output)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the configure [lab](../gitlab/valet-configure-lab.md)


## Perform a dry run
We will be performing a dry-run against a preconfigured project in the GitLab instance. Before running the command we need to collect some information:
  1. What is the project we want to convert? <span style="color:green">basic-pipeline-example</span> 
  2. What is the namespace for that project? <span style="color:green">Valet.  In this case the namespace is the same as the group the project is in.</span> 
  3. Where do we want to store the result? <span style="color:green">./tmp/dry-run-lab.  This can be any valid path on the system.  In the case of codespaces it is generally best to use `./tmp/SOME_DIRECTORY_HERE` so they files show in explorer</span>

#### Steps
1. Navigate to the codespace terminal 
2. Run the dry-run command 
   ```
   gh valet dry-run gitlab --output-dir ./tmp/dry-run-lab --namespace valet --project basic-pipeline-example`
   ```
3. Valet should have printed the output files in the terminal. 
4. Navigate to `./tmp/dry-run-lab` in the Explorer pane in codespaces and open `basic-pipeline-example.yml`. This is the converted GitHub Actions YAML file. 
### Example
ADD_IMAGE

## View dry-run output
The dry-run output will show you the GitHub Actions yaml that will be migrated to GitHub.

### Example
ADD_IMAGE

### Next Lab
TBD



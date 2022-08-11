# Dry run the migration of an GitLab pipeline to GitHub Actions
In this lab, you will use the Valet `dry-run` command to convert a GitLab pipeline to it's equivalent GitHub Actions workflow. 
The end result of this command will be the actions workflow writen to your local filesystem.

- [Prerequisites](#prerequisites)
- [Perform a dry run](#perform-a-dry-run)
- [View dry-run output](#view-dry-run-output)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)


## Perform a dry run
We will be performing a dry-run against a preconfigured project in the GitLab instance. Before running the command we need to collect some information:
  1. What is the project we want to convert? __basic-pipeline-example__
  2. What is the namespace for that project? __Valet.  In this case the namespace is the same as the group the project is in__
  3. Where do we want to store the result? __./tmp/dry-run-lab.  This can be any valid path on the system.  In the case of codespaces it is generally best to use `./tmp/SOME_DIRECTORY_HERE` so the files show in explorer__

#### Steps
1. Navigate to the codespace terminal 
2. Run the dry-run command using the values determined above
   ```
   gh valet dry-run gitlab --output-dir ./tmp/dry-run-lab --namespace valet --project basic-pipeline-example
   ```
3. When the command finishes the output files should be printed to the terminal. 
    <img width="1112" alt="dry-run-terminal" src="https://user-images.githubusercontent.com/18723510/184173635-aec28d1c-8c61-4dcf-a743-f86cbdc836c5.png">
4. Open generated actions workflow
   - Find `./tmp/dry-run-lab/valet` in the file explorer pane in codespaces.
   - Click `basic-pipeline-example.yml` to opendr
   <img width="231" alt="dry-run-explorer" src="https://user-images.githubusercontent.com/18723510/184177477-747905a8-32f3-4c15-8955-32079844a509.png">


## View dry-run output
The dry-run output will show you the GitHub Actions yaml that will be migrated to GitHub.

### Example
ADD_IMAGE

### Next Lab
TBD



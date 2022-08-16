# Migrate an Azure DevOps pipeline to GitHub Actions 
In this lab, you will use the Valet `migrate` command to migrate a GitLab pipeline to GitHub Actions. 
All of the previous commands we have been using, such as `audit` and `dry-run` have be preparing us to run the `migrate` command.
The `migrate` command is what will generate the GitHub Actions workflow files like the `dry-run` and then create a pull request with the files.  
The pull request will also contain `Manual Tasks` if required. These task are manual steps that Valet could not do on your behalf, like creating a runner or adding a secret.

- [Prerequisites](#prerequisites)
- [Preparing for migration](#preparing-for-migration)
- [Perform a migration](#perform-a-migration)
- [View the pull request](#view-the-pull-request)
- [Next Lab](#next-lab)

## Prerequisites
1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)

## Preparing for migration
Before running the command we need to collect some information:
  1. What is the project we want to migrate? TBD
  2. What is the namespace for that project? __Valet.  In this case the namespace is the same as the group the project is in__
  3. What is the GitHub Repository we want to add the workflow too? TBD
 
## Perform a migration
1. Run `migrate` command using the information collected above
```
gh valet migrate gitlab --target-url https://github.com/GITHUB-ORG/GITHUB-REPO --output-dir migrate --namespace valet --project TBD
```
2. Valet will create a pull request directly to your GitHub repository.
3. Open the pull request by clicking the green pull request link in the output of the migrate command. See below.
ADD_SCREENSHOT_HERE

## Review the pull request
TBD

### Next Lab
TBD

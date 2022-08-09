# Valet labs for GitLab

This lab bootstraps a Valet environment using GitHub Codespaces and enables you to run the Valet CI/CD migration tool against a isolated GitLab instance running in Docker. 

- [Use this Repo as a template](#repo-template)
- [Prerequisites](#prerequisites)
- [Codespace secrets](#codespace-secrets)
- [Action secrets](#action-secrets)
- [Azure DevOps project creation](#azure-devops-project-creation)
- [Use Valet with a codespace](#use-valet-with-a-codespace)
- [Labs for Azure DevOps](#labs-for-azure-devops)

## Repo template

1. Verify you are in your own Repository created from the landing page [Valet Labs](https://github.com/valet-customers/labs).

## Prerequisites
1. Create a GitHub personal access token. 
    - To do so, navigate to your GitHub `Settings` - click your profile photo and then click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the PAT somewhere safe and temporary.

## Codespace secrets
Please add the following Codespace secrets.
- `VALET_GHCR_PASSWORD`: Add `VALET_GHCR_PASSWORD` as the `Name` and the GitHub personal access token created above as the value.

Steps to create the Codespace secrets. Complete for secret noted above:

- Navigate to the `Settings` tab in this repo
- Find `Secrets` and click the down arrow
- Click `Codespaces`
- Click `New Repository Secret` to create a new secret
- Name the secret as noted above
- Paste in the value noted above
- Click `Add Secret`

## Use Valet with a codespace

1. Start the codespace
    - Click the `Code` with button down arrow above repository on the repository's landing page.
    - Click the `Codespaces` tab
    - Click `Create codespaces on main` to create the codespace. If you are in another branch then the `main` branch, the codespace will button will have the current branch specified.
    - Wait a couple minutes, then verify that the codespace starts up. Once it is fully booted up, the termininal should be present.
2. Verify Valet CLI is installed and working. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
    -  Verify Valet CLI is installed and working
    -  Run `gh valet version` in the Visual Studio Code terminal and verify the output looks like the below image. Note the valet version will be different than below as the latest version gets pulled down.
       -  If `gh valet version` did not produce a similar image with a version please follow these instructions [Troubleshoot GH Valet extension](#troubleshoot-gh-valet-extension)
    -  Start using Valet by following along with the [Labs for Azure DevOps](#labs-for-azure-devops)
3. Run GitLab setup script.  This script will setup GitLab and ensure it is ready to use.  In general, this script should be run first if you are starting a new codespace or restarting a existing one.  
    -  In the codespace terminal run `source gitlab/bootstrap/setup.sh`

## Labs for GitLab
Perform the following labs to test-drive Valet
- TBD

## Troubleshoot GH Valet extension
TBD

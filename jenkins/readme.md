# Valet labs for Jenkins

This lab bootstraps a Valet environment using GitHub Codespaces and enables you to spin up a Jenkins instance against which to run the Valet CI/CD migration tool.

- [Use this Repo as a template](#repo-template)
- [Use Valet with a codespace](#use-valet-with-a-codespace)
- [Prerequisites](#prerequisites)
- [Bootstrap Jenkins](#bootstrap-jenkins)

## Repo template

1. Verify you are in your own Repository created from the landing page [Valet Labs](https://github.com/valet-customers/labs).

## Prerequisites

1. Create a GitHub personal access token.
    - Navigate to your GitHub `Settings` - click your profile photo and click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the PAT somewhere safe and temporary.

## Use Valet with a codespace

1. Start the codespace
    - Click the `Code` with button down arrow above repository on the repository's landing page.
    - Click the `Codespaces` tab
    - Click `Create codespaces on main` to create the codespace. If you are in another branch then the `main` branch, the codespace will button will have the current branch specified.
    - Wait a couple minutes, then verify that the codespace starts up. Once it is fully booted up, the termininal should be present.
2. Verify Valet CLI is installed and working. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
    - Verify Valet CLI is installed and working
    - Run `gh valet version` in the Visual Studio Code terminal and verify the output looks like the below image. Note the valet version will be different than below as the latest version gets pulled down.
       - If `gh valet version` did not produce a similar image with a version please follow these instructions [Troubleshoot GH Valet extension](#troubleshoot-gh-valet-extension)

## Bootstrap Jenkins

 1. Run the Jenkins setup script.  This script will setup GitLab and ensure it is ready to use.  In general, this script should be run first if you are starting a new codespace or restarting an existing one.  

- Navigate to the terminal within your Codespace.
- Run `source jenkins/bootstrap/setupjenkins.sh` to kick off the creation of your Jenkins instance.
- After a couple seconds, a pop-up box should appear with a link to the forwarded URL for your Jenkins instance.
- You can also access the fowarded URL by going to the `Ports` tab in your terminal. Right click on the URL listed under the `Local Address` and clicking the `Open in Browser` tab.
- Once you have navigated to the url, the following default credentials have been assigned:

  - username: `admin`
  - password: `password`

7. Click the `Sign in` button and you should now see your new Jenkins instance with a few pre-populataed pipelines.

## Labs for Jenkins

Perform the following labs to test-drive Valet

- TBD

## Troubleshoot GH Valet extension

Manually Install the GitHub CLI Valet extension. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)

- Verify you are in the Visual Studio Code terminal
- Run this command to install the GitHub Valet extension
- `gh extension install github/gh-valet`
- Verify the result of the install is: `✓ Installed extension github/gh-valet`
- If you get a similiar error to the following, click the link to authorize the token
      ![linktolcickauth](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
  - Restart Codespace after clicking the link
- Verify Valet CLI is installed and working

## Troubleshooting Jenkins

1. Navigate to the Docker tab on your left hand side.
2. Under the `Containers` tab you should see a Docker container `jenkins:valet` listed with a green play button ▶
    - If you see the `jenkins:valet` container, but it has a red stopped symbol next to it ▢, right click on the container and click on `start`, the container should begin running again.
    - If the container does not start even after trying to manually start it, right click on the `jenkins:valet` container and click the `remove` button. Next continue by following all the #bootstrap-jenkins instructions again.

<img width="985" alt="Screen Shot 2022-08-09 at 3 06 46 PM" src="https://user-images.githubusercontent.com/19557880/183770210-c0386616-656e-4fe9-9324-b410ad62c406.png">

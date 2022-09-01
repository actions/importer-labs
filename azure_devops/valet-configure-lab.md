# Configure Valet to work with GitLab
In this lab, we will use the Valet `configure` command to set up the required information to communicate with Azure DevOps and GitHub. The `configure` command can be used for all of the supported providers, but in this lab we will be focusing on Azure DevOps.
- [Prerequisites](#prerequisites)
- [Configuring Valet](#configuring-valet)
- [Verify Valet Works](#verify-valet-works)
- [Next Lab](#next-lab)

## Prerequisites
1. Followed [steps](../azure_devops#readme) to set up your codespace environment.

## Configuring Valet
1. Create a GitHub personal access token (PAT). 
    - Navigate to your GitHub `Settings` - click your profile photo and then click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the token somewhere safe and temporary.
2. Skip this step if you still have the Azure DevOp personal access token created during step 1 in the lab setup [steps](../azure_devops#bootstrap-your-azure-devops-organization), if not create another and save to a save and temporary location.
3. Run Valet configure command.
   - In the codespace terminal run `gh valet configure`
   - Use the down arrow key to highlight `Azure DevOps`, press the spacebar to select, then hit enter to accept.
   - At the prompt enter your GitHub username and press enter.
   - At the GitHub Container Registry prompt enter the GitHub PAT generated in step 1 and press enter.
   - At the GitHub PAT prompt enter the GitHub PAT generated in step 1 and press enter.
   - At the GitHub url prompt enter the GitHub instance url or hit enter to accept the default.
   - At the Azure DevOps token prompt enter the access token from step 2 and press enter.
   - At the Azure DevOps url prompt enter your Azure DevOps url or hit enter to accept the default.
   - At the prompt enter your Azure Devops Organization name.
   - At the prompt enter your Azure Devops Project name.
4. If all went well you should see a similar output in your terminal and a new file (.env.local) should have been created in the root of the project. The .env.local file contains the tokens used during the configure command and should be keep secret. 

   ![configure-result](https://user-images.githubusercontent.com/18723510/187771230-27c97889-d98a-48f7-af01-c1a9f8df6423.png)

  
## Verify Valet Works
To verify Valet works we are going to run a `update`, `version` and `dry-run` command.  We will go further into details about the `dry-run` command in a later lab, but for now we want to get the latest version of Valet and confirm that Valet can perform a dry-run with no errors.

1. In the codespace terminal update Valet by running `gh valet update`
2. In the terminal you should see a confirmation that it logged into the GitHub Container Registry and pulled the latest version.
3. To verify Valet is updated and installed correctly run `gh valet version` and confirm the command outputs a similar response
  
   ![valet-version](https://user-images.githubusercontent.com/18723510/187771571-83c0ede3-0b5d-49d5-9cf8-9ff2774ef114.png)

4. Next, lets run the dry-run command in the codespaces terminal, to verify we can talk to Azure DevOps
    ```
    gh valet dry-run azure-devops pipeline -o tmp/configure_test --pipeline-id 7
    ```
5. In the terminal you should see the command was successful, if not it is a good time to practice the configure command again and make sure the access tokens values are correct and generated with the correct permissions.
  
   ![dry-run](https://user-images.githubusercontent.com/18723510/187773568-5b4ef731-958f-4e5a-8f50-ea4e8a9e75d4.png)


### Next Lab
[Audit Azure DevOps using the Valet audit command](../azure_devops/valet-audit-lab.md)


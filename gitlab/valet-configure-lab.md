# Configure Valet to work with GitLab using The `configure` command
In this lab, you will use Valet's `configure` command to set up the required secrets to communicate with the GitLab and GitHub instances.  The `configure` command can be used for all of the supported providers, but in this lab we will be focusing on GitLab.

- [Prerequisites](#prerequisites)
- [Configuring Valet](#configure-valet)
- [Test Valet](#test-valet)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.

## Configuring Valet
1. Run the setup script in the codespace terminal `source ./gitlab/bootstrap/setup.sh` and record the username and password for the next step.
2. Login to the GitLab instance to generate a personal access token:
   1. Click the `PORTS` tab in the codespace terminal window.
   2. In the `PORTS` tab find the row for port 80.
   3. Hover over the address under the `Local Address` column, and click the globe to open in browser
   4. Login to the GitLab server and following [instructions](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token) to generate a token that has `read_api` scope.
   5. Record token for a later step.
3. Create a GitHub personal access token (PAT). 
    - Navigate to your GitHub `Settings` - click your profile photo and then click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the token somewhere safe and temporary.
4. In the codespace terminal window click back to the `TERMINAL` tab and run `gh valet configure`.
5. Using the down arrow key to highlight `GitLab CI`, press the spacebar to select, then hit enter to accept.
6. Enter your GitHub Username and press enter.
7. At the GitHub Container Registry prompty enter the GitHub PAT generated in step 3 and press enter
8. At the GitHub PAT prompt enter the GitHub PAT generated in step 3 and press enter.
9. At the GitHub url prompt enter the GitHub instance url or hit enter to accept the default, if you are using github.com then the default is the right choice.
10. At the GitLab token prompt enter the GitLab access token from step 2 and press enter.
11. At the GitLab url prompt enter `http://localhost` and press enter.
12. If all went well you should see a similar output in your terminal 
![configure-result](https://user-images.githubusercontent.com/18723510/183984633-cc893ec2-bb60-4c88-812b-55f03adaef1c.png)


## Verify Valet Works
To verify Valet works we are going to run a `update` and `dry-run` command.  We will go further into details about the `dry-run` command in a later lab, but for now we want to get the latest version of Valet and confirm that Valet can perform a dry-run with no errors.

1. In the codespace terminal update Valet by running `gh valet update`
2. In the terminal you should see a confirmation that it logged into the GitHab Container Registry and pulled the latest version.
  ```
  Login Succeeded
  latest: Pulling from valet-customers/valet-cli
  Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
  Status: Image is up to date for ghcr.io/valet-customers/valet-cli:latest
  ghcr.io/valet-customers/valet-cli:latest
  ```
 3. Next, lets run the dry-run commmand in the codespaces terminal, to verify we can talk to GitLab
    ```
    gh valet dry-run gitlab --output-dir ./tmp/dry-run-lab --namespace valet --project basic-pipeline-example
    ```
 4. In the terminal you should see the command was successful, if not it is a good time to practice the configure command again and make sure the access tokens were generated with the correct premissions 
  ![configure-dry-run](https://user-images.githubusercontent.com/18723510/183989794-d51fa29d-b4c0-4074-8402-a55ffcea3a6b.png)

### Next Lab
Dry run the migration of an GitLab pipeline to GitHub Actions ADD_LINK_HERE

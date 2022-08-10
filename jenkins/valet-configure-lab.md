# Configure Valet to work with Jenkins

In this lab, you will use the Valet `configure` command to set up the required information to communicate with the Jenkins and GitHub instances. The `configure` command can be used for all of the supported providers, in this lab we will be focusing on Jenkins.

- [Prerequisites](#prerequisites)
- [Configuring Valet](#configuring-valet)
- [Verify Valet Works](#verify-valet-works)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed [steps](../Jenkins#readme) to set up your codespace environment and start your Jenkins instanace.

## Configuring Valet

1. Login to the Jenkins instance to generate a personal access token:
   1. Click the `PORTS` tab in the codespace terminal window.
   2. In the `PORTS` tab find the row for port 8080.
   3. Hover over the address under the `Local Address` column, and click the globe to "open in browser".
   4. Login to the Jenkins server and generate a Jenkins API token.
      - Click the `admin` button located within the top right menu.
      - Click on the `configure` gear located on the left hand panel.
      - Under the `API token` section, click `Add new Token`.
      - Add a defaualt name to your token, then click `Generate`.
      - Copy the token that was generated and record token for a later step.
2. Create a GitHub personal access token (PAT).
    - Navigate to your GitHub `Settings` - click your profile photo and then click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the token somewhere safe and temporary.
3. Run Valet configure commands
   - In the codespace terminal window click back to the `TERMINAL` tab.
   - Within the terminal, navigate into the Jenkins directory `cd valet`
   - Run `gh valet configure`
   - Use the down arrow key to highlight `Jenkins`, press the spacebar to select, then hit enter to accept.
   - At the prompt enter your GitHub Username and press enter.
   - At the GitHub Container Registry prompt enter the GitHub PAT generated in step 3 and press enter
   - At the GitHub PAT prompt enter the GitHub PAT generated in step 3 and press enter.
   - At the GitHub url prompt enter the GitHub instance url or hit enter to accept the default, if you are using github.com then the default is the right choice.
   - At the Jenkins token prompt enter the Jenkins access token from step 2 and press enter.
   - At the Jenkins url prompt enter `http://localhost:8080/` and press enter.
   - At the Personal access token to fetch source code in GitHub prompt, if any of your Jenkins pipelines have source code in a GitHub repository enter the GitHub PAT that would have acess to these files.
4. If all went well you should see a similar output in your terminal:
![configure-result](https://user-images.githubusercontent.com/18723510/183990474-d0b2559c-d2bf-40d9-ac43-19af53e45329.png)

## Verify Valet Works

To verify Valet works we are going to run a `update` and `dry-run` command.  We will go further into details about the `dry-run` command in a later lab, but for now we want to get the latest version of Valet and confirm that Valet can perform a dry-run with no errors.

1. In the codespace terminal update Valet by running `gh valet update`
2. In the terminal you should see a confirmation that it logged into the GitHub Container Registry and pulled the latest version.

  ```
  Login Succeeded
  latest: Pulling from valet-customers/valet-cli
  Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
  Status: Image is up to date for ghcr.io/valet-customers/valet-cli:latest
  ghcr.io/valet-customers/valet-cli:latest
  ```

 3. Next, lets run the dry-run command in the codespaces terminal, to verify we can talk to Jenkins

    ```
    gh valet dry-run jenkins --source-url https://localhost:8080/job/test_pipeline/ --output-dir ./tmp/dry-run-lab
    ```

 4. In the terminal you should see the command was successful, if not it is a good time to practice the configure command again and make sure the access tokens values are correct and were generated with the correct permissions.
  ![configure-dry-run](https://user-images.githubusercontent.com/18723510/183989794-d51fa29d-b4c0-4074-8402-a55ffcea3a6b.png)

### Next Lab

# TODO

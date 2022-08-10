# Configure GitLab using Valet `configure` command
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
   5. Record token for use in later steps.
3. In the codespace terminal run `gh valet configure`.
4. Using the down arrow key to highlight `GitLab CI`, press the spacebar to select, then hit enter to accept.
5. Enter the previously generated GitHub access token.
6. Enter the GitHub instance url or hit enter to accept the default, if you are using github.com
7. Enter the GitLab access token from step 2 and press enter.
8. Enter `http://localhost` for the GitLab instance url
9. If all went well you should see a similar output in your terminal 
   ADD_IMAGE_HERE

## Verify Valet Works
To verify Valet works we are going to run a `dry-run` command.  We will go further into details about the `dry-run` command in a later lab, but for now we just want to confirm that Valet runs with no errors.

### Next Lab
Dry run the migration of an GitLab pipeline to GitHub Actions ADD_LINK_HERE

# Migrate an Azure DevOps pipeline to GitHub Actions with a custom transformer
In this lab, you will create a custom plugin that transforms some of the existing migration mapping and replaces it with your own mapping. Then use the `migrate` subcommand to migrate the pipeline. The `migrate` subcommand can be used to convert a pipeline to its GitHub Actions equivalent and then create a pull request with the contents.

- [Prerequisites](#prerequisites)
- [Identify the Azure DevOps pipeline ID to use](#identify-the-azure-devops-pipeline-id-to-use)
- [Create a custom transformer](#create-a-custom-transformer)
- [View the pull request](#view-the-pull-request)

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)
3. Complete the [Valet audit lab](valet-audit-lab.md).
4. Complete the [Valet migrate lab](valet-migrate-lab.md).
5. Verify or add the following values to the `./valet/.env.local` file. All values were created [here](/labs/azure_devops#readme)
```
GITHUB_ACCESS_TOKEN=<GithHub PAT generated>
GITHUB_INSTANCE_URL=https://github.com/

AZURE_DEVOPS_PROJECT=<Project identified>
AZURE_DEVOPS_ORGANIZATION=<Org identified>
AZURE_DEVOPS_INSTANCE_URL=<DevOps instance>
AZURE_DEVOPS_ACCESS_TOKEN=<Token Generated>
```
### Example ###

![envlocal](https://user-images.githubusercontent.com/26442605/169069638-0bfa8f89-eaa9-423b-b2b7-447248e63e2b.png)

## Identify the Azure DevOps pipeline ID to use
You will need the `valet-mapper-example` Azure DevOps pipeline ID to perform the migration
1. Go to the `valet/ValetBootstrap/pipelines` folder
2. Open the `valet/ValetBootstrap/pipelines/valet-mapper-example.config.json` file
3. Look for the `web - href` link
4. At the end of the link is the pipeline ID. Copy or note the ID.

### Example
![configpipelineid](https://user-images.githubusercontent.com/26442605/161106098-3b9b05ec-ee5d-4b21-ab07-9f05f8cf1d98.png)

## Create a custom transformer

To create a transformer, you need to create a Ruby file that looks as follows:
``` ruby
transform "azuredevopstaskname" do |item|
   # your ruby code here that produces output
  end
```  

We start by creating a new folder called `plugin` under the `valet` folder in your repository. In there create a file called `DotNetCoreCLI.rb`.

Next change the function name to match the Azure DevOps task name `DotNetCoreCLI@2`.
The way you find this name is by clicking the **view yaml** button at a task in the pipeline:

This results in the following code:
``` ruby
transform "DotNetCoreCLI@2" do |item|
   # your ruby code here that produces output
  end
```  
The parameter item is a collection of items than contain the properties of the original task that was retrieved from Azure DevOps.
In this case we can see in the yaml that the properties that are set are `command` and `projects`.
   
Add the following code to the ruby file:
``` Ruby
transform "DotNetCoreCLI@2" do |item|
  projects = item["projects"]
  command = item['command']
  run_command = []
  
        if(projects.include?("$"))
          if(command.nil?)
            command = "build"
          end
           run_command << "shopt -s globstar; for f in ./**/*.csproj; do dotnet #{command} $f #{item['arguments'] } ; done"
        else
            run_command << "dotnet #{command} #{item['projects']} #{item['arguments'] }"
       end 
    {
      shell: "bash",
      run: run_command.join("\n")
    }
end
```
### Example
![mapper-ex1](https://user-images.githubusercontent.com/26442605/161116232-c3dab5ba-8ca5-4dd0-a659-b871646ab82f.png)

Run the `migrate` command with the transformer again and pass it the custom plugin. Look at the result and see if it results in a successful build. 

```
cd valet
gh valet migrate azure-devops pipeline --target-url https://github.com/GITHUB-ORG/GITHUB-REPO --pipeline-id PIPELINE-ID --custom-transformers plugin/DotNetCoreCLI.rb --output-dir migrate
```
Now, from the `./valet` folder in your repository, run `gh valet migrate` with the custom transformer to migrate the pipeline to GitHub Actions: 

### Example
![valet-cm-1](https://user-images.githubusercontent.com/26442605/169618556-7c79b34b-6d4c-48d5-98e5-7f8d771117a5.png)

## View the pull request
The migrate output will show you the pull request on GitHub. Note here that the checks on the pull request all passed!

### Example
![mapper-ex3](https://user-images.githubusercontent.com/26442605/161117488-93e38847-3034-4f04-a768-e74e16dba4ae.png)


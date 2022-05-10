# Migrate an Azure DevOps pipeline to GitHub Actions with a custom transformer
In this lab, you will create a custom plugin that transforms some of the existing migration mapping and replaces it with your own mapping.

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)
3. Complete the [Valet audit lab](valet-audit-lab.md).
4. Complete the [Valet migrate lab](valet-migrate-lab.md).

## Identify the Azure DevOps pipeline ID to use
You will need the `valet-mapper-example` Azure DevOps pipeline ID to perform the migration
1. Go to the `scripts/ValetBootstrap/pipelines` folder
2. Open the `scripts/ValetBootstrap/pipelines/valet-mapper-example.config.json` file
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

We start by changing the function name to match the Azure DevOps task name `DotNetCoreCLI@2`.
The way you find this name is by clicking the **view yaml** button at a task in the pipeline:

This results in the following code:
``` ruby
transform "DotNetCoreCLI@2" do |item|
   # your ruby code here that produces output
  end
```  
The parameter item is a collection of items than contain the properties of the original task that was retrieved from Azure DevOps.
In this case we can see in the yaml that the properties that are set are `command` and `projects`.

This is what you can expect to find when we would dump the information. To determine what is in the item being passed, you can do the following:
``` ruby
transform "DotNetCoreCLI@2" do |item|
   puts item
  end
```  
   
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
cd scripts
valet migrate azure-devops pipeline --target-url https://github.com/GITHUB-ORG/GITHUB-REPO --pipeline-id PIPELINE-ID --custom-transformers plugin/DotNetCoreCLI.rb
```
Now, from the `./scripts` folder in your repository, run `valet migrate` with the custom transformer to migrate the pipeline to GitHub Actions: 

### Example
![mapper-ex2](https://user-images.githubusercontent.com/26442605/161116637-15c01950-ede0-4992-876b-6a3fe5688723.png)

## View the pull request
The migrate output will show you the pull request on GitHub. Note here that the checks on the pull request all passed!

### Example
![mapper-ex3](https://user-images.githubusercontent.com/26442605/161117488-93e38847-3034-4f04-a768-e74e16dba4ae.png)


param ( 
        $project = "ValetBootstrap",
        $repoName = "ValetBootstrap",
        $codeFolder= "code,azure_devops/pipelines",
        $rootFolder= ".",
        $pipelinesRoot="azure_devops/pipelines",
        [String]$orgToUse = "..",
        [String]$userName=$(Throw "Azure DevOps Username required."),
        [String]$daPassword=$(Throw "Password required.")
  )
  
Write-Host "Start Valet Bootstrap"
Write-Host "Azure DevOps Organization to use $orgToUse"
Write-Host "Azure DevOps Project to use $project"
Write-Host "Repo Name $repoName"
Write-Host "Code Folders: $codeFolder"
Write-Host "Root Folders: $rootFolder"
Write-Host "Pipelines Folders: $pipelinesRoot"
Write-Host "Azure DevOps username to authenticate with $userName"
Write-Host "Azure DevOps PAT to authenticate with $daPassword"

function Get-BasicAuthCreds {
    param([string]$Username,[String]$Password)
    $AuthString = "{0}:{1}" -f $Username,$Password
    $AuthBytes  = [System.Text.Encoding]::Ascii.GetBytes($AuthString)
    return [Convert]::ToBase64String($AuthBytes)
}

#Get the creds to use in all GitHub API calls.
$BasicCreds = Get-BasicAuthCreds -Username "$userName" -Password $daPassword

##########################################################################
#CREATE THE AZURE DEVOPS PROJECT
$createtUrlToUse = [string]::Format("https://dev.azure.com/{0}/_apis/projects?api-version=6.0", $orgToUse)

$projectToCreate = @{
    "name"= "$project"
    "description"= "Project to be used for Valet Demos"
    "capabilities"= @{
      "versioncontrol"= @{
        "sourceControlType"= "Git"
      }
      "processTemplate"= @{
        "templateTypeId"= "6b724908-ef14-45cf-84f8-768b5384da45"
      }
    }
   }
   
    try{
        $projectResponse = Invoke-RestMethod -Method 'Post' -Uri $createtUrlToUse -Headers @{"Authorization"="Basic $BasicCreds"} -Body ($projectToCreate|ConvertTo-Json) -ContentType "application/json"
        $projectResponse | ConvertTo-Json

        Start-Sleep -s 5
        Write-Host "Yes! Project $project was created!"

    } Catch {
        Write-Host " "
        Write-Host "##########################################################################"
        Write-Host "ERROR during project creation: $project"
        Write-Host "The API call was: $createtUrlToUse"
        Write-Host " "

        if($_.ErrorDetails.Message) {
            Write-Host "See error message below:"
            Write-Host $_.ErrorDetails.Message
        } else {
            Write-Host $_
            Write-Host "It is likely that the AZURE_DEVOPS_ACCESS_TOKEN is not set correctly in the worflow OR does not have sufficent permissions"
        }
        Write-Host " "
        Write-Host "##########################################################################"
        throw "Exiting. The Project $project was NOT created in Azure DevOps"
    }

##########################################################################
# IMPORT THE REPO
Set-Location $rootFolder

[array]$folderArray = $codeFolder.Split(",")
    
$addTextFile = @{
    "refUpdates"= @(
      @{
        "name"= "refs/heads/main"
        "oldObjectId"= "0000000000000000000000000000000000000000"
      }
    )
    "commits"= @(
    @{
        "comment"= "Initial commit."
        "changes"= @(
          foreach ($folder in $folderArray)
        {
            $codeRootFolder = Join-Path -Path $rootFolder -ChildPath $folder
            Write-Host "codeRootFolder: $codeRootFolder"

            $itemPath = $folder.Substring($folder.lastIndexOf('/') + 1)
            Write-Host "itemPath: $itemPath"
            
         $codeFiles = (Get-ChildItem "$codeRootFolder"  -Recurse -Attributes !Directory)
          foreach ($codeFile in $codeFiles ) {
            $daFullName = $codeFile.FullName
            $codeBody = (Get-Content "$daFullName" -Raw)
            #Write-Host "codeBody: $codeBody"
            #Write-Host "folder: $folder"
            $relath = $daFullName | Resolve-Path -Relative
            #Write-Host "relath: $relath"
            $replaceSlash = $folder.Replace("/", "\")
            $repoPath = $relath.Substring($relath.lastIndexOf($replaceSlash) + $replaceSlash.Length)
            $wholeRepoPath = Join-Path -Path $itemPath -ChildPath $repoPath
            $wholeRepoPath = $wholeRepoPath.Replace("\", "/")
            #Write-Host "wholeRepoPath: $wholeRepoPath"
            #Write-Host "repoPath: $repoPath"
            @{
              "changeType"= "add" 
              "item"= @{
                "path"= "/$wholeRepoPath"
              }
              "newContent"= @{
                "content"= "$codeBody"
                "contentType"= "rawtext"
              }
            }
                    }
          }
        )
      }
    )
    }
  
try{
        $repoUrlToUse = [string]::Format("https://dev.azure.com/{0}/{2}/_apis/git/repositories/{1}/pushes?api-version=7.1-preview.2", $orgToUse, $repoName, $project)
        $pushResponse = Invoke-RestMethod -Method 'Post' -Uri $repoUrlToUse -Headers @{"Authorization"="Basic $BasicCreds"} -Body ($addTextFile|ConvertTo-Json -Depth 5) -ContentType "application/json"
        $repoIds = $pushResponse.repository.id
        Write-Host "Yes! Repo Was was created! The repoId is $repoIds"
} Catch {
    Write-Host " "
    Write-Host "##########################################################################"
    Write-Host "ERROR during Repo creation:"
    Write-Host "The API call was: $repoUrlToUse"
    Write-Host " "

    if($_.ErrorDetails.Message) {
        Write-Host "See error message below:"
        Write-Host $_.ErrorDetails.Message
    } else {
        Write-Host $_
    }
    Write-Host " "
    Write-Host "##########################################################################"
    throw "Exiting. The Repo was NOT created. It is likely the Project was created in Azure DevOps."
}

##########################################################################
##########################################################################
# Create YML Pipelines
$plUrlToUse = [string]::Format("https://dev.azure.com/{0}/{1}/_apis/pipelines?api-version=6.0-preview.1", $orgToUse, "$project") 

$files = Get-ChildItem ".\$pipelinesRoot\yml\"
foreach ($f in $files)
{
  $nameOfPl = $f.BaseName
  $fileName = $f.Name
  Write-Host "basename: $nameOfPl filename: $fileName"
  
  $pipelineCreateBody = @{
      "folder"= "pipelines"
      "name"= "$nameOfPl"
      "configuration"= @{
          "type"= "yaml"
          "path"= "/pipelines/yml/$fileName"
          "repository"= @{
              "id"= "$repoIds"
              "name"= "$repoName"
              "type"= "azureReposGit"
          }
      }
  }
  
  try{
        $repoResponse = Invoke-RestMethod -Method 'Post' -Uri $plUrlToUse -Headers @{"Authorization"="Basic $BasicCreds"} -Body ($pipelineCreateBody|ConvertTo-Json) -ContentType "application/json"
  } Catch {
        Write-Host " "
        Write-Host "##########################################################################"
        Write-Host "ERROR during Pipeline creation:"
        Write-Host "The API call was: $plUrlToUse"
        Write-Host " "

        if($_.ErrorDetails.Message) {
            Write-Host "See error message below:"
            Write-Host $_.ErrorDetails.Message
        } else {
            Write-Host $_
        }
        Write-Host " "
        Write-Host "The Pipeline $nameOfPl was NOT created."
        Write-Host "##########################################################################"
    }
}

##########################################################################
#CREATE CLASSIC PIPELINEs

$classicUrlToUse = [string]::Format("https://dev.azure.com/{0}/{1}/_apis/build/definitions?api-version=7.1-preview.7", $orgToUse, "$project") 

$files = Get-ChildItem ".\$pipelinesRoot\classic\"
foreach ($f in $files)
{
  $nameOfPl = $f.BaseName
  $fileName = $f.Name
  Write-Host "basename: $nameOfPl filename: $fileName"

  $pclassicreateBody = (Get-Content ./$pipelinesRoot/classic/$fileName).Replace("REPOTOREPLACE", "$repoName")

  try{
        Invoke-RestMethod -Method 'Post' -Uri $classicUrlToUse -Headers @{"Authorization"="Basic $BasicCreds"} -Body ($pclassicreateBody) -ContentType "application/json"
    } Catch {
        Write-Host " "
        Write-Host "##########################################################################"
        Write-Host "ERROR during Pipeline creation:"
        Write-Host "The API call was: $classicUrlToUse"
        Write-Host " "

        if($_.ErrorDetails.Message) {
            Write-Host "See error message below:"
            Write-Host $_.ErrorDetails.Message
        } else {
            Write-Host $_
        }
        Write-Host " "
        Write-Host "The Pipeline $nameOfPl was NOT created."
        Write-Host "##########################################################################"
    }
}
Write-Host "End Valet Bootstrap"

param ( 
        [String]$proj = "ValetBootstrapper",
        [String]$org = "microsoft-bootcamp",
        [String]$ghPAT = "dkalmintest",
        [String]$azdoPAT = "dkalmin@github.com"
      )

[String]$azdoProject = "AZURE_DEVOPS_PROJECT="
[String]$azdoOrg = "AZURE_DEVOPS_ORGANIZATION="
[String]$azdoInstance = "AZURE_DEVOPS_INSTANCE_URL="
[String]$ghAccess = "GITHUB_ACCESS_TOKEN="
[String]$azdoAccess = "AZURE_DEVOPS_ACCESS_TOKEN="

$updateEnvs = (Get-Content ./valet/.env.local)

$updateEnvs = $updateEnvs.Replace("$azdoProject", "AZURE_DEVOPS_PROJECT=$proj")
$updateEnvs = $updateEnvs.Replace("$azdoOrg", "AZURE_DEVOPS_ORGANIZATION=$org")
$updateEnvs = $updateEnvs.Replace("$azdoInstance", "AZURE_DEVOPS_INSTANCE_URL=https://dev.azure.com/$org")
$updateEnvs = $updateEnvs.Replace("$ghAccess", "GITHUB_ACCESS_TOKEN=$ghPAT")
$updateEnvs = $updateEnvs.Replace("$azdoAccess", "AZURE_DEVOPS_ACCESS_TOKEN=$azdoPAT")
Set-Content -Path ./valet/.env.local -Value $updateEnvs

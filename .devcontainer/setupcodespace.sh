#!/bin/bash
echo "Starting setupcodespace.sh"

azdoProject="AZURE_DEVOPS_PROJECT="
azdoOrg="AZURE_DEVOPS_ORGANIZATION="
azdoInstance="AZURE_DEVOPS_INSTANCE_URL="
ghAccess="GITHUB_ACCESS_TOKEN="
azdoAccess="AZURE_DEVOPS_ACCESS_TOKEN="
ghInstanceUrl="GITHUB_INSTANCE_URL="

cat valet/.env.local

if [ -z "$1" -o -z "$5" ]
then
     echo "Error: Docker Pull Valet not executing because GITHUB_USER and/or VALET_PASSWORD not set"
else
    docker login ghcr.io/valet-customers --username $5 --password $1
    docker pull ghcr.io/valet-customers/valet-cli:latest
    echo "Success: Docker Pull Valet completed"
  
fi

if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$6" ]
then
     value=`cat valet/.env.local.template`
     echo "$value" > valet/.env.local
     echo "Error: Set envars not set, valid values not passed in"
else
    azdoInstanceUrl="https://dev.azure.com/$3"

    value=`cat valet/.env.local.template`

    result="${value/$azdoProject/$azdoProject$2}" 
    result="${result/$azdoOrg/$azdoOrg$3}" 
    result="${result/$azdoInstance/$azdoInstance$azdoInstanceUrl}" 
    result="${result/$ghAccess/$ghAccess$1}" 
    result="${result/$azdoAccess/$azdoAccess$4}" 
    result="${result/$ghInstanceUrl/$ghInstanceUrl$6}" 

    echo "$result" > valet/.env.local
    echo "Success: set envars in valet/.env.local"

fi

echo "Finished setupcodespace.sh"

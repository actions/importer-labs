#!/bin/bash
echo "Starting setupcodespace.sh"

azdoProject="AZURE_DEVOPS_PROJECT="
azdoOrg="AZURE_DEVOPS_ORGANIZATION="
azdoInstance="AZURE_DEVOPS_INSTANCE_URL="
ghAccess="GITHUB_ACCESS_TOKEN="
azdoAccess="AZURE_DEVOPS_ACCESS_TOKEN="
ghInstanceUrl="GITHUB_INSTANCE_URL="

if [ -z "$1" -o -z "$5" ]
then
     echo "Error: Docker Pull Valet not executing because GITHUB_USER and/or VALET_PASSWORD not set"
else
    docker login ghcr.io/valet-customers --username $5 --password $1
    docker pull ghcr.io/valet-customers/valet-cli:latest
    echo "Success: Docker Pull Valet completed"
fi

value=`cat valet/.env.local.template`
echo "$value" > valet/.env.local
     
if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$6" ]
then
     echo "Error: Set envars not set, valid values not passed in. You will have to manually use the valet/.env.local folder"
fi

echo "Finished setupcodespace.sh"

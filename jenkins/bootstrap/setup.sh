#!/bin/bash

container_name="valet"
username="admin"
password="password"

echo "Building Jenkins instance!"

if [ "$(docker ps -a | grep jenkins:$container_name)" ]; then
  echo -e "Jenkins is running"
  docker container start jenkins
else
  echo -e "\nStarting a new Jenkins container"
  # Build jenkins image from docker compose file 
  docker build -t jenkins:$container_name -f $CODESPACE_VSCODE_FOLDER/jenkins/bootstrap/Dockerfile .

  # Build container
  docker run -d --name jenkins -p 8080:8080 --env JENKINS_ADMIN_ID=$username --env JENKINS_ADMIN_PASSWORD=$password jenkins:$container_name
fi

echo -e "\nWaiting for Jenkins to start..."
while ! curl -s http://localhost:8080/ > /dev/null; do
  printf "."
  sleep 5
done

echo -e '\nJenkins is up and running!'
echo -e "\nUsername: admin"
echo -e "\bPassword: password"

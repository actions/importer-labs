#!/usr/bin/env bash

container_name="jenkins"
username=$7
password=$8

echo "Building Jenkins instance!"

# Build jenkins image from docker compose file 
docker build -t jenkins:$container_name $(pwd)

# wait until docker image is ready
sleep 2

# Build container
docker run --name jenkins --rm -p 8080:8080 --env JENKINS_ADMIN_ID=$username --env JENKINS_ADMIN_PASSWORD=$password jenkins:$container_name

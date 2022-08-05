#!/usr/bin/env bash

container_name="valet"
username="admin"
password="password"

echo "Building Jenkins instance!"

# Build jenkins image from docker compose file 
docker build -t jenkins:$container_name .

# wait until docker image is ready
sleep 2

# Build container
docker run --name jenkins -p 8080:8080 --env JENKINS_ADMIN_ID=$username --env JENKINS_ADMIN_PASSWORD=$password jenkins:$container_name

#!/bin/bash

container_name="valet"
username="admin"
password="password"

echo "Building Jenkins instance!"

# Build jenkins image from docker compose file 
docker build -t jenkins:$container_name .

# Build container
docker run -d --name jenkins -p 8080:8080 --env JENKINS_ADMIN_ID=$username --env JENKINS_ADMIN_PASSWORD=$password jenkins:$container_name

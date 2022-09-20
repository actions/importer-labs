#!/usr/bin/env bash
container_name="gitlab"
tar_file_path="$CODESPACE_VSCODE_FOLDER/gitlab/bootstrap/gitlab.tar.gz"

if [ ! -d /srv/gitlab ]; then
  echo -e "Seeding GitLab data \U1F331"
  if [ ! -f $tar_file_path ]; then
    echo -e "GitLab data file not found at $tar_file_path.\nPlease verify this file has not been removed\nExiting..."
    return
  fi
  sudo tar -xzf $tar_file_path -C /srv
fi

echo -e "Checking for GitLab \U1F575"

if [ "$(docker ps -a | grep $container_name)" ]; then
  echo -e "GitLab is running \U1F603"
  docker start $container_name
else
  echo -e "Starting new GitLab container \U1F4E0"
  docker run --detach \
  --hostname 172.17.0.2  \
  --publish 80:80 \
  --name gitlab \
  --restart always \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  --shm-size 256m \
  gitlab/gitlab-ee:latest

  # updates file permissions to avoid git and server errors
  docker exec -it gitlab update-permissions &> /dev/null
fi

echo -e "Waiting for GitLab to be ready. This might take a while \U23F0"
until $(curl --output /dev/null --silent --head --fail http://localhost); do
  printf '.'
  sleep 5
done

echo -e '\nGitLab is up and running! \U1F680'
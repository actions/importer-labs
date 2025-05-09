#!/usr/bin/env bash

IS_LOCAL=false
ROOT=""
INSTALL_DIR=""

if [ -n "$CODESPACES" ]; then
  echo "Running in GitHub Codespaces"
  ROOT="$CODESPACE_VSCODE_FOLDER"
  INSTALL_DIR="/srv"
else
  echo "Running locally"
  ROOT="$(git rev-parse --show-toplevel)"
  INSTALL_DIR="/tmp/srv"
  IS_LOCAL=true
fi

container_name="gitlab"
tar_file_path="$ROOT/gitlab/bootstrap/gitlab.tar.gz"

if [ ! -d "$INSTALL_DIR/gitlab" ]; then
  echo -e "Seeding GitLab data \U1F331"
  if [ ! -f "$tar_file_path" ]; then
    echo -e "GitLab data file not found at $tar_file_path.\nPlease verify this file has not been removed\nExiting..."
    return
  fi

  if [ "$IS_LOCAL" = true ]; then
    mkdir -p "$INSTALL_DIR/gitlab"
    tar -xzf "$tar_file_path" -C "$INSTALL_DIR"
  else
    sudo tar -xzf "$tar_file_path" -C "$INSTALL_DIR"
  fi
fi

echo -e "Checking for GitLab \U1F575"

if [ "$(docker ps -a | grep $container_name)" ]; then
  echo -e "GitLab is running \U1F603"
  docker start $container_name
else
  echo -e "Starting new GitLab container \U1F4E0"
  docker run --detach \
    --hostname 172.17.0.2 \
    --publish 80:80 \
    --name gitlab \
    --restart always \
    --volume "$INSTALL_DIR"/gitlab/config:/etc/gitlab \
    --volume "$INSTALL_DIR"/gitlab/logs:/var/log/gitlab \
    --volume "$INSTALL_DIR"/gitlab/data:/var/opt/gitlab \
    --shm-size 256m \
    gitlab/gitlab-ee:15.5.6-ee.0

  # updates file permissions to avoid git and server errors
  docker exec -it gitlab update-permissions &>/dev/null
fi

echo -e "Waiting for GitLab to be ready. This might take a while \U23F0"
until $(curl --output /dev/null --silent --head --fail http://localhost); do
  printf '.'
  sleep 5
done

echo -e '\nGitLab is up and running! \U1F680'

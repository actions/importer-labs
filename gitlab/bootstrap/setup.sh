#!/usr/bin/env bash
container_name="gitlab"

if [ ! -d /srv/data ]; then
  echo "Extracting GitLab data"
  sudo tar -xzf gitlab/bootstrap/gitlab.tar.gz -C /srv
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

# allow valet to talk to GitLab by removing network isolation between containers
export DOCKER_ARGS="--network=host"
`grep -q "export DOCKER_ARGS=" ~/.bashrc || echo 'export DOCKER_ARGS="--network=host"' >> ~/.bashrc`

echo -e "\U23F0 Waiting for GitLab to be ready. This might take a while..."
until $(curl --output /dev/null --silent --head --fail http://localhost); do
  printf '.'
  sleep 5
done

echo -e '\nGitLab is up and running! \U1F680'
echo "Username: root"
docker exec -it $container_name grep 'Password:' /etc/gitlab/initial_root_password
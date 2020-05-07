#!/bin/bash

docker build -t jrgriffiniii/dspace-docker-base .
docker run \
  -it \
  --name dspace \
  --mount src="$(pwd)/ansible",target=/ansible,type=bind \
  --mount src="$(pwd)/docker/usr/local/src",target=/usr/local/src,type=bind \
  --mount src="$(pwd)/docker/dspace",target=/dspace,type=bind \
  -p 8888:8080 \
  jrgriffiniii/dspace-docker-base
docker exec -it dspace ansible-playbook -vvv /ansible/playbooks/docker.yml

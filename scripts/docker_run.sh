#!/bin/bash

docker run \
  -it \
  --name dspace \
  --mount src="$(pwd)/guest",target=/host,type=bind \
  --mount src="$(pwd)/guest/opt",target=/opt,type=bind \
  --mount src="$(pwd)/guest/var/opt",target=/var/opt,type=bind \
  -p 8888:8080 \
  jrgriffiniii/dspace-docker-base

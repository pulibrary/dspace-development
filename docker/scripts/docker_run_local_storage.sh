#!/bin/bash

docker run \
  -it \
  --name dspace \
  --mount src="$(pwd)/ansible",target=/ansible,type=bind \
  --mount src="$(pwd)/docker/usr/local/src",target=/usr/local/src,type=bind \
  -p 8888:8080 \
  jrgriffiniii/dspace-docker-base

#!/bin/bash

docker run \
  -it \
  --name dspace \
  --mount src="$(pwd)/ansible",target=/ansible,type=bind \
  -p 8888:8080 \
  pulibrary/dspace-docker-base

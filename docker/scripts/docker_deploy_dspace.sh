#!/bin/bash

docker exec \
  -it \
  --workdir /usr/local/src/dspace-5.3-src-release/dspace/target/dspace-installer \
  dspace ant update_webapps
docker exec -it dspace service tomcat8 stop
docker exec -it dspace service tomcat8 start

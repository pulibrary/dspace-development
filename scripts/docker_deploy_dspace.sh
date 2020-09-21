#!/bin/bash

docker exec \
  -it \
  --workdir /opt/dspace-5.5-src-release/dspace/target/dspace-installer \
  dspace ant update_webapps
docker exec -it dspace service tomcat8 stop
docker exec -it dspace service tomcat8 start

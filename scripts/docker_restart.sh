#!/bin/bash

docker restart dspace
docker exec -it dspace bash -l service postgresql start
docker exec -it dspace bash -l service tomcat8 restart

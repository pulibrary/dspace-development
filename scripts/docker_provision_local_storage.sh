#!/bin/bash

docker exec -it dspace ansible-playbook -e 'install_dspace=false' -vvv /ansible/playbooks/docker.yml

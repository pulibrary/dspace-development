#!/bin/bash

docker exec -it dspace ansible-playbook -e 'install_dspace=false' -vvv /opt/ansible/playbooks/docker.yml

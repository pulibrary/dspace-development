#!/bin/bash

docker exec -it dspace ansible-playbook -vvv /opt/ansible/playbooks/docker.yml

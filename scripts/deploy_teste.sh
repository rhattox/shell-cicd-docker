#!/bin/bash

sudo unlink /opt/docker/apps/php_recybem_bndes
sudo rm -rf /opt/docker/stacks/php_recybem_bndes-0.0.1-SNAPSHOT001/

./first_deploy.sh php_recybem_bndes https://github.com/bcovies/docker_deployment_php_recybem_bndes.git 0.0.1-SNAPSHOT001

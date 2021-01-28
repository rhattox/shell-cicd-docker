#!/bin/bash

CAT_STRING=$(echo $(cat $(pwd)/.env | grep MAIN_FOLDER_DEPLOY_APP))
MAIN_FOLDER_DEPLOY_APP=(${CAT_STRING//=/ })
echo ${MAIN_FOLDER_DEPLOY_APP[1]}
#env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml teste


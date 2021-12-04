#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
APP_NAME=$3
DOCKER_APP_FULL_PATH=$4

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT START  #####"
    echo -e "############################"
}

start_stack() {
    cd $DOCKER_APP_FULL_PATH
    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml $APP_NAME
}

entry_screen

start_stack

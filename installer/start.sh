#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
# all services variables
APP_NAME=$2
DOCKER_APP_FULL_PATH=$3

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT START  #####"
    echo -e "############################"
}

start_stack() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
    cd $DOCKER_APP_FULL_PATH
    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml $APP_NAME
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}

entry_screen

start_stack

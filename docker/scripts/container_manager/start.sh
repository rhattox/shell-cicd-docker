#!/bin/bash

APP_NAME=$1
DOCKER_APP_FULL_PATH=$2

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT START  #####"
    echo -e "############################"
}

start_stack() {
    cd $DOCKER_APP_FULL_PATH
    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml $APP_NAME
}

init(){
    entry_screen
    start_stack
}

init


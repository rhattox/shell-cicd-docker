#!/bin/bash

APP_NAME=$1
DOCKER_APP_FULL_PATH=$2

entry_screen() {
    echo "############################"
    echo "######  SCRIPT START  #####"
    echo "############################"
    sleep 1
}

start_stack() {
    echo "------------------------------------------------------------"
    cd $DOCKER_APP_FULL_PATH
    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml $APP_NAME
    echo "------------------------------------------------------------"
}

init(){
    entry_screen
    start_stack
}

init


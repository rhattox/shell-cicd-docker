#!/bin/bash

entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $middle_of_screen
    echo -e "############################"
    tput cup 4 $middle_of_screen
    echo -e "######  SCRIPT STATUS  #####"
    tput cup 5 $middle_of_screen
    echo -e "############################"
}

load_env() {
    source ./.env
    APP_NAME=$APP_NAME
}

start_stack() {
    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml $APP_NAME
}

entry_screen
load_env
start_stack
#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
CMD=$3
APP_NAME=$4

entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "############################"
    tput cup 4 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "######  STOP SCRIPT    #####"
    tput cup 5 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "############################"
}

load_env() {
    source ./.env
    APP_NAME=$APP_NAME
}

stop_stack() {
    docker stack rm $APP_NAME
}

entry_screen
load_env
stop_stack

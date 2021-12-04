#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
APP_NAME=$3

entry_screen() {
    echo -e "############################"
    echo -e "######  STOP SCRIPT    #####"
    echo -e "############################"
}

stop_stack() {
    docker stack rm $APP_NAME
}

entry_screen
stop_stack

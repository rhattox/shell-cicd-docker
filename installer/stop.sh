#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
# all services variables
APP_NAME=$2

entry_screen() {
    echo -e "############################"
    echo -e "######  STOP SCRIPT    #####"
    echo -e "############################"
}

stop_stack() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
    docker stack rm $APP_NAME
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}

entry_screen
stop_stack

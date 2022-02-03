#!/bin/bash

APP_NAME=$1

entry_screen() {
    echo -e "############################"
    echo -e "######  STOP SCRIPT    #####"
    echo -e "############################"
}

stop_stack() {
    echo
    docker stack rm $APP_NAME
    echo
}

entry_screen
stop_stack

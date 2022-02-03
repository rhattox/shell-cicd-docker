#!/bin/bash

APP_NAME=$1

entry_screen() {
    echo -e "############################"
    echo -e "######  STOP SCRIPT    #####"
    echo -e "############################"
}

stop_stack() {
    docker stack rm $APP_NAME
}

init(){
    entry_screen
    stop_stack
}

init
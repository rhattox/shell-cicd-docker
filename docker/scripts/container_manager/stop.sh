#!/bin/bash

APP_NAME=$1

entry_screen() {
    echo  "############################"
    echo  "######  STOP SCRIPT    #####"
    echo  "############################"
    sleep 1
}

stop_stack() {
    echo "------------------------------------------------------------"
    docker stack rm $APP_NAME
    echo "------------------------------------------------------------"
}

init(){
    entry_screen
    stop_stack
}

init
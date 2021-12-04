#!/bin/bash
# basic variables
SCRIPT_COLLUMNS=$1
# all services variables
APP_NAME=$2

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT  LOGS   #####"
    echo -e "############################"
}
nodes_screen() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\tStack Name ---> $APP_NAME"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}
stack_screen() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    docker node ls --format "{{.Hostname}}" | while read ENTRY_NODE; do
        docker -H $ENTRY_NODE ps -q | while read CONTAINER_ID; do
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
            echo "DOCKER NODE: $ENTRY_NODE"
            echo "Container ID: $CONTAINER_ID"
            echo "LOGS:"
            docker -H $ENTRY_NODE logs $CONTAINER_ID
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
            echo
        done
    done
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}

entry_screen
nodes_screen
stack_screen

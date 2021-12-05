#!/bin/bash

SCRIPT_COLLUMNS=$1
APP_NAME=$2

stack_screen() {
    docker node ls --format "{{.Hostname}}" | while read ENTRY_NODE; do
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        echo "DOCKER NODE: $ENTRY_NODE"
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        docker -H $ENTRY_NODE ps -q | while read CONTAINER_ID; do

            echo "Container ID: $CONTAINER_ID"
            echo "LOGS:"
            docker -H $ENTRY_NODE logs $CONTAINER_ID
        done
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done

    done
}

# entry_screen
# nodes_screen
stack_screen

#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
APP_NAME=$3

entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "############################"
    tput cup 4 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "######  SCRIPT  LOGS   #####"
    tput cup 5 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "############################"
}
nodes_screen() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\tStack Name ---> $APP_NAME"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}
stack_screen() {
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 13 $SCRIPT_MIDDLE_OF_SCREEN
    tput setaf 3
    # Set a foreground colour using ANSI escape
    tput sgr0
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    docker node ls --format "{{.Hostname}}" | while read ENTRY_NODE; do
        docker -H $ENTRY_NODE ps -q | while read CONTAINER_ID; do
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
            echo "DOCKER NODE: $ENTRY_NODE"
            echo "Container ID: $CONTAINER_ID"
            echo "LOGS:"
            docker -H $ENTRY_NODE logs $CONTAINER_ID
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        done
    done
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}

# nodes_screen() {
#     for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
#     docker node ls -f "role=worker" --format "{{.Hostname}}" | while read entry_node; do
#         docker -H $entry_node ps -q | while read containers_id; do
#             for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
#             echo "DOCKER NODE: $entry_node"
#             echo "Container ID: $containers_id"
#             echo "LOGS:"
#             docker -H $entry_node logs $containers_id
#             for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
#         done
#     done
#     for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
# }
# stack_screen() {
#     # Move cursor to screen location X,Y (top left is 0,0)
#     # tput cup 13 $middle_of_screen
#     # tput setaf 3
#     echo -e "\tStack Name ---> $APP_NAME"
#     # Set a foreground colour using ANSI escape
#     # tput sgr0
# }
load_env
entry_screen
nodes_screen
stack_screen

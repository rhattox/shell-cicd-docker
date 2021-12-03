#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
CMD=$3
APP_NAME=$4

load_env() {
    source ./.env
    APP_NAME=$APP_NAME
}
entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "############################"
    tput cup 4 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "######  SCRIPT STATUS  #####"
    tput cup 5 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "############################"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done

}
nodes_screen() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
    docker node ls -f "role=worker"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}
stack_screen() {
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 13 $SCRIPT_MIDDLE_OF_SCREEN
    tput setaf 3
    echo -e "\tStack Name ---> $APP_NAME"
    # Set a foreground colour using ANSI escape
    tput sgr0
    docker node ls -f "role=worker" --format "{{.Hostname}}" | while read entry_node; do
        output=$(DOCKER_HOST=${entry_node} docker ps -a --no-trunc -f name=$APP_NAME | wc -l)
        if [ $output != 1 ]; then
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
            echo "Node Name: ${entry_node}"
            #for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
            DOCKER_HOST=${entry_node} docker ps -a --format "$(tput setaf 4)\nID:\t{{.ID}}\nImage:\t{{.Image}}\nName:\t{{.Names}}\nState:\t{{.State}}\nPorts:\t{{.Ports}}\nMount:\t{{.Mounts}}\nRunning:\t{{.RunningFor}}$(tput sgr0)" --no-trunc -f name=$APP_NAME
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
        fi
    done
}
load_env
entry_screen
nodes_screen
stack_screen

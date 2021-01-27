#!/bin/bash

#GLOBAL COLS
cols=$(tput cols)
middle_of_screen=$(expr $cols / 3)

MAIN_APP_STACK=$1

entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $middle_of_screen
    echo -e "############################"
    tput cup 4 $middle_of_screen
    echo -e "######  SCRIPT STATUS  #####"
    tput cup 5 $middle_of_screen
    echo -e "############################"
}
nodes_screen() {
    for ((i = 0; i < cols; i++)); do printf "="; done
    echo
    docker node ls -f "role=worker"
    for ((i = 0; i < cols; i++)); do printf "="; done
    echo
}

stack_screen() {
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 13 $middle_of_screen
    tput setaf 3
    echo -e "\tStack Name ---> $MAIN_APP_STACK"
    # Set a foreground colour using ANSI escape
    tput sgr0
    docker node ls -f "role=worker" --format "{{.Hostname}}" | while read entry_node; do
        output=$(DOCKER_HOST=${entry_node} docker ps -a --no-trunc -f name=$MAIN_APP_STACK | wc -l)
        if [ $output != 1 ]; then
            for ((i = 0; i < cols; i++)); do printf "+"; done
            echo "Node Name: ${entry_node}"
            #for ((i = 0; i < cols; i++)); do printf "+"; done
            DOCKER_HOST=${entry_node} docker ps -a --format "$(tput setaf 4)\nID:\t{{.ID}}\nImage:\t{{.Image}}\nName:\t{{.Names}}\nState:\t{{.State}}\nPorts:\t{{.Ports}}\nMount:\t{{.Mounts}}\nRunning:\t{{.RunningFor}}$(tput sgr0)" --no-trunc -f name=$MAIN_APP_STACK
            for ((i = 0; i < cols; i++)); do printf "+"; done
        fi
    done
}

entry_screen
nodes_screen
stack_screen

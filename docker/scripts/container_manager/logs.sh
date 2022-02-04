#!/bin/bash

APP_NAME=$1

source /configs/tput.sh --source-only

entry_screen() {
    clear
    echo "############################"
    echo "######  LOGS SCRIPT    #####"
    echo "############################"
    sleep 1
}

nodes_screen() {
    echo "------------------------------------------------------------"
    docker node ls
    echo "------------------------------------------------------------"
    set_yellow
    echo "Stack Name ---> $APP_NAME"
    clean_tput
    echo "------------------------------------------------------------"
}

stack_screen() {
    arr_nodes=($(docker node ls --format "{{.Hostname}}"))
    arr_ready=($(docker node ls --format "{{.Status}}"))
    number_nodes=${#arr_nodes[@]}

    for ((i_for_nodes = 0; i_for_nodes < $number_nodes; i_for_nodes++)); do
        for x in "${arr_ready[$i_for_nodes]}"; do
            if [[ ! "$x" == "Down" ]]; then
                set_blue
                echo "Node: ${arr_nodes[$i_for_nodes]}"
                clean_tput
                echo "------------------------------------------------------------"
                docker -H ${arr_nodes[$i_for_nodes]} ps -q --format "{{.ID}}" --no-trunc -f name=$APP_NAME | while read CONTAINER_ID; do
                    set_green
                    echo "Container ID: $CONTAINER_ID"
                    clean_tput
                    echo "------------------------------------------------------------"
                    set_magenta
                    set_blink
                    echo -e "LOGS OUTPUT:\n"
                    clean_tput
                    docker -H ${arr_nodes[$i_for_nodes]} logs $CONTAINER_ID
                    # sleep 2
                    echo "------------------------------------------------------------"
                done
            fi
        done
    done
}

init(){
    entry_screen
    nodes_screen
    stack_screen
}

init
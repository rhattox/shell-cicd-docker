#!/bin/bash

APP_NAME=$1

entry_screen() {
    echo "############################"
    echo "######  LOGS SCRIPT    #####"
    echo "############################"
    sleep 1
}

nodes_screen() {
    echo "------------------------------------------------------------"
    docker node ls
    echo "------------------------------------------------------------"
    echo "Stack Name ---> $APP_NAME"
    echo "------------------------------------------------------------"
}

stack_screen() {
    arr_nodes=($(docker node ls --format "{{.Hostname}}"))
    arr_ready=($(docker node ls --format "{{.Status}}"))
    number_nodes=${#arr_nodes[@]}

    for ((i_for_nodes = 0; i_for_nodes < $number_nodes; i_for_nodes++)); do
        for x in "${arr_ready[$i_for_nodes]}"; do
            if [[ ! "$x" == "Down" ]]; then
                echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                tput setaf 2
                echo "------------------------------------------------------------"
                echo "Node: ${arr_nodes[$i_for_nodes]}"
                echo "------------------------------------------------------------"
                tput sgr0
                docker -H ${arr_nodes[$i_for_nodes]} ps -q --format "{{.ID}}" --no-trunc -f name=$APP_NAME | while read CONTAINER_ID; do
                    tput setaf 3
                    echo "Container ID: $CONTAINER_ID"
                    echo "------------------------------------------------------------"
                    tput sgr0
                    echo -e "LOGS OUTPUT:\n"
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
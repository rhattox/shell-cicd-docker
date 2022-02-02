#!/bin/bash

SCRIPT_COLLUMNS=$1
APP_NAME=$2
entry_screen() {
    echo -e "############################"
    echo -e "######  LOGS SCRIPT    #####"
    echo -e "############################"
}
nodes_screen() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
    docker node ls
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\tStack Name ---> $APP_NAME"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done

    echo
}
stack_screen() {

    arr_nodes=($(docker node ls --format "{{.Hostname}}"))
    arr_ready=($(docker node ls --format "{{.Status}}"))

    number_nodes=${#arr_nodes[@]}

    for ((i_for_nodes = 0; i_for_nodes < $number_nodes; i_for_nodes++)); do
        for x in "${arr_ready[$i_for_nodes]}"; do
            if [[ ! "$x" == "Down" ]]; then
                tput setaf 2
                for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "-"; done
                echo -e "Node: ${arr_nodes[$i_for_nodes]}"
                for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "-"; done
                tput sgr0
                docker -H ${arr_nodes[$i_for_nodes]} ps -q --format "{{.ID}}" --no-trunc -f name=$APP_NAME | while read CONTAINER_ID; do

                    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
                    tput setaf 3
                    echo -e "\nContainer ID: $CONTAINER_ID"
                    tput sgr0
                    echo -e "LOGS OUTPUT:"
                    docker -H ${arr_nodes[$i_for_nodes]} logs $CONTAINER_ID
                    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
                    # sleep 2
                done
            fi

        done
    done
}
entry_screen
nodes_screen
stack_screen

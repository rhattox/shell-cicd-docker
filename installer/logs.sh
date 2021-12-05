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

    for ((i = 0; i < $number_nodes; i++)); do
        for x in "${arr_ready[$i]}"; do

            if [[ ! "$x" == "Down" ]]; then
                echo -e "Node: ${arr_nodes[$i]}"

                docker -H ${arr_nodes[$i]} ps -q | while read CONTAINER_ID; do
                    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done

                    echo "Container ID: $CONTAINER_ID"

                    echo "LOGS:"
                    TESTE_COMANDO=$(docker -H ${arr_nodes[$i]} logs $CONTAINER_ID)

                    echo "$TESTE_COMANDO"

                    # sleep 2
                done
            fi

        done
    done
}
entry_screen
nodes_screen
stack_screen

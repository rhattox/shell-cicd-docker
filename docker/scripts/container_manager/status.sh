#!/bin/bash

# all services variables
APP_NAME=$1

source /configs/tput.sh --source-only

entry_screen() {
    clear
    echo "############################"
    echo "######  SCRIPT STATUS  #####"
    echo "############################"
    sleep 1
}
nodes_screen() {
    echo "------------------------------------------------------------"
    docker node ls
    echo "------------------------------------------------------------"
    set_yellow
    echo "stack Name ---> $APP_NAME"
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
                set_green
                echo "Containers:"
                clean_tput
                OUTPUT_LINES=$(DOCKER_HOST=${arr_nodes[$i_for_nodes]} docker ps -a --no-trunc -f name=$APP_NAME | wc -l)
                if [[ $OUTPUT_LINES != 1 ]]; then
                    DOCKER_HOST=${arr_nodes[$i_for_nodes]} docker ps --format "Image:\t{{.Image}}\nID:\t{{.ID}}\nName:\t{{.Names}}\nStatus:\t{{.Status}}\nPorts:\t{{.Ports}}\n$(set_blink; set_yellow)State:\t{{.State}}$(clean_tput)\nNetworks:\t{{.Networks}}\nMounts:\t{{.Mounts}}\nLabels:\t{{.Labels}}\nSize:\t{{.Size}}\nRunningFor:\t{{.RunningFor}}\nCreatedAt:\t{{.CreatedAt}}\nCommand:\t{{.Command}}\nMount:\t{{.Mounts}}\nRunning:\t{{.RunningFor}}\n" --no-trunc -f name=$APP_NAME
                fi
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
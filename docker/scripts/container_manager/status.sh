#!/bin/bash

# all services variables
APP_NAME=$1

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT STATUS  #####"
    echo -e "############################"
}
nodes_screen() {
    echo
    docker node ls
    echo -e "\tStack Name ---> $APP_NAME"

    echo
}

stack_screen() {

    arr_nodes=($(docker node ls --format "{{.Hostname}}"))
    arr_ready=($(docker node ls --format "{{.Status}}"))
    number_nodes=${#arr_nodes[@]}

    for ((i_for_nodes = 0; i_for_nodes < $number_nodes; i_for_nodes++)); do
        for x in "${arr_ready[$i_for_nodes]}"; do
            if [[ ! "$x" == "Down" ]]; then
                echo -e "Node: ${arr_nodes[$i_for_nodes]}"
                OUTPUT_LINES=$(DOCKER_HOST=${arr_nodes[$i_for_nodes]} docker ps -a --no-trunc -f name=$APP_NAME | wc -l)
                if [[ $OUTPUT_LINES != 1 ]]; then
                    DOCKER_HOST=${arr_nodes[$i_for_nodes]} docker ps --format "$(tput setaf 2)\nImage:\t{{.Image}}\nID:\t{{.ID}}\nName:\t{{.Names}}\nStatus:\t{{.Status}}\nPorts:\t{{.Ports}}\nState:\t{{.State}}\nNetworks:\t{{.Networks}}\nMounts:\t{{.Mounts}}\nLabels:\t{{.Labels}}\nSize:\t{{.Size}}\nRunningFor:\t{{.RunningFor}}\nCreatedAt:\t{{.CreatedAt}}\nCommand:\t{{.Command}}\nMount:\t{{.Mounts}}\nRunning:\t{{.RunningFor}}\n\n$(tput sgr0)" --no-trunc -f name=$APP_NAME
                fi
            fi
        done
    done

}

entry_screen
nodes_screen
stack_screen

#!/bin/bash

APP_NAME=${1}
DOCKER_APP_FULL_PATH=${2}

entry_screen() {
    clear
    echo -e "##############################"
    echo -e "######  DESTROY SCRIPT    ####"
    echo -e "##############################"
    sleep 1
}

load_environment_variables(){
    source /configs/environment.properties
    source /configs/shell_cicd_docker.properties
    source /configs/tput.sh --source-only
}


cat_stack_volumes(){
    
    cd ${DOCKER_APP_FULL_PATH}

    STACK_VOLUMES=$(docker volume ls | grep ${APP_NAME} | sed 's/\blocal\b//g')
    STACK_VOLUMES_ARRAY=(${STACK_VOLUMES})
    
    ARRAY_NUMBER=${#STACK_VOLUMES_ARRAY[@]}
    if [[ ${ARRAY_NUMBER} == 0 ]]; then
        set_red
        set_blink
        echo "[$(basename "$0")] ERROR: No volumes to remove for ${APP_NAME}!!"
        clean_tput
    else
        for ((i = 0; i < ${ARRAY_NUMBER}; i++)); do
            for x in "${ARRAY_NUMBER[${i}]}"; do
                set_green
                docker volume rm -f ${STACK_VOLUMES_ARRAY[${i}]}
                clean_tput
            done
        done
    fi
}

init(){
    entry_screen
    load_environment_variables
    cat_stack_volumes
}

init
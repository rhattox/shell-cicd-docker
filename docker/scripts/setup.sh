#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
HOME_PATH=/installer
LOCAL_CONFIG_FILE=$HOME_PATH/shell_cicd_docker.properties
LOCAL_SCRIPT_LOGS=$HOME_PATH/logs.sh
LOCAL_SCRIPT_START=$HOME_PATH/start.sh
LOCAL_SCRIPT_STATUS=$HOME_PATH/status.sh
LOCAL_SCRIPT_STOP=$HOME_PATH/stop.sh
LOCAL_SCRIPT_FIRST_DEPLOY=$HOME_PATH/first_deploy.sh

source $LOCAL_CONFIG_FILE

init() {
    if [ -f $LOCAL_CONFIG_FILE ]; then
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        echo -e "Local shell_cicd_docker.properties do exists... OK"
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        check_local_script_folder
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        check_docker_base_dirs
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        check_permissions_dirs
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    else
        echo -e "Local shell_cicd_docker.properties do NOT exists!!"
        exit 1
    fi
}

check_local_script_folder() {
    if [ ! -f $LOCAL_SCRIPT_LOGS ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_LOGS do NOT exists!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_LOGS... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_START ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_START do NOT exists!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_START... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_STATUS ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_STATUS do NOT exists!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_STATUS... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_STOP ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_STOP do NOT exists!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_STOP... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_FIRST_DEPLOY ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_FIRST_DEPLOY do NOT exists!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_FIRST_DEPLOY... OK"
    fi

}

check_docker_base_dirs() {
    if [ ! -d $DOCKER_VOLUMES_DATA ]; then
        echo -e "Missing folder $DOCKER_VOLUMES_DATA"
        exit 1
    fi

    if [ ! -d $DOCKER_VOLUMES_CONFIGS ]; then
        echo -e "Missing folder $DOCKER_VOLUMES_CONFIGS"
        exit 1
    fi

    if [ ! -d $DOCKER_VOLUMES_LOGS ]; then
        echo -e "Missing folder $DOCKER_VOLUMES_LOGS"
        exit 1
    fi

    if [ ! -d $DOCKER_STACKS ]; then
        echo -e "Missing folder $DOCKER_VOLUMES_STACKS"
        exit 1
    fi

    if [ ! -d $DOCKER_APPS ]; then
        echo -e "Missing folder $DOCKER_VOLUMES_APPS"
        exit 1
    fi
}

check_permissions_dirs() {
    if [[ $(stat -c "%a" "$DOCKER_ROOT") == "750" ]]; then
        echo "DIR right permissions"
    else
        chown -R 750 $DOCKER_ROOT
        echo "Defined new permissions"
    fi

    if [[ $(stat -c "%u" "$DOCKER_ROOT") == "root" && $(stat -c "%G" "$DOCKER_ROOT") == "docker" ]]; then
        echo "DIR right permissions"
    else
        chown -R root:docker $DOCKER_ROOT
        echo "Defined new permissions"
    fi
}

init

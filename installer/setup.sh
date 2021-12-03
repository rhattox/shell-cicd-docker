#!/bin/bash

HOME_PATH=~/shell_cicd_docker
HOME_PATH_SCRIPTS=$HOME_PATH/scripts
HOME_PATH_FILE=$HOME_PATH/shell_cicd_docker.properties
LOCAL_FILE=./shell_cicd_docker.properties
LOCAL_SCRIPT_LOGS=../scripts/logs.sh
LOCAL_SCRIPT_START=../scripts/start.sh
LOCAL_SCRIPT_STATUS=../scripts/status.sh
LOCAL_SCRIPT_STOP=../scripts/stop.sh
LOCAL_SCRIPT_FIRST_DEPLOY=../scripts/first_deploy.sh

source $LOCAL_FILE

check_local_script_folder() {
    if [ ! -f $LOCAL_SCRIPT_LOGS ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_LOGS não existe!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_LOGS... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_START ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_START não existe!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_START... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_STATUS ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_STATUS não existe!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_STATUS... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_STOP ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_STOP não existe!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_STOP... OK"
    fi

    if [ ! -f $LOCAL_SCRIPT_FIRST_DEPLOY ]; then
        echo -e "Arquivo $LOCAL_SCRIPT_FIRST_DEPLOY não existe!!"
        exit 1
    else
        echo -e "$LOCAL_SCRIPT_FIRST_DEPLOY... OK"
    fi

}

create_dir() {
    if [ ! -d $APP_DOCKER_VOLUMES_DATA ]; then
        sudo mkdir -p $APP_DOCKER_VOLUMES_DATA
    fi

    if [ ! -d $APP_DOCKER_VOLUMES_CONFIGS ]; then
        sudo mkdir -p $APP_DOCKER_VOLUMES_CONFIGS
    fi

    if [ ! -d $APP_DOCKER_VOLUMES_LOGS ]; then
        sudo mkdir -p $APP_DOCKER_VOLUMES_LOGS
    fi

    if [ ! -d $APP_DOCKER_STACKS ]; then
        sudo mkdir -p $APP_DOCKER_STACKS
    fi

    if [ ! -d $APP_DOCKER_APPS ]; then
        sudo mkdir -p $APP_DOCKER_APPS
    fi
}

give_permissions_dirs() {
    sudo chown -R $USER:docker $APP_DOCKER_ROOT
}

cp_file() {
    mkdir $HOME_PATH
    cp $LOCAL_FILE $HOME_PATH
}

cp_scripts() {
    mkdir $HOME_PATH_SCRIPTS
    cp -r $LOCAL_SCRIPT_LOGS $LOCAL_SCRIPT_START $LOCAL_SCRIPT_STOP $LOCAL_SCRIPT_STATUS $LOCAL_SCRIPT_FIRST_DEPLOY $HOME_PATH_SCRIPTS
}

do_install() {
    cp_file
    create_dir
    cp_scripts
    give_permissions_dirs
    echo -e "Done!"
}

do_update() {
    rm $HOME_PATH_FILE
    rm -d $HOME_PATH
    do_install
}
yes_or_not() {
    while true; do
        read -p "Do you wish to update?" yn
        case $yn in
        [Yy]*)
            do_update
            break
            ;;
        [Nn]*) exit ;;
        *) echo "Please answer (y)es or (n)o." ;;
        esac
    done
}

check_local_properties_folder() {
    if [ -f $HOME_PATH_FILE ]; then
        echo -e "Already installed!"
        yes_or_not
    else
        echo -e "Beginnign of your first instalation..."
        do_install
    fi
}
check_previous_installation() {
    check_local_script_folder
    check_local_properties_folder
}

if [ -f $LOCAL_FILE ]; then
    echo -e "Local shell_cicd_docker.properties do exists... OK"
    check_previous_installation
else
    echo -e "Local shell_cicd_docker.properties do NOT exists!!"
    echo -e "This script needs to execute at same path as the shell_cicd_docker.properties!!"
    echo -e "Try it again..."
    exit 1
fi

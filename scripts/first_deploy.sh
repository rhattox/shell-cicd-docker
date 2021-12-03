#!/bin/bash

#GLOBAL COLS
cols=$(tput cols)
middle_of_screen=$(expr $cols / 3)

HOME_PATH=~/shell_cicd_docker
HOME_PATH_SCRIPTS=$HOME_PATH/scripts
source $HOME_PATH/shell_cicd_docker.properties

GIT_HTTPS=$1
APP_NAME=$2
GIT_TAG=$3

test_dir_app() {
    if [[ -d $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG ]]; then
        for ((i = 0; i < cols; i++)); do printf "="; done
        echo -e "Application already exits at: $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        for ((i = 0; i < cols; i++)); do printf "="; done
        exit 1
    else
        for ((i = 0; i < cols; i++)); do printf "="; done
        echo -e "Application do not exists, creating home directory at: $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG "
        mkdir -p $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG
        for ((i = 0; i < cols; i++)); do printf "="; done
        copy_git_source
        for ((i = 0; i < cols; i++)); do printf "="; done
    fi
}

copy_git_source() {
    for ((i = 0; i < cols; i++)); do printf "="; done
    #git clone --branch 0.0.1-SNAPSHOT001   --single-branch --depth 1 https://github.com/bcovies/php_recybem_bndes.git ./php_recybem_bndes-0.0.1-SNAPSHOT001/
    git clone --branch $GIT_TAG --single-branch --depth 1 $GIT_HTTPS $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG &>/dev/null
    echo -e "Downloaded git repo sucessfully at: $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    for ((i = 0; i < cols; i++)); do printf "="; done
    create_env

}

create_env() {
    for ((i = 0; i < cols; i++)); do printf "="; done
    echo -e "Creating .env file at: $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    cd $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG
    touch .env
    echo "APP_NAME=$APP_NAME" >>.env
    echo "APP_DOCKER_VOLUMES_DATA=$APP_DOCKER_VOLUMES_DATA" >>.env
    echo "APP_DOCKER_VOLUMES_CONFIGS=$APP_DOCKER_VOLUMES_CONFIGS" >>.env
    echo "APP_DOCKER_VOLUMES_LOGS=$APP_DOCKER_VOLUMES_LOGS" >>.env
    echo "APP_DOCKER_STACKS=$APP_DOCKER_STACKS" >>.env
    echo "APP_DOCKER_APPS=$APP_DOCKER_APPS" >>.env
    for ((i = 0; i < cols; i++)); do printf "="; done
}

copy_scripts() {
    cp -r $HOME_PATH_SCRIPTS/status.sh $HOME_PATH_SCRIPTS/start.sh $HOME_PATH_SCRIPTS/logs.sh $HOME_PATH_SCRIPTS/stop.sh $APP_DOCKER_STACKS/$APP_NAME-$GIT_TAG
}

entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $middle_of_screen
    echo -e "############################"
    tput cup 4 $middle_of_screen
    echo -e "######  DEPLOY SCRIPT  #####"
    tput cup 5 $middle_of_screen
    echo -e "############################"
}

entry_screen
test_dir_app
copy_scripts

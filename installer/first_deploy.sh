#!/bin/bash

HOME_PATH=/installer
source $HOME_PATH/shell_cicd_docker.properties

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
CMD=$3
APP_NAME=$4
# first deploy variables
GIT_HTTPS=$5
GIT_TAG=$6

test_dir_app() {
    if [[ -d $DOCKER_STACKS/$APP_NAME-$GIT_TAG ]]; then
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        echo -e "Application already exits at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        exit 1
    else
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        echo -e "Application do not exists, creating home directory at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        mkdir -p $DOCKER_STACKS/$APP_NAME-$GIT_TAG
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        copy_git_source
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    fi
}

copy_git_source() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    #git clone --branch 0.0.1-SNAPSHOT001   --single-branch --depth 1 https://github.com/bcovies/php_recybem_bndes.git ./php_recybem_bndes-0.0.1-SNAPSHOT001/
    git clone --branch $GIT_TAG --single-branch --depth 1 $GIT_HTTPS $DOCKER_STACKS/$APP_NAME-$GIT_TAG &>/dev/null
    echo -e "Downloaded git repo sucessfully at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    create_env

}

create_env() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "Creating .env file at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    cd $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    touch .env
    echo "APP_NAME=$APP_NAME" >>.env
    echo "DOCKER_VOLUMES_DATA=$DOCKER_VOLUMES_DATA" >>.env
    echo "DOCKER_VOLUMES_CONFIGS=$DOCKER_VOLUMES_CONFIGS" >>.env
    echo "DOCKER_VOLUMES_LOGS=$DOCKER_VOLUMES_LOGS" >>.env
    echo "DOCKER_STACKS=$DOCKER_STACKS" >>.env
    echo "DOCKER_APPS=$DOCKER_APPS" >>.env
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}
create_scripts_cicd_docker() {
    cd $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    cp $HOME_PATH/cicd_docker.sh .
    ln -s cicd_docker.sh start.sh
    ln -s cicd_docker.sh stop.sh
    ln -s cicd_docker.sh status.sh
    ln -s cicd_docker.sh logs.sh
    ln -s cicd_docker.sh deploy.sh
}

entry_screen() {
    # clear the screen
    tput clear
    # Move cursor to screen location X,Y (top left is 0,0)
    tput cup 3 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "###################################"
    tput cup 4 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "######  FIRST DEPLOY SCRIPT  #####"
    tput cup 5 $SCRIPT_MIDDLE_OF_SCREEN
    echo -e "##################################"
}

create_link() {
    cd $DOCKER_APPS
    ln -s $DOCKER_STACKS/$APP_NAME-$GIT_TAG $APP_NAME
}

entry_screen
test_dir_app
create_scripts_cicd_docker
create_link

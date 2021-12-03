#!/bin/bash

#GLOBAL COLS
cols=$(tput cols)
middle_of_screen=$(expr $cols / 3)

HOME_PATH=/installer
source $HOME_PATH/shell_cicd_docker.properties
APP_NAME=$1
GIT_HTTPS=$2
GIT_TAG=$3

test_dir_app() {
    if [[ -d $DOCKER_STACKS/$APP_NAME-$GIT_TAG ]]; then
        for ((i = 0; i < cols; i++)); do printf "="; done
        echo -e "Application already exits at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        for ((i = 0; i < cols; i++)); do printf "="; done
        exit 1
    else
        for ((i = 0; i < cols; i++)); do printf "="; done
        echo -e "Application do not exists, creating home directory at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        mkdir -p $DOCKER_STACKS/$APP_NAME-$GIT_TAG
        for ((i = 0; i < cols; i++)); do printf "="; done
        copy_git_source
        for ((i = 0; i < cols; i++)); do printf "="; done
    fi
}

copy_git_source() {
    for ((i = 0; i < cols; i++)); do printf "="; done
    #git clone --branch 0.0.1-SNAPSHOT001   --single-branch --depth 1 https://github.com/bcovies/php_recybem_bndes.git ./php_recybem_bndes-0.0.1-SNAPSHOT001/
    git clone --branch $GIT_TAG --single-branch --depth 1 $GIT_HTTPS $DOCKER_STACKS/$APP_NAME-$GIT_TAG &>/dev/null
    echo -e "Downloaded git repo sucessfully at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    for ((i = 0; i < cols; i++)); do printf "="; done
    create_env

}

create_env() {
    for ((i = 0; i < cols; i++)); do printf "="; done
    echo -e "Creating .env file at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    cd $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    touch .env
    echo "APP_NAME=$APP_NAME" >>.env
    echo "DOCKER_VOLUMES_DATA=$DOCKER_VOLUMES_DATA" >>.env
    echo "DOCKER_VOLUMES_CONFIGS=$DOCKER_VOLUMES_CONFIGS" >>.env
    echo "DOCKER_VOLUMES_LOGS=$DOCKER_VOLUMES_LOGS" >>.env
    echo "DOCKER_STACKS=$DOCKER_STACKS" >>.env
    echo "DOCKER_APPS=$DOCKER_APPS" >>.env
    for ((i = 0; i < cols; i++)); do printf "="; done
}

copy_scripts() {
    cp -r $HOME_PATH/status.sh $HOME_PATH/start.sh $HOME_PATH/logs.sh $HOME_PATH/stop.sh $DOCKER_STACKS/$APP_NAME-$GIT_TAG
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

create_link() {
    # cd
    ln -s $DOCKER_STACKS/$APP_NAME-$GIT_TAG $DOCKER_APPS/$APP_NAME
}

entry_screen
test_dir_app
copy_scripts
create_link

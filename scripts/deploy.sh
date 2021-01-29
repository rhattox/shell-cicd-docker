#!/bin/bash

#GLOBAL COLS
cols=$(tput cols)
middle_of_screen=$(expr $cols / 3)

GIT_HTTPS=$1
APP_NAME=$2
PATH_DEPLOYMENT=$3
PATH_VOLUME=$4
HOME_PATH=$(pwd)

test_git_source() {
    if [[ -d $PATH_DEPLOYMENT/$APP_NAME ]]; then
        rm -rf $PATH_DEPLOYMENT/$APP_NAME
        mkdir -p $PATH_DEPLOYMENT/$APP_NAME
        copy_git_source
    else
        mkdir -p $PATH_DEPLOYMENT/$APP_NAME
        copy_git_source
    fi
}

copy_git_source() {
    for ((i = 0; i < cols; i++)); do printf "="; done
    cd $PATH_DEPLOYMENT
    git clone $GIT_HTTPS
    create_env
    for ((i = 0; i < cols; i++)); do printf "="; done
}

create_env() {
    if [[ -f $PATH_DEPLOYMENT/$APP_NAME/.env ]]; then
        rm -f $PATH_DEPLOYMENT/$APP_NAME/.env
        cd $PATH_DEPLOYMENT/$APP_NAME
        touch .env
        echo "APP_NAME=$APP_NAME" >>.env
        echo "PATH_DEPLOYMENT=$PATH_DEPLOYMENT/$APP_NAME" >>.env
        echo "PATH_VOLUME=$PATH_VOLUME/$APP_NAME" >>.env
    else
        cd $PATH_DEPLOYMENT/$APP_NAME
        touch .env
        echo "APP_NAME=$APP_NAME" >>.env
        echo "PATH_DEPLOYMENT=$PATH_DEPLOYMENT/$APP_NAME" >>.env
        echo "PATH_VOLUME=$PATH_VOLUME/$APP_NAME" >>.env
    fi

}

create_volume() {
    if [[ -d $PATH_VOLUME/$APP_NAME ]]; then
        rm -rf $PATH_VOLUME/$APP_NAME
        mkdir -p $PATH_VOLUME/$APP_NAME
    else
        mkdir -p $PATH_VOLUME/$APP_NAME
    fi
}

copy_scripts(){
   cp -a $HOME_PATH/status.sh $HOME_PATH/start.sh $HOME_PATH/logs.sh $HOME_PATH/stop.sh $PATH_DEPLOYMENT/$APP_NAME
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
test_git_source
create_volume
copy_scripts

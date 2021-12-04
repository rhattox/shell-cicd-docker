#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
# all services variables
APP_NAME=$2

source /installer/shell_cicd_docker.properties

cd $DOCKER_APPS/$APP_NAME

if [[ -f "./.env.backup" ]]; then
    echo "Backup env file founded! Adding to .env (~final~)"
    fgrep -vxf .env .env.backup >>.env
    rm -f .env.backup
else
    echo "Backup not founded, skiping this step (there was no .env in git clone!)"
fi

if [[ -f "./.env.secrets" ]]; then
    echo "Secrets env file founded!"
else
    echo "Secrets not founded, skiping this step"
fi

if [[ -f "./.env.defaults" ]]; then
    echo "Defaults env file founded!"
else
    echo "Defaults not founded, skiping this step"
    #rename .env.backup to .env.defaults
fi

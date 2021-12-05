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
    tac .env | awk '{                               
    line = $0                                   
    sub(/#.*/, "")                              
    if (match($0, /([[:alnum:]_]+)=/)) {        
        var = substr($0, RSTART, RLENGTH - 1)
        if (! seen[var]++) print line
    } else { 
        print line
    } 
    }' | tac >.env.tmp
    rm -f .env.backup

    rm -f .env

    mv .env.tmp .env
else
    echo "Backup not founded, skiping this step (there was no .env in git clone!)"
fi

if [[ -f "./.env.secrets" ]]; then
    echo "Secrets env file founded!"
    fgrep -vxf .env .env.secrets >>.env

    tac .env | awk '{                               
    line = $0                                   
    sub(/#.*/, "")                              
    if (match($0, /([[:alnum:]_]+)=/)) {        
        var = substr($0, RSTART, RLENGTH - 1)
        if (! seen[var]++) print line
    } else { 
        print line
    } 
    }' | tac >.env.tmp

    rm -f .env

    mv .env.tmp .env
else
    echo "Secrets not founded, skiping this step"
fi

if [[ -f "./.env.defaults" ]]; then
    echo "Defaults env file founded!"
    fgrep -vxf .env .env.defaults >>.env
    tac .env | awk '{                               
    line = $0                                   
    sub(/#.*/, "")                              
    if (match($0, /([[:alnum:]_]+)=/)) {        
        var = substr($0, RSTART, RLENGTH - 1)
        if (! seen[var]++) print line
    } else { 
        print line
    } 
    }' | tac >.env.tmp

    rm -f .env

    mv .env.tmp .env

else
    echo "Defaults not founded, skiping this step"
fi

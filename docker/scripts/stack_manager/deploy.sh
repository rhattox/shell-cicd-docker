#!/bin/bash

#   Caminho dos scripts SEPARADO POR UTILIZAÇÃO, cuidado!
#
#   SCRIPTS             -->     entrypoint | help | redirect | setup
#
PATH_SCRIPTS=/scripts
#
#   CONTAINER_MANAGER   -->     logs | start | status | stop
#
PATH_CONTAINER_MANAGER=${PATH_SCRIPTS}/container_manager
#
#   STACK_MANAGER       -->     deploy | first_deploy
#
PATH_STACK_MANAGER=${PATH_SCRIPTS}/stack_manager
#
#   CONFIGS
#
PATH_CONFIGS=/configs

source $PATH_CONFIGS/shell_cicd_docker.properties


# basic variables
SCRIPT_COLLUMNS=$1
# all services variables
APP_NAME=$2


cd $DOCKER_APPS/$APP_NAME

check_env_variables() {
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
        echo "Secrets env file founded! Adding to .env (~final~)"
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
        echo "Defaults env file founded! Adding to .env (~final~)"
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
}

create_python_script() {
    cat >parser.py <<"EOF"
import os
import pwd
import grp
from dotenv import load_dotenv

load_dotenv()

env_file = open('docker-swarm.yml', 'r')
Lines = env_file.readlines()

array_string_var = []

for line in Lines:
    if ("device" in line):
        string_var = "{}".format(line.strip())
        string_var = string_var.replace('$','')
        string_var = string_var.replace('"','')
        string_var = string_var.replace('{','')
        string_var = string_var.replace('device:','')
        string_var = string_var.replace('}','')
        string_var = string_var.replace(' ','')
        array_string_var.append(string_var)

APP_NAME = os.getenv('APP_NAME')
DOCKER_VOLUMES_DATA = os.getenv('DOCKER_VOLUMES_DATA')
DOCKER_VOLUMES_CONFIGS = os.getenv('DOCKER_VOLUMES_CONFIGS')
DOCKER_VOLUMES_LOGS = os.getenv('DOCKER_VOLUMES_LOGS')

array_value_env = ['APP_NAME','DOCKER_VOLUMES_DATA','DOCKER_VOLUMES_CONFIGS','DOCKER_VOLUMES_LOGS']
array_string_env = [APP_NAME,DOCKER_VOLUMES_DATA,DOCKER_VOLUMES_CONFIGS,DOCKER_VOLUMES_LOGS]

words = [w.replace('APP_NAME', APP_NAME) for w in array_string_var]
words = [w.replace('DOCKER_VOLUMES_DATA', DOCKER_VOLUMES_DATA) for w in words]
words = [w.replace('DOCKER_VOLUMES_CONFIGS', DOCKER_VOLUMES_CONFIGS) for w in words]
words = [w.replace('DOCKER_VOLUMES_LOGS', DOCKER_VOLUMES_LOGS) for w in words]

uid = pwd.getpwnam("root").pw_uid
gid = grp.getgrnam("docker").gr_gid

for x in words:
    if (os.path.exists(x)):
        print("Dir: '%s' already exists!!" % x)
    else:
        os.makedirs(x, exist_ok=True)
        os.chmod(x, 0o750)
        os.chown(x, uid, gid)
        print("Dir: '%s' created!!" % x)

EOF
}

run_python_script() {
    python3 parser.py
    sleep 3
    rm -f parser.py
}

check_env_variables
create_python_script
sleep 2
run_python_script

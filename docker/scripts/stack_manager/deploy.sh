#!/bin/bash

APP_NAME=${1}
DOCKER_APP_FULL_PATH=${2}

entry_screen() {
    clear
    echo -e "##############################"
    echo -e "######  DEPLOY SCRIPT    #####"
    echo -e "##############################"
    sleep 1
}

load_environment_variables(){
    source /configs/environment.properties
    source /configs/shell_cicd_docker.properties
    source /configs/tput.sh
}

change_dir(){
    cd ${DOCKER_APP_FULL_PATH}
}

check_env_variables() {
    echo "------------------------------------------------------------"
    echo "Searching .env.backup at $(pwd)"
    if [[ -f "./.env.backup" ]]; then
        set_yellow
        echo "Backup env file founded! Adding to .env (~final~)"
        clean_tput
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
        echo "Backup not founded at $(pwd), skiping this step (there was no .env in git clone!)"
    fi
    echo "------------------------------------------------------------"
    echo "Searching .env.secrets at $(pwd)"
    if [[ -f "./.env.secrets" ]]; then
        set_yellow
        echo "Secrets env file founded! Adding to .env (~final~)"
        clean_tput
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
        echo "Secrets not founded at $(pwd), skiping this step"
    fi
    echo "------------------------------------------------------------"
    echo "Searching .env.defaults at $(pwd)"
    if [[ -f "./.env.defaults" ]]; then
        set_yellow
        echo "Defaults env file founded! Adding to .env (~final~)"
        clean_tput
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
        echo "Defaults not founded at $(pwd), skiping this step"
    fi
    echo "------------------------------------------------------------"
    echo "Searching .env.local at $(pwd)"
    if [[ -f "./.env.local" ]]; then
        set_yellow
        echo "Local env file founded! Adding to .env (~final~)"
        clean_tput
        fgrep -vxf .env .env.local >>.env
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
        echo "Local not founded at $(pwd), skiping this step"
    fi
    echo "------------------------------------------------------------"
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
gid = grp.getgrnam("root").gr_gid

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
    set_yellow
    python3 parser.py
    clean_tput
    sleep 3
    rm -f parser.py
}

cp_new_env(){
    cp -a .env ./cicdocker
}

check_env_configs_folder(){
    
    if [[ -d ${DOCKER_APP_FULL_PATH}/.env.configs/confd ]]; then
        set_green
        echo "Path: ${DOCKER_APP_FULL_PATH}/.env.configs/confd exists!"
        clean_tput
        echo "------------------------------------------------------------"

    else
        set_yellow
        echo "Path: ${DOCKER_APP_FULL_PATH}/.env.configs/confd do not exists!"
        clean_tput
        echo "------------------------------------------------------------"
        set_blink
        echo "Creating one..."
        clean_tput
        echo "------------------------------------------------------------"
        mkdir -p ${DOCKER_APP_FULL_PATH}/.env.configs/confd
    fi

}

run_confd_script(){
    if [[ -d ${DOCKER_APP_FULL_PATH}/confd ]]; then
        # echo "${DOCKER_APP_FULL_PATH}/confd exists!"
        if [[ -d ${DOCKER_APP_FULL_PATH}/confd/conf.d && ${DOCKER_APP_FULL_PATH}/confd/templates ]];then
            set_yellow
            echo "${DOCKER_APP_FULL_PATH}/confd/conf.d && ${DOCKER_APP_FULL_PATH}/confd/templates exists"
            clean_tput
            echo "------------------------------------------------------------"
            check_env_configs_folder
            echo "Creating templates to: ${DOCKER_APP_FULL_PATH}/.env.configs/confd"
            echo "------------------------------------------------------------"
            env $(cat .env | grep ^[A-Z] | xargs) /opt/confd/bin/confd -onetime -confdir ${DOCKER_APP_FULL_PATH}/confd -backend env
            DIRCOUNT=$(ls -1A /tmp/confd/ | wc -l)
            if [ $DIRCOUNT -eq 0 ]; then
                set_red
                set_blink
                echo "[$(basename "$0")] ERROR: Can't create templates!! Check messages before this one..."
                clean_tput
                set_red
                echo "Probably is an .env.secrets that's not configured..."
                clean_tput
                echo "------------------------------------------------------------"
                exit 1
            else
                set_green; echo "Templates created with success"; clean_tput;
                echo "------------------------------------------------------------"
                cp -a /tmp/confd/* ${DOCKER_APP_FULL_PATH}/.env.configs/confd
            fi      
        else
            set_red
            echo "${DOCKER_APP_FULL_PATH}/confd/conf.d && ${DOCKER_APP_FULL_PATH}/confd/templates not founded, skiping this step..."
            clean_tput
            echo "------------------------------------------------------------"
        fi
    else
        set_red
        echo "${DOCKER_APP_FULL_PATH}/confd not founded! Skiping this step..."
        clean_tput
        echo "------------------------------------------------------------"
    fi
}



init(){
    entry_screen
    load_environment_variables
    change_dir
    check_env_variables
    create_python_script
    sleep 2
    run_python_script
    run_confd_script
    cp_new_env
}

init
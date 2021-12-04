#!/bin/bash

SCRIPT_COLLUMNS=$(tput cols)
SCRIPT_LINES=$(tput lines)
SCRIPT_MIDDLE_OF_SCREEN=$(expr "$SCRIPT_COLLUMNS" / 3)

welcome_screen() {

    cat <<"EOF"
  ____ ___ ____ ____     ____   ___   ____ _  _______ ____
 / ___|_ _/ ___|  _ \   |  _ \ / _ \ / ___| |/ / ____|  _ \
| |    | | |   | | | |  | | | | | | | |   | ' /|  _| | |_) |
| |___ | | |___| |_| |  | |_| | |_| | |___| . \| |___|  _ <
 \____|___\____|____/___|____/ \___/ \____|_|\_\_____|_| \_\
                   |_____|

EOF

}
tput bold
tput setab 0
tput setaf 5
welcome_screen
tput sgr0
helper_self() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\nAll self scripts do NOT need any params to use it."
    echo -e "If it is not working, there is something wrong, run ./setup.sh"
    echo -e "e.g.: ln -s ./cicd_docker.sh ./setup.sh"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\nSelf Scripts:\n"
    echo -e "Scripts: start stop status logs setup and deploy"
    echo -e "Start: starts application based by docker-swarm.yml"
    echo -e "Stop: stops application based by docker-swarm.yml"
    echo -e "Logs: logs application based by docker-swarm.yml"
    echo -e "Status: status application based by docker-swarm.yml"
    echo -e "Deploy: deploys application based by docker-swarm.yml"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}

tput setab 0
tput setaf 1
helper_self
tput sgr0

first_deploy() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "About first_deploy.sh"
    echo -e "\nThis is the MOST important script. You will need to:"
    echo -e "\t1-Have /opt/docker volumes available (or, you could change at cicd_docker.sh)"
    echo -e "\t2-Have full access to https clone from github"
    echo -e "\t3-A valid tag from github"
    echo -e "\t4-Define an app name"
    echo -e "\ne.g.: ./first_deploy.sh APP_NAME GIT_HTTPS GIT_TAG"
    echo -e "\ne.g.: ./first_deploy.sh php_recybem_bndes https://github.com/bcovies/docker_deployment_php_recybem_bndes.git 0.0.1-SNAPSHOT001"
    echo -e "\n"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}

tput setab 0
tput setaf 3
first_deploy
tput sgr0

first_version() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\nNotes for the first version:"
    echo -e "\nBase of app:"
    echo -e "\tFor using complete features, you will need to enable docker tcp connections..."
    echo -e "\te.g.: mkdir -p /etc/systemd/system/docker.service.d/"
    echo -e "\te.g.: vim /etc/systemd/system/docker.service.d/override.conf"
    echo -e "\n"
    echo -e "[Service]"
    echo -e "ExecStart="
    echo -e "ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375"
    echo -e "\n"
    echo -e "systemctl reload docker"
    echo -e "\n"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}

tput setab 0
tput setaf 7
first_version
tput sgr0

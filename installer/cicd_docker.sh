#!/bin/bash

SCRIPT_COLLUMNS=$(tput cols)

# ARG FIXED
CMD=$(basename "$0")
# OTHERS
ARGS=("$@")

check_empty_variable() {
    if [[ -z "$CMD" ]]; then
        echo "Empty variable"
        exit 1
    fi
}

get_collumns() {
    if [[ -z "$SCRIPT_COLLUMNS" ]]; then
        cols=50
    fi
}

start_script() {
    if [[ "$CMD" == "first_deploy.sh" || "$CMD" == "setup.sh" || "$CMD" == "help.sh" ]]; then
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock shell_cicd_docker /bin/bash /installer/entrypoint.sh $SCRIPT_COLLUMNS $CMD "${ARGS[@]}"
    else
        if [[ -f ./.env ]]; then
            docker run --rm --network="host" -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock shell_cicd_docker /bin/bash /installer/entrypoint.sh $SCRIPT_COLLUMNS $CMD
        else
            echo ".env not founded can't execute $CMD script, try to first_deploy.sh an application!!"
            echo "Or you may create a template as shell_cicd_docker.properties with APP_Name"
            exit 1
        fi
    fi
}

check_empty_variable
get_collumns
start_script

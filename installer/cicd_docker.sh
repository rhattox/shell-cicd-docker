#!/bin/bash

SCRIPT_COLLUMNS=$(tput cols)
SCRIPT_MIDDLE_OF_SCREEN=$(expr "$SCRIPT_COLLUMNS" / 3)

# ARG FIXED
CMD=$(basename "$0")
# OTHERS
ARGS=("$@")

if [[ -z "$CMD" ]]; then
    echo "Empty variable"
    exit 1
fi

if [[ -z "$cols" ]]; then
    cols=50
    SCRIPT_MIDDLE_OF_SCREEN=$(expr "$SCRIPT_COLLUMNS" / 3)
fi

if [[ "$CMD" == "first_deploy.sh" || "$CMD" == "setup.sh" || "$CMD" == "help.sh" ]]; then
    docker run --rm -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock shell_cicd_docker /bin/bash /installer/entrypoint.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD "${ARGS[@]}"
else
    if [[ -f ./.env ]]; then
        docker run --rm -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock shell_cicd_docker /bin/bash /installer/entrypoint.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD
    else
        echo ".env not founded can't execute $CMD script, try to first_deploy.sh an application!!"
        exit 1
    fi
fi

#!/bin/bash

SCRIPT_COLLUMNS=$(tput cols)
SCRIPT_MIDDLE_OF_SCREEN=$(expr "$SCRIPT_COLLUMNS" / 3)
CMD=$(basename "$0")
APP_NAME=$1
GIT_HTTPS=$2
GIT_TAG=$3

if [[ -z "$CMD" ]]; then
    echo "Empty variable"
    exit 1
fi

if [[ -z "$cols" ]]; then
    cols=50
    SCRIPT_MIDDLE_OF_SCREEN=$(expr "$SCRIPT_COLLUMNS" / 3)
fi

echo "Script local antes do container: $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG"

docker run --rm -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock shell_cicd_docker /bin/bash /installer/entrypoint.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG

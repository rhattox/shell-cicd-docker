#!/bin/bash

ARGS=("$@")

# basic variables
SCRIPT_COLLUMNS=${ARGS[0]}
SCRIPT_MIDDLE_OF_SCREEN=${ARGS[1]}
# all services variables
CMD=${ARGS[2]}
# first deploy variables
APP_NAME=${ARGS[3]}
GIT_HTTPS=${ARGS[4]}
GIT_TAG=${ARGS[5]}

# for i in "${ARGS[@]}"; do
#     echo "Testando repetição entry $i"
# done

# echo "Entrypoint: $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG"

export TERM=xterm-256color

init() {
    if [[ -z "$CMD" ]]; then
        echo -e "First variable is NULL, no execution."
        exit 1
    fi
}

select_service() {
    case $CMD in
    setup.sh)
        do_setup
        ;;
    first_deploy.sh)
        do_first_deploy
        ;;
    deploy.sh)
        do_deploy
        ;;
    start.sh)
        do_start
        ;;
    stop.sh)
        do_stop
        ;;
    status.sh)
        do_status
        ;;
    logs.sh)
        do_logs
        ;;
    *)
        echo -e "Service unknown"
        exit 1
        ;;
    esac

}

do_setup() {
    /bin/bash /installer/setup.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN
}
do_first_deploy() {
    /bin/bash /installer/first_deploy.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_deploy() {
    source /root/.env
    /bin/bash /installer/deploy.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $APP_NAME $DOCKER_APP_FULL_PATH
}
do_start() {
    source /root/.env
    /installer/start.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $APP_NAME $DOCKER_APP_FULL_PATH
}
do_stop() {
    source /root/.env
    /bin/bash /installer/stop.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $APP_NAME $DOCKER_APP_FULL_PATH
}
do_status() {
    source /root/.env
    /bin/bash /installer/status.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $APP_NAME $DOCKER_APP_FULL_PATH
}
do_logs() {
    source /root/.env
    /bin/bash /installer/logs.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $APP_NAME $DOCKER_APP_FULL_PATH
}

init
select_service

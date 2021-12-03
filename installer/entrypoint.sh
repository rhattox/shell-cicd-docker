#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
CMD=$3
APP_NAME=$4
# first deploy variables
GIT_HTTPS=$5
GIT_TAG=$6

echo "Entrypoint: $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG"

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
    /bin/bash /installer/setup.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_first_deploy() {
    /bin/bash /installer/first_deploy.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_deploy() {
    /bin/bash /installer/deploy.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_start() {
    /bin/bash /installer/start.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_stop() {
    /bin/bash /installer/stop.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_status() {
    /bin/bash /installer/status.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}
do_logs() {
    /bin/bash /installer/logs.sh $SCRIPT_COLLUMNS $SCRIPT_MIDDLE_OF_SCREEN $CMD $APP_NAME $GIT_HTTPS $GIT_TAG
}

init
select_service

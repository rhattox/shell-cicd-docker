#!/bin/bash
#
# redirect.sh - Responsável por ser o redirecionador de scripts.
#
# Autor: Bruno Souto <bcovies@gmail.com>
#
# -----------------------------------------------------------------------------------------------------------
#       Este programa recebe do ponto de entrada e redireciona para o script desejado.
# -----------------------------------------------------------------------------------------------------------
#
#   Histórico:
#
#   v0.0.1 - 2021-12-05
#       - criado script básico.
#
#
#   Licença: GPL.

ARGS=("$@")
CMD=${ARGS[0]}
APP_NAME=${ARGS[1]}
GIT_HTTPS=${ARGS[2]}
GIT_TAG=${ARGS[3]}

load_environment_variables(){
    source /configs/environment.properties
    source /configs/shell_cicd_docker.properties
    export TERM=xterm-256color
}

check_vars() {
    echo "Var Checking at $(basename "$0")..."
    echo "CMD: ${CMD} APP_NAME: ${APP_NAME} GIT_HTTPS: ${GIT_HTTPS} GIT_TAG: ${GIT_TAG}"
}

select_service() {
    case ${CMD} in
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
    help.sh)
        do_help
        ;;
    *)
        echo -e "[$(basename "$0")] ERROR: Service unknown!"
        exit 1
        ;;
    esac

}

do_help() {
    /bin/bash ${PATH_SCRIPTS}/help.sh
}
do_setup() {
    /bin/bash ${PATH_SCRIPTS}/setup.sh
}
do_first_deploy() {
    /bin/bash ${PATH_SCRIPTS_STACK_MANAGER}/first_deploy.sh ${APP_NAME} ${GIT_HTTPS} ${GIT_TAG}
}
do_deploy() {
    source /root/.env
    /bin/bash ${PATH_SCRIPTS_STACK_MANAGER}/deploy.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_start() {
    source /root/.env
    /bin/bash ${PATH_SCRIPTS_CONTAINER_MANAGER}/start.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_stop() {
    source /root/.env
    /bin/bash ${PATH_SCRIPTS_CONTAINER_MANAGER}/stop.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_status() {
    source /root/.env
    /bin/bash ${PATH_SCRIPTS_CONTAINER_MANAGER}/status.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_logs() {
    source /root/.env
    /bin/bash ${PATH_SCRIPTS_CONTAINER_MANAGER}/logs.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}

init(){
    # check_vars
    load_environment_variables
    select_service
}


init
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

PATH_SCRIPTS=/scripts
PATH_CONTAINER_MANAGER=${PATH_SCRIPTS}/container_manager
PATH_STACK_MANAGER=${PATH_SCRIPTS}/stack_manager
PATH_CONFIGS=/configs
ARGS=("$@")
CMD=${ARGS[0]}
APP_NAME=${ARGS[1]}
GIT_HTTPS=${ARGS[2]}
GIT_TAG=${ARGS[3]}

export TERM=xterm-256color

init() {
    if [[ -z "$CMD" ]]; then
        echo -e "First variable is NULL, no execution."
        exit 1
    fi
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
        echo -e "Service unknown"
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
    /bin/bash ${PATH_STACK_MANAGER}/first_deploy.sh ${APP_NAME} ${GIT_HTTPS} ${GIT_TAG}
}
do_deploy() {
    source /root/.env
    /bin/bash ${PATH_STACK_MANAGER}/deploy.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_start() {
    source /root/.env
    /bin/bash ${PATH_CONTAINER_MANAGER}/start.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_stop() {
    source /root/.env
    /bin/bash ${PATH_CONTAINER_MANAGER}/stop.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_status() {
    source /root/.env
    /bin/bash ${PATH_CONTAINER_MANAGER}/status.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}
do_logs() {
    source /root/.env
    /bin/bash ${PATH_CONTAINER_MANAGER}/logs.sh ${APP_NAME} ${DOCKER_APP_FULL_PATH}
}

init
select_service

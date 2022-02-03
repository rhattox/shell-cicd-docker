#!/bin/bash
#
# entrypoint.sh - Responsável por ser o ponto de entrada do container e redirecionador de scripts.
#
# Autor: Bruno Souto <bcovies@gmail.com>
#
# -----------------------------------------------------------------------------------------------------------
#       Este programa recebe o ponto de entrada e redireciona para o script desejado.
# -----------------------------------------------------------------------------------------------------------
#
#   Histórico:
#
#   v0.0.1 - 2021-12-05
#       - criado script básico
#
#
#   Licença: GPL.
# -----------------------------------------------------------------------------------------------------------

CMD=$(basename "$0")
ARGS=("$@")


load_environment_variables(){
    source /configs/environment.properties
    source /configs/shell_cicd_docker.properties
}

entrypoint() {
    if [[ -f ./.env ]]; then
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash ${PATH_SCRIPTS}/redirect.sh ${CMD} "${ARGS[@]}"
    else
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash ${PATH_SCRIPTS}/redirect.sh ${CMD} "${ARGS[@]}"
    fi
}

init(){
    load_environment_variables
    entrypoint
}

init
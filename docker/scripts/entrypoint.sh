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

DOCKER_IMAGE=cicdocker
DOCKER_TAG=0.0.1-SNAPSHOT004

init() {
    if [[ -f ./.env ]]; then
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash /scripts/redirect.sh ${CMD} "${ARGS[@]}"
    else
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash /scripts/redirect.sh ${CMD} "${ARGS[@]}"
    fi
}

init
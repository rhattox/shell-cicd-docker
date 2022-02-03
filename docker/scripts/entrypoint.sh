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

DOCKER_IMAGE=cicdocker
DOCKER_TAG=0.0.1-SNAPSHOT003
PATH_SCRIPTS=/scripts
PATH_CONTAINER_MANAGER=${PATH_SCRIPTS}/container_manager
PATH_STACK_MANAGER=${PATH_SCRIPTS}/stack_manager
PATH_CONFIGS=/configs
CMD=$(basename "$0")

ARGS=("$@")

#   Faz verificação do ponto de entrada e cria o container dependendo da entrada.
start_script() {
    if [[ -f ./.env ]]; then
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash ${PATH_SCRIPTS}/redirect.sh ${CMD} "${ARGS[@]}"
    else
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash ${PATH_SCRIPTS}/redirect.sh ${CMD} "${ARGS[@]}"
    fi
}
init(){
    start_script
}

init
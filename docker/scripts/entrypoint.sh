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

#   Identifica o número de colunas do terminal
SCRIPT_COLLUMNS=$(tput cols)
DOCKER_IMAGE=cicdocker
DOCKER_TAG=0.0.1-SNAPSHOT003
PATH_SCRIPTS=/scripts
#   Argumento base (nome)
CMD=$(basename "$0")
#   Argumentos extras que recebem parâmetros
ARGS=("$@")

get_collumns() {
    if [[ -z "${SCRIPT_COLLUMNS}" ]]; then
        cols=50
    fi
}

#   Faz verificação do ponto de entrada e cria o container dependendo da entrada.
start_script() {
    if [[ -f ./.env ]]; then
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash /scripts/redirect.sh $SCRIPT_COLLUMNS $CMD "${ARGS[@]}"
    else
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash /scripts/redirect.sh $SCRIPT_COLLUMNS $CMD "${ARGS[@]}"
    fi
}
init(){
    get_collumns
    start_script
}

init
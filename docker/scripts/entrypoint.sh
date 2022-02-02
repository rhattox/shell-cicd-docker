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


#   Identifica o número de colunas do terminal
SCRIPT_COLLUMNS=$(tput cols)
DOCKER_IMAGE=cicdocker
DOCKER_TAG=0.0.1-SNAPSHOT003
PATH_SCRIPTS=/scripts
#   Argumento base (nome)
CMD=$(basename "$0")
#   Argumentos extras que recebem parâmetros
ARGS=("$@")

check_empty_variable() {
    if [[ -z "${CMD}" ]]; then
        echo "Empty variable"
        CMD="help.sh"
    fi
}

get_collumns() {
    if [[ -z "${SCRIPT_COLLUMNS}" ]]; then
        cols=50
    fi
}

#   Faz verificação do ponto de entrada e cria o container dependendo da entrada.
start_script() {
    if [[ "${CMD}" == "first_deploy.sh" || "${CMD}" == "setup.sh" || "${CMD}" == "help.sh" ]]; then
        docker run --rm --network="host" -v /opt/docker:/opt/docker -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash ${PATH_SCRIPTS}/redirect.sh ${SCRIPT_COLLUMNS} ${CMD} "${ARGS[@]}"
    else
        if [[ -f ./.env ]]; then
            docker run --rm --network="host" -v /opt/docker:/opt/docker -v $(pwd)/.env:/root/.env -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_IMAGE}:${DOCKER_TAG} /bin/bash ${PATH_SCRIPTS}/redirect.sh ${SCRIPT_COLLUMNS} ${CMD}
        else
            echo ".env not founded can't execute ${CMD} script, try to first_deploy.sh an application!!"
            echo "Or you may create a template as shell_cicd_docker.properties with APP_Name"
            exit 1
        fi
    fi
}

init(){
    check_empty_variable
    get_collumns
    start_script
}

init
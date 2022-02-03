#!/bin/bash
#
# start.sh - Faz start do serviço docker pelo arquivo docker-swarm.yml
#
# Autor: Bruno Souto <bcovies@gmail.com>
#
# -----------------------------------------------------------------------------------------------------------
#       Este programa executa o comando de start na pasta que está localizado o arquivo docker-compose.yml
#   e necessita de um uma imagem docker que é responsável por redirecionar o entrypoint para este script.
# -----------------------------------------------------------------------------------------------------------
#
#   Histórico:
#
#   v0.0.1 - 2021-12-05
#       - criado script básico para start do serviço do swarm
#
#
#   Licença: GPL.

APP_NAME=$1
DOCKER_APP_FULL_PATH=$2

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT START  #####"
    echo -e "############################"
}

start_stack() {
    cd $DOCKER_APP_FULL_PATH
    env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml $APP_NAME
    echo
}


init(){
    entry_screen
    start_stack
}

init


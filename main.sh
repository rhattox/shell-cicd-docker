#!/bin/bash

echo "Docker automated CI/CD is starting..."

#Starts build script

start_swarm() {
    echo "Start:"
}

stop_swarm() {
    echo "Stop:"
}

status_swarm() {
    echo "Status:"
}

deploy_swarm(){
    echo "Deploy:"
}

args=("$@")

echo Number of arguments: $#
first_arg=${args[0]}
echo 1st argument: $first_arg


case ${args[0]} in
start)
    start_swarm
    ;;
stop)
    stop_swarm
    ;;
status)
    status_swarm
    ;;
deploy)
    deploy_swarm
    ;;
*) echo "Invalid Option!!" ;;
esac
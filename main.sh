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
    echo $arg_0
    echo $arg_1
    echo $arg_2
    echo $arg_3

    sudo bash deploy.sh $arg_1 $arg_2 $arg_3 $arg_4
}

args=("$@")

echo Number of arguments: $#
arg_0=${args[0]}

arg_1=${args[1]}

arg_2=${args[2]}

arg_3=${args[3]}

arg_4=${args[4]}



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
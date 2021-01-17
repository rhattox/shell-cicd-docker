#!/bin/bash

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

args=("$@")

echo Number of arguments: $#
first_arg=${args[0]}
echo 1st argument: $first_arg
second_arg=${args[1]}
echo 2nd argument: $second_arg

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
*) echo "Invalid Option!!" ;;
esac

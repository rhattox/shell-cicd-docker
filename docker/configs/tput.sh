#!/bin/bash

set_bold(){
    tput bold
}

set_blink(){
    tput blink
}

set_blue(){
    tput setab 4
}

set_yellow(){
    tput setab 3
}

set_green(){
    tput setab 2
}

set_red(){
    tput setab 1 
}

set_magenta(){
    tput setab 5
}

clean_tput(){
    tput sgr0
}
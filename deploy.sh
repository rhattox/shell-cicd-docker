#!/bin/bash

##################################
##########   FUNCIONS   ##########
##################################

##############################
##########   MAIN   ##########
##############################

if [[ -f ./.env ]]; then
    echo "Founded .env"
else 
    echo "Not found .env" 
    exit 1
fi


echo "Is docker-swarm.yml inside any other folder from git's folder (y) or is already in the 'MAIN' git's folder (n)?" 
read ANSWER

if [[ $ANSWER = 'y' ]]; then
    echo "Enter docker-swarm.yml path" 
    read MAIN_FOLDER_STACK
    if [[ -d $MAIN_FOLDER_STACK ]]; then
        if [[ -f $MAIN_FOLDER_STACK/local.env ]]; then
            echo "Founded local.env!"
            echo "Reading local.env!"
            while IFS= read -r line;do
                echo "$line" >> $MAIN_FOLDER_STACK/.env
            done < "$MAIN_FOLDER_STACK/local.env"
            echo "Arquivo salvo."

                if [[ -f $MAIN_FOLDER_STACK/.env ]]; then
                    echo "Reading .env!"
                    while IFS= read -r line;do
                    echo "$line" >> $MAIN_FOLDER_STACK/.env
                    done < "./.env"
                    echo "Arquivo salvo."
                else 
                    echo "Not found local.env" 
                    exit 1
                fi
        else 
            echo "Not found local.env" 
            exit 1
        fi
    fi
else 
echo "error" 
fi


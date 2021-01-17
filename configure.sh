#!/bin/bash

echo "Stating to configure the aplication."

echo "Where is the main folder to DEPLOY applications in docker?"
read MAIN_FOLDER_DEPLOY

echo "Where is the main folder to VOLUME applications in docker?"
read MAIN_FOLDER_VOLUME

echo "What is the application name?"
read MAIN_APP_NAME

MAIN_FOLDER_DEPLOY_APP=$MAIN_FOLDER_DEPLOY/$MAIN_APP_NAME
MAIN_FOLDER_VOLUME_APP=$MAIN_FOLDER_VOLUME/$MAIN_APP_NAME

if [ -d $MAIN_FOLDER_DEPLOY_APP ]; then
    echo "Folder $MAIN_FOLDER_DEPLOY_APP already exists. Clean your previous installation before install." 
    exit 1
else
    mkdir -p $MAIN_FOLDER_DEPLOY_APP
fi

if [ -d $MAIN_FOLDER_VOLUME_APP ]; then
    echo "Folder $MAIN_FOLDER_VOLUME_APP already exists. Clean your previous installation before install." 
    exit 1
else
    mkdir -p $MAIN_FOLDER_VOLUME_APP
fi


cd $MAIN_FOLDER_DEPLOY_APP

ENV_FILE=.env

if test -f "$ENV_FILE"; then
    echo "File $ENV_FILE exists."
    rm -f $ENV_FILE
    echo "Recreating..."
    touch $ENV_FILE
else
    echo "File $ENV_FILE do not exists."
    touch $ENV_FILE
fi


echo "MAIN_FOLDER_DEPLOY=$MAIN_FOLDER_DEPLOY" >> .env
echo "MAIN_FOLDER_VOLUME=$MAIN_FOLDER_VOLUME" >> .env
echo "MAIN_APP_NAME=$MAIN_APP_NAME" >> .env
echo "MAIN_FOLDER_DEPLOY_APP=$MAIN_FOLDER_DEPLOY_APP" >> .env
echo "MAIN_FOLDER_VOLUME_APP=$MAIN_FOLDER_VOLUME_APP" >> .env


#env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-swarm.yml teste

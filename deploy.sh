#!/bin/bash

##################################
##########   FUNCIONS   ##########
##################################
copy_git_source(){
    cd $MAIN_FOLDER_DEPLOY
    git clone $GIT_HTTPS
}

create_folders(){
if [[ -d $MAIN_FOLDER_DEPLOY_APP &&  -d $MAIN_FOLDER_VOLUME_APP ]]; then
    
    if [ -d $MAIN_FOLDER_DEPLOY_APP ]; then
        echo "Folder $MAIN_FOLDER_DEPLOY_APP already exists. Clean your previous installation before install." 
        echo -e "CAUTION!! SAVE ALL YOUR DATA BEFORE PROCEDE \nEXECUTE: $ rm -rf $MAIN_FOLDER_DEPLOY_APP"
    fi
    
    if [ -d $MAIN_FOLDER_VOLUME_APP ]; then
        echo "Folder $MAIN_FOLDER_VOLUME_APP already exists. Clean your previous installation before install." 
        echo -e "CAUTION!! SAVE ALL YOUR DATA BEFORE PROCEDE \nEXECUTE: $ rm -rf $MAIN_FOLDER_VOLUME_APP"
    fi
        exit 1
else
    copy_git_source
    mkdir -p $MAIN_FOLDER_VOLUME_APP
    #mkdir -p $MAIN_FOLDER_DEPLOY_APP
    echo "ALL FOLDERS CREATED WITH SUCESS!"
fi
}

create_env(){
    
ENV_FILE=.env

cd $MAIN_FOLDER_DEPLOY_APP

if test -f "$ENV_FILE"; then
    echo "File $ENV_FILE exists."
    rm -f $ENV_FILE
    echo "Recreating..."
    touch $ENV_FILE
else
    echo "File $ENV_FILE do not exists."
    touch $ENV_FILE
    echo "Creating..."
fi


echo "MAIN_FOLDER_DEPLOY=$MAIN_FOLDER_DEPLOY" >> .env
echo "MAIN_FOLDER_VOLUME=$MAIN_FOLDER_VOLUME" >> .env
echo "MAIN_APP_NAME=$MAIN_APP_NAME" >> .env
echo "MAIN_FOLDER_DEPLOY_APP=$MAIN_FOLDER_DEPLOY_APP" >> .env
echo "MAIN_FOLDER_VOLUME_APP=$MAIN_FOLDER_VOLUME_APP" >> .env

echo "FILE .env CREATED WITH SUCESS!"

}

##############################
##########   MAIN   ##########
##############################

echo "Stating to configure the aplication."
MAIN_FOLDER_DEPLOY=$1
MAIN_FOLDER_VOLUME=$2
MAIN_APP_NAME=$3
GIT_HTTPS=https://$4
MAIN_FOLDER_DEPLOY_APP=$MAIN_FOLDER_DEPLOY/$MAIN_APP_NAME
MAIN_FOLDER_VOLUME_APP=$MAIN_FOLDER_VOLUME/$MAIN_APP_NAME

create_folders
create_env

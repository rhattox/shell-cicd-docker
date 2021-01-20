#!/bin/bash

###################################################
#############    FUNCTIONS      ###################
###################################################
ask_first_config(){
echo "Have you ever configured this script?"
read ANSWER
if [[ $ANSWER = 'n' ]]; then
    echo "Will be started a configuration script, please, execute this script after the conclusion."
    bash ./configuration.sh
else
    echo -e "Loading all  pre-existing configuration\nEnter the path of previous installation: "
    read PATH_SAVE
    if [[ -d $PATH_SAVE ]]; then
        echo ""
        cd $PATH_SAVE
        if [[ -f $PATH_SAVE/.env ]]; then
            source .env
            echo "Getting all infos..."
            echo $MAIN_FOLDER_DEPLOY
            echo $MAIN_FOLDER_VOLUME
            echo "You're good to go :)"
        else 
            echo -e "Could not find .env file in $PATH_SAVE\nPlease run configuration script" 
            exit 1
        fi
    else
        echo -e "Could not find $PATH_SAVE\nPlease run configuration script" 
        echo "Not a valid path"
    fi
fi
}
configure_app_first_time(){
    echo -e "NOTE:\nYou MUST get all args EQUAL to GITHUB" 
    echo "Project Name"
    read MAIN_APP_NAME
    echo "Projects HTTPS with '.git' statement in final"
    read GIT_HTTPS

}
confirm(){

    echo $MAIN_APP_NAME
    echo $GIT_HTTPS
    MAIN_FOLDER_DEPLOY_APP=$MAIN_FOLDER_DEPLOY/$MAIN_APP_NAME
    MAIN_FOLDER_VOLUME_APP=$MAIN_FOLDER_VOLUME/$MAIN_APP_NAME
}
ask_config_new_app(){
echo "Would you like to configure a app for the first?"
read ANSWER
if [[ $ANSWER = 'n' ]]; then
    echo "Thanks for using!"
else
    configure_app_first_time
fi
}
###################################################
#################    MAIN      ####################
###################################################
echo "Docker automated CI/CD is starting..."
ask_first_config
ask_config_new_app
confirm
#!/bin/bash
###################################################
#############    FUNCTIONS      ###################
###################################################
#Function ask's variables to user
ask(){
    echo -e "Starting to configure cicd-docker...\nPlease enter with:" 
    echo "- Path where to store the configuration file:"
    read PATH_SAVE
    echo -e "\n"
    echo "- Path where all projects will be deployed:"
    read PATH_DEPLOYMENT
    echo -e "\n"
    echo "- Path where all projects will share volume:"
    read PATH_VOLUME
}
#Function cofirm's if variables are correct
confirm(){
    echo "Entered path to SAVE:"
    echo $PATH_SAVE
    echo "Entered path to DEPLOY:"
    echo $PATH_DEPLOYMENT
    echo "Entered path to VOLUME:"
    echo $PATH_VOLUME
}
#Function save's 
save(){
    
    if [[ -d $PATH_SAVE ]]; then
        echo "Path $PATH_SAVE already exists"
    else
        echo "Creating $PATH_SAVE"
        sudo mkdir  -p $PATH_SAVE
    fi

    if [[ -d $PATH_DEPLOYMENT ]]; then
        echo "Path $PATH_DEPLOYMENT already exists"
    else
        echo "Creating $PATH_DEPLOYMENT"
        sudo mkdir  -p $PATH_DEPLOYMENT
    fi
    
    if [[ -d $PATH_VOLUME ]]; then
        echo "Path $PATH_VOLUME already exists"
    else
        echo "Creating $PATH_VOLUME"
        sudo mkdir  -p $PATH_VOLUME
    fi
    echo "Saving configuration file..."
    cd $PATH_SAVE

    echo "MAIN_FOLDER_DEPLOY=$PATH_DEPLOYMENT" >> .env
    echo "MAIN_FOLDER_VOLUME=$PATH_VOLUME" >> .env
}

###################################################
#################    MAIN      ####################
###################################################
echo -e "This installer will be just create a .env file configuration, feel free to edit.
\nWe'll need:\n-Path to save configuration file\n-Path to store all deployment projects\n-Path to save all projects shared volumes" 
echo "Would you like to continue? [y/n]"
read  ANSWER
if [[ $ANSWER = 'y' ]];then
    
    while [[ $ANSWER = 'y' ]] ; do
        ask
        echo "#################################"
        confirm
        echo -e "Somethig is WRONG to continue?\nAll paths will be create if it isn't\n If it's all good procede with [n]"
        read  ANSWER
    done
    save
    echo "Thank you for using!"
else
    echo "Thank you for using!"
    exit 1
fi

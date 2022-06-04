#!/bin/bash


echo "Current Path: $(pwd)"
cd ./docker/scripts/

echo "Chaging to scripts path: $(pwd)"
PATH_SCRIPTS=$(pwd)
cd ../../
echo "Going back to home path of the repository"

echo "Creating scripts..."
echo "Creating first deploy script"
ln -s $PATH_SCRIPTS/entrypoint.sh ./first_deploy.sh 
echo "Creating helper script"
ln -s $PATH_SCRIPTS/entrypoint.sh ./help.sh 

chmod +x ./first_deploy.sh
chmod +x ./help.sh

echo "Use ./help.sh if you need any help"
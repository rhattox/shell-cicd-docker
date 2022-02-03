#!/bin/bash


echo "Path: $(pwd)"
cd ./docker/scripts/

echo "Path: $(pwd)"
PATH_SCRIPTS=$(pwd)
cd ../../
echo "Path: $(pwd)"

ln -s $PATH_SCRIPTS/entrypoint.sh ./first_deploy.sh 

chmod +x ./first_deploy.sh


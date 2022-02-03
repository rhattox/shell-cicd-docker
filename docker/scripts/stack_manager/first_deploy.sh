#!/bin/bash

#   Caminho dos scripts SEPARADO POR UTILIZAÇÃO, cuidado!
PATH_SCRIPTS=/scripts
PATH_CONTAINER_MANAGER=${PATH_SCRIPTS}/container_manager
PATH_STACK_MANAGER=${PATH_SCRIPTS}/stack_manager
PATH_CONFIGS=/configs
source $PATH_CONFIGS/shell_cicd_docker.properties
SCRIPT_COLLUMNS=$1
APP_NAME=$2
GIT_HTTPS=$3
GIT_TAG=$4

test_https(){
    echo "${GIT_HTTPS}" > html.txt
    sed -i 's/\b.git\b//' html.txt
    GIT_HTTPS_CLEAN=$(cat html.txt)
    echo "Testing url: ${GIT_HTTPS_CLEAN}"
    RESPONSE_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "${GIT_HTTPS_CLEAN}")
    rm -f html.txt
    if [[ ${RESPONSE_STATUS} == '200' ]]; then
        echo "URL Exists!"
    else
        echo "URL do not exists!"
        exit 1
    fi
}

test_link_dir(){
    if [[ -d ${DOCKER_APPS}/${APP_NAME} ]]; then
        
        for ((i = 0; i < ${SCRIPT_COLLUMNS}; i++)); do printf "="; done
        echo -e "\n"
        echo -e "Application already exits at: ${DOCKER_APPS}/${APP_NAME}\n Checking in ${DOCKER_STACKS}..."
        echo -e "\n"
        for ((i = 0; i < ${SCRIPT_COLLUMNS}; i++)); do printf "="; done
        
        if [[ -d $DOCKER_STACKS/$APP_NAME-$GIT_TAG ]]; then
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
            echo -e "\n"
            echo -e "Application already exits at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
            echo -e "\n"
            echo -e "Not created! Exiting!"
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
            exit 1
        else
            unlink ${DOCKER_APPS}/${APP_NAME}
            test_dir_app
        fi
    else
        for ((i = 0; i < ${SCRIPT_COLLUMNS}; i++)); do printf "="; done
        echo -e "\n"
        echo -e "Application do not exists at: ${DOCKER_APPS}/${APP_NAME}"
        echo -e "\n"
        for ((i = 0; i < ${SCRIPT_COLLUMNS}; i++)); do printf "="; done

        test_dir_app
    fi    
}

test_dir_app() {
    if [[ -d $DOCKER_STACKS/$APP_NAME-$GIT_TAG ]]; then
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        echo -e "\n"
        echo -e "Application already exits at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        echo -e "\n"
        echo -e "Not created! Exiting!"
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        exit 1
    else
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        echo -e "\n"
        echo -e "Application do not exists, creating home directory at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
        echo -e "\n"

        mkdir -p $DOCKER_STACKS/$APP_NAME-$GIT_TAG
        #
        # FIXME -- create in setup.sh script folder verification and folder creation
        # 
        mkdir -p $DOCKER_APPS
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
        copy_git_source
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    fi
}

copy_git_source() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\n"
    #git clone --branch 0.0.1-SNAPSHOT001   --single-branch --depth 1 https://github.com/bcovies/php_recybem_bndes.git ./php_recybem_bndes-0.0.1-SNAPSHOT001/
    echo "Downloading from: $GIT_HTTPS"
    git clone --branch $GIT_TAG --single-branch --depth 1 $GIT_HTTPS $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    echo "Downloaded git repo sucessfully at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    echo -e "\n"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    create_env

}

create_env() {
    cd $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\n"
    echo -e "Creating .env file at: $DOCKER_STACKS/$APP_NAME-$GIT_TAG"
    if [[ -f ".env" ]]; then
        echo "OPS! File .env already exists changing to .env.backup..."
        echo "be carefull with secrets! READ ./help.sh"
        mv .env .env.backup
    fi
    if [[ -f ".gitignore" ]]; then
        echo ".gitignore exists!! Checking if is OK..."
        GREP_FILES=('entrypoint.sh' 'deploy.sh' 'help.sh' 'logs.sh' 'start.sh' 'status.sh' 'stop.sh' '.env' '.env.secrets')
        for VAR in "${GREP_FILES[@]}"; do
            TEST_GITIGNORE=$(grep -iwR "$VAR" .gitignore)
            if [[ -z $TEST_GITIGNORE ]]; then
                echo "Adicionado: $VAR no .gitignore"
                echo "$VAR" >>.gitignore
            fi
        done
    fi

    echo "APP_NAME=$APP_NAME" >>.env
    echo "DOCKER_VOLUMES_DATA=$DOCKER_VOLUMES_DATA" >>.env
    echo "DOCKER_VOLUMES_CONFIGS=$DOCKER_VOLUMES_CONFIGS" >>.env
    echo "DOCKER_VOLUMES_LOGS=$DOCKER_VOLUMES_LOGS" >>.env
    echo "DOCKER_STACKS=$DOCKER_STACKS" >>.env
    echo "DOCKER_APPS=$DOCKER_APPS" >>.env
    echo "DOCKER_APP_FULL_PATH=$DOCKER_APPS/$APP_NAME" >>.env
    echo -e "\n"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}
create_scripts_cicd_docker() {
    cd $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    mkdir cicdocker
    cp .env ./cicdocker
    cd cicdocker
    cp $PATH_SCRIPTS/entrypoint.sh .
    ln -s entrypoint.sh start.sh
    ln -s entrypoint.sh stop.sh
    ln -s entrypoint.sh status.sh
    ln -s entrypoint.sh logs.sh
    ln -s entrypoint.sh deploy.sh
    ln -s entrypoint.sh help.sh
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\n"
    echo "Created links!"
    echo -e "\n"
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
}

update_permissions() {
    chmod -R 750 $DOCKER_STACKS/$APP_NAME-$GIT_TAG
    chown -R root:docker $DOCKER_STACKS/$APP_NAME-$GIT_TAG
}

entry_screen() {
    echo -e "###################################"
    echo -e "######  FIRST DEPLOY SCRIPT  #####"
    echo -e "##################################"
}

create_link() {
    cd $DOCKER_APPS
    ln -s $DOCKER_STACKS/$APP_NAME-$GIT_TAG $APP_NAME
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo -e "\n"
    echo -e "Created link at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}"
    echo -e "Created link at: ${DOCKER_APPS}/${APP_NAME}"
    echo -e "\n"
    for ((i = 0; i < ${SCRIPT_COLLUMNS}; i++)); do printf "="; done

}

init(){
    entry_screen
    test_https
    test_link_dir
    create_scripts_cicd_docker
    create_link
    update_permissions
}

init
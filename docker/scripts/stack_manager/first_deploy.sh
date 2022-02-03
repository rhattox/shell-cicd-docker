#!/bin/bash

APP_NAME=${1}
GIT_HTTPS=${2}
GIT_TAG=${3}

entry_screen() {
    echo "###################################"
    echo "######  FIRST DEPLOY SCRIPT  #####"
    echo "##################################"
}

load_environment_variables(){
    source /configs/environment.properties
    source /configs/shell_cicd_docker.properties
}

check_vars() {
    echo "Var Checking at $(basename "$0")..."
    echo "CMD: ${CMD} APP_NAME: ${APP_NAME} GIT_HTTPS: ${GIT_HTTPS} GIT_TAG: ${GIT_TAG}"
}

check_https_link(){
    GIT_HTTPS_FILE_NAME="html_link.txt"
    echo "${GIT_HTTPS}" > ${GIT_HTTPS_FILE_NAME}
    sed -i 's/\b.git\b//' ${GIT_HTTPS_FILE_NAME}
    GIT_HTTPS_CLEAN=$(cat ${GIT_HTTPS_FILE_NAME})
    echo "Testing github url: ${GIT_HTTPS_CLEAN}"
    RESPONSE_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "${GIT_HTTPS_CLEAN}")
    rm -f ${GIT_HTTPS_FILE_NAME}
    if [[ ${RESPONSE_STATUS} == '200' ]]; then
        echo "URL response ${RESPONSE_STATUS}!"
    else
        echo "[$(basename "$0")] ERROR: URL response ${RESPONSE_STATUS}!"
        exit 1
    fi
}

test_link_dir(){
    if [[ -d ${DOCKER_APPS}/${APP_NAME} ]]; then
        echo "Application already exits at: ${DOCKER_APPS}/${APP_NAME}!"
        echo "Checking in ${DOCKER_APPS}/${APP_NAME}..."
        if [[ -d ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} ]]; then
            echo "[$(basename "$0")] ERROR: Application already exits at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} !"
            exit 1
        else
            unlink ${DOCKER_APPS}/${APP_NAME}
            test_dir_app
        fi
    else
        echo "Application do not exists at: ${DOCKER_APPS}/${APP_NAME}"
        test_dir_app
    fi    
}

test_dir_app() {
    if [[ -d ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} ]]; then
        echo "[$(basename "$0")] ERROR: Application already exits at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} !"
        exit 1
    else
        echo "Application do not exists, creating home directory at: "
        echo "${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}"
        echo "${DOCKER_APPS}/${APP_NAME}"
        mkdir -p ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
        mkdir -p ${DOCKER_APPS}
        copy_git_source
    fi
}

copy_git_source() {
    # Example
    # git clone --branch 0.0.1-SNAPSHOT001   --single-branch --depth 1 https://github.com/bcovies/php_recybem_bndes.git ./php_recybem_bndes-0.0.1-SNAPSHOT001/
    echo "Downloading from: ${GIT_HTTPS}"
    git clone --branch ${GIT_TAG} --single-branch --depth 1 ${GIT_HTTPS} ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    DIRCOUNT=$(ls -1A ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} | wc -l)
        if [ $DIRCOUNT -eq 0 ]; then
            echo "[$(basename "$0")] ERROR: Application hasn't been downloaded at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} !"
            exit 1
        else
            echo "Downloaded git repo sucessfully at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}"
        fi
    create_env
}

create_env() {
    cd ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    echo "Creating .env file at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}"
    if [[ -f ".env" ]]; then
        echo "[ATTENTION] File .env already exists, changing to .env.backup..."
        echo "--> be carefull with secrets! READ ./help.sh"
        mv .env .env.backup
    fi
    if [[ -f ".gitignore" ]]; then
        echo ".gitignore exists!! Checking if is OK..."
        GREP_FILES=('cicdocker/' '.env' '.env.secrets')
        for LOOP_VAR in "${GREP_FILES[@]}"; do
            TEST_GITIGNORE=$(grep -iwR "${LOOP_VAR}" .gitignore)
            if [[ -z ${TEST_GITIGNORE} ]]; then
                echo "Adicionado: ${LOOP_VAR} no .gitignore"
                echo "${LOOP_VAR}" >>.gitignore
            fi
        done
    else
        echo ".gitignore NOT founded! Creating one..."
        echo "cicdocker/" >> .gitignore
        echo ".env" >> .gitignore
        echo ".env.secrets" >> .gitignore
    fi

    echo "APP_NAME=${APP_NAME}" >>.env
    echo "DOCKER_VOLUMES_DATA=${DOCKER_VOLUMES_DATA}" >>.env
    echo "DOCKER_VOLUMES_CONFIGS=${DOCKER_VOLUMES_CONFIGS}" >>.env
    echo "DOCKER_VOLUMES_LOGS=${DOCKER_VOLUMES_LOGS}" >>.env
    echo "DOCKER_STACKS=${DOCKER_STACKS}" >>.env
    echo "DOCKER_APPS=${DOCKER_APPS}" >>.env
    echo "DOCKER_APP_FULL_PATH=${DOCKER_APPS}/${APP_NAME}" >>.env
}
create_scripts_cicd_docker() {
    cd ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    mkdir cicdocker
    cp .env ./cicdocker
    cd cicdocker
    cp ${PATH_SCRIPTS}/entrypoint.sh .
    ln -s entrypoint.sh start.sh
    ln -s entrypoint.sh stop.sh
    ln -s entrypoint.sh status.sh
    ln -s entrypoint.sh logs.sh
    ln -s entrypoint.sh deploy.sh
    ln -s entrypoint.sh help.sh
    echo "Created links for scripts!!"
}

create_link_app() {
    cd ${DOCKER_APPS}
    ln -s ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} ${APP_NAME}
    echo "Created link at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}"
    echo "Created link at: ${DOCKER_APPS}/${APP_NAME}"
}

update_permissions() {
    chmod -R 750 ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    chown -R root:docker ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
}

init(){
    entry_screen
    load_environment_variables
    check_vars
    check_https_link
    test_link_dir
    create_scripts_cicd_docker
    create_link_app
    update_permissions
}

init
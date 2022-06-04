#!/bin/bash

APP_NAME=${1}
GIT_HTTPS=${2}
GIT_TAG=${3}
GIT_REPO_MODE=${4}

entry_screen() {
    clear
    echo "##################################"
    echo "######  FIRST DEPLOY SCRIPT  #####"
    echo "##################################"
}

load_environment_variables(){
    source /configs/environment.properties
    source /configs/shell_cicd_docker.properties
    source /configs/tput.sh --source-only
}

check_vars() {
    echo "Var Checking at $(basename "$0")..."
    echo "CMD: ${CMD} APP_NAME: ${APP_NAME} GIT_HTTPS: ${GIT_HTTPS} GIT_TAG: ${GIT_TAG} GIT_REPO_MODE:${GIT_REPO_MODE}"
}

check_git_repo_mode() {

    if [[ ${GIT_REPO_MODE} == 'private' ]];then
        check_https_link_private
    else
        echo "publico"
        check_https_link_public
    fi

}

check_https_link_private(){

    git clone --branch ${GIT_TAG} --single-branch --depth 1 ${GIT_HTTPS} /tmp/git-tmp-test > /dev/null 2>&1
    
    DIRCOUNT=$(ls -1A /tmp/git-tmp-test | wc -l)
    if [ $DIRCOUNT -eq 0 ]; then
        set_red
        set_blink
        echo "[$(basename "$0")] ERROR: Invalid URL, check again !!"
        clean_tput
        rm -rf /tmp/git-tmp-test
        exit 1
    else
       set_green; echo "URL response OK!"; clean_tput;
    fi
}

check_https_link_public(){
    GIT_HTTPS_FILE_NAME="html_link.txt"
    echo "${GIT_HTTPS}" > ${GIT_HTTPS_FILE_NAME}
    sed -i 's/\b.git\b//' ${GIT_HTTPS_FILE_NAME}
    GIT_HTTPS_CLEAN=$(cat ${GIT_HTTPS_FILE_NAME})
    echo "------------------------------------------------------------"
    set_yellow; echo "Testing github url: ${GIT_HTTPS_CLEAN}"; clean_tput;
    echo "------------------------------------------------------------"
    RESPONSE_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "${GIT_HTTPS_CLEAN}")
    rm -f ${GIT_HTTPS_FILE_NAME}
    if [[ ${RESPONSE_STATUS} == '200' ]]; then
       set_green; echo "URL response ${RESPONSE_STATUS}! OK!"; clean_tput;
    echo "------------------------------------------------------------"
    else
        set_red
        set_blink
        echo "[$(basename "$0")] ERROR: URL response ${RESPONSE_STATUS}!"
        clean_tput
        echo "------------------------------------------------------------"
        exit 1
    fi
}

check_https_link_public(){
    GIT_HTTPS_FILE_NAME="html_link.txt"
    echo "${GIT_HTTPS}" > ${GIT_HTTPS_FILE_NAME}
    sed -i 's/\b.git\b//' ${GIT_HTTPS_FILE_NAME}
    GIT_HTTPS_CLEAN=$(cat ${GIT_HTTPS_FILE_NAME})
    echo "------------------------------------------------------------"
    set_yellow; echo "Testing github url: ${GIT_HTTPS_CLEAN}"; clean_tput;
    echo "------------------------------------------------------------"
    RESPONSE_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "${GIT_HTTPS_CLEAN}")
    rm -f ${GIT_HTTPS_FILE_NAME}
    if [[ ${RESPONSE_STATUS} == '200' ]]; then
       set_green; echo "URL response ${RESPONSE_STATUS}! OK!"; clean_tput;
    echo "------------------------------------------------------------"
    else
        set_blink
        set_red
        echo "[$(basename "$0")] ERROR: URL response ${RESPONSE_STATUS}!"
        clean_tput
        echo "------------------------------------------------------------"
        exit 1
    fi
}

test_link_dir(){
    if [[ -d ${DOCKER_APPS}/${APP_NAME} ]]; then
        echo "Application already exits at: ${DOCKER_APPS}/${APP_NAME}!!"
        echo "It's OK if you are upgrading deployment tag..."
        echo "------------------------------------------------------------"
        if [[ -d ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} ]]; then
            set_red
            set_blink 
            echo "[$(basename "$0")] ERROR: Application already exits at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}!"
            clean_tput
            echo "There is nothing to do with this args:"
            echo -e "\t${APP_NAME}"
            echo -e "\t${GIT_HTTPS}"
            echo -e "\t${GIT_TAG}"
            echo "------------------------------------------------------------"
            exit 1
        else
            echo "Upgrading version... Removing Link at: ${DOCKER_APPS}/${APP_NAME}"
            echo "------------------------------------------------------------"
            unlink ${DOCKER_APPS}/${APP_NAME}
            test_dir_app
        fi
    else
        echo "Application do not exists at: ${DOCKER_APPS}/${APP_NAME}"
        echo "------------------------------------------------------------"
        test_dir_app
    fi    
}

test_dir_app() {
    if [[ -d ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} ]]; then
        set_red
        set_blink 
        echo "[$(basename "$0")] ERROR: Application already exits at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}!!!"
        clean_tput
        echo "But, there is no link in ${DOCKER_APPS}/${APP_NAME}"
        echo "Creating a new link for this app for you..."
        create_link_app
        exit 1
    else
        create_dirs
        copy_git_source
    fi
}

create_dirs(){
        mkdir -p ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
        mkdir -p ${DOCKER_APPS}
}


copy_git_source() {
    # Example
    # git clone --branch 0.0.1-SNAPSHOT001   --single-branch --depth 1 https://github.com/bcovies/php_recybem_bndes.git ./php_recybem_bndes-0.0.1-SNAPSHOT001/
    echo "Downloading from: ${GIT_HTTPS}"
    echo "------------------------------------------------------------"
    git clone --branch ${GIT_TAG} --single-branch --depth 1 ${GIT_HTTPS} ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} > /dev/null 2>&1
    DIRCOUNT=$(ls -1A ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} | wc -l)
        if [ $DIRCOUNT -eq 0 ]; then
            set_blink
            set_red
            echo "[$(basename "$0")] ERROR: Application hasn't been downloaded at: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} !"
            clean_tput
            exit 1
        else
            echo "Downloaded git repo sucessfully at MAIN PATH: ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}"
            echo "------------------------------------------------------------"
        fi
}

create_env() {
    cd ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    if [[ -f ".env" ]]; then
        set_yellow
        set_blink
        echo "[ATTENTION] File .env already exists, changing to .env.backup..."
        clean_tput
        echo "--> be carefull with secrets! READ ./help.sh"
        echo "------------------------------------------------------------"
        mv .env .env.backup
    fi
    if [[ -f ".gitignore" ]]; then
        set_yellow
        set_blink
        echo "[ATTENTION] File .gitignore exists!! Checking if is OK..."
        clean_tput
        echo "------------------------------------------------------------"
        GREP_FILES=('cicdocker/' '.env' '.env.secrets' '.env.configs/')
        for LOOP_VAR in "${GREP_FILES[@]}"; do
            TEST_GITIGNORE=$(grep -iwR "${LOOP_VAR}" .gitignore)
            if [[ -z ${TEST_GITIGNORE} ]]; then
                echo "Added at .gitignore: ${LOOP_VAR}"
                echo "${LOOP_VAR}" >>.gitignore
            fi
        done
    else
        echo ".gitignore NOT founded! Creating one with '.env' 'cicdocker/' '.env.secrets'"
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
    ln -s entrypoint.sh destroy.sh
}

create_link_app() {
    cd ${DOCKER_APPS}
    ln -s ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG} ${APP_NAME}
    echo "------------------------------------------------------------"
    set_green; echo "Created link at: ${DOCKER_APPS}/${APP_NAME}"; clean_tput;
    echo "------------------------------------------------------------"
}

update_permissions() {
    chmod -R 750 ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    chown -R root:root ${DOCKER_STACKS}/${APP_NAME}-${GIT_TAG}
    echo "Updating permissions..."
}
final_message(){
    echo "You may now run ./deploy at ${DOCKER_APPS}/${APP_NAME}/cicdocker to create directories from volumes!"
    echo "------------------------------------------------------------"
}

init(){
    entry_screen
    load_environment_variables
    check_git_repo_mode
    # check_vars
    test_link_dir
    create_env
    create_scripts_cicd_docker
    create_link_app
    update_permissions
    final_message
}

init
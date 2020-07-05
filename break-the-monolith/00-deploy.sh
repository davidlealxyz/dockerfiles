#!/bin/bash

source ../base_scripts/color_variables.sh

# VAR 
ENV=$1
PROJECTNAME="break-the-monolith"
DOCKERDIR="${PWD}"

function validations(){
    if [[ $ENV == "local" ]]; then
        GITBRANCH="local"
	    COMPOSEFILE="docker-compose-local.yml" 
    elif [[ $ENV == "test" ]]; then
        echo -e "${WARNTAG} Environment ${ENV} has not been set up for project: ${PROJECT}." 
        exit
    elif [[ $ENV == "prod" ]]; then
        echo -e "${WARNTAG} Environment ${ENV} has not been set up for project: ${PROJECT}." 
        exit
    else
        echo -e "${INFOTAG} Please provide for a env as first argument:" 
        echo "  - ${0} [prod - test - local]" 
        exit
    fi
}

function update_source_code(){
    echo -e "${INFOTAG} Updating source path for ${PROJECTNAME}."
    SOURCE=$(grep :/app/ docker-compose-local.yml  | cut -d : -f1 | awk '{print $2}')
    cd $SOURCE
    git reset --hard HEAD
    git pull origin $GITBRANCH
    echo -e "${DONETAG} Updating source path for ${PROJECTNAME}."
}

function restart_containers(){
    cd $DOCKERDIR
    ../base_scripts/dc_restart_containers.sh $ENV all
}

validations
update_source_code
restart_containers

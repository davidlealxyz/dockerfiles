#!/bin/bash
# Description:
# 	this script will rebuild all or specific images for a docker-compose file
# 	it will take the env as first argument 
#
# Changelog:
# 	- 20.10.2019: Script creation

# IMPORTING BASE SCRIPTS
source ~/scripts/base_scripts/color_variables.sh

ENV=$1
CONT_TYPE=$2


function validations() {
        if   [[ $ENV == "prod" ]]; then
                DCFILE="docker-compose-${ENV}.yml"
        elif [[ $ENV == "test" ]]; then
                DCFILE="docker-compose-${ENV}.yml"
        elif [[ $ENV == "local" ]]; then
                DCFILE="docker-compose-${ENV}.yml"
        else
                echo -e "${USAGETAG} ${0} [ env | service ]"
                exit
        fi

        DC="docker-compose -f ${DCFILE}"
}

function check_compose_file() {
        echo -en "${INFOTAG} Checking if ${DCFILE} file exists..."
        if [[ $(find . -maxdepth 1 -type f -name ${DCFILE} | wc -l) -ne 0 ]]; then
                echo -e "${OKTAG}"
        else
                echo -e ${ERRORTAG}
                exit
        fi
}

function ask_to_continue_or_quit() {
        read -p "Are you sure to continue ? [y/n] " -n 1 -r
        echo
        if [[ ${REPLY} == "n" ]]; then
                echo "Bye! Exiting script"
                exit
        elif [[ ${REPLY} == "y" ]]; then
                continue
        else
                echo -e "${INFOTAG} Please press 'y' to preceed or 'n' to cancel."
                exit
        fi
}

function build_all_images() {
        echo -e "${INFOTAG} Building all images."
        ${DC} build                      && \
        echo -e "${DONETAG} Building all images."             || \
        { echo -e "${ERRORTAG} While building images." ; exit; }
}	

function build_specific_images() {
        echo -e "${INFOTAG} Building ${CONT_TYPE} images."
        ${DC} ps | grep ${CONT_TYPE} | awk '{print $1}' | cut -d _ -f2 | xargs -i ${DC} build '{}'    && \
        echo -e "${DONETAG} Building ${CONT_TYPE} images."             || \
        { echo -e "${ERRORTAG} While building images." ; exit; }
}

function build_images() {
        if [[ $CONT_TYPE == ""  ]] || [[ $CONT_TYPE == "all" ]]; then
        	echo -e "${WARNTAG} You are trying to build ALL images."
		ask_to_continue_or_quit
                build_all_images
        else
                build_specific_images
        fi
}	

validations
check_compose_file
build_images

#!/bin/bash
# Description:
# 	This script is made to restestart my docker-compose environments
# 	in all enviroments 
# 	production -> prod  -> docker-compose-prod.yml
# 	test 	   -> test  -> docker-compose-test.yml
# 	local      -> local -> docker-compose-local.yml
# 
# Changelog:
# 	20.10.2019: Script creationg:
#

# IMPORTING BASE SCRIPTS
source ~/scripts/base_scripts/color_variables.sh

# VARIABLES
ENV=$1
CONT_TYPE=$2
DCFILE=""

function check_docker_binaries() {
	~/scripts/base_scripts/docker/check_docker.sh
}

function validations() {
	if   [[ $ENV == "prod" ]]; then
		DCFILE="docker-compose-${ENV}.yml"
	
	elif [[ $ENV == "test" ]]; then
		DCFILE="docker-compose-${ENV}.yml"
	elif [[ $ENV == "local" ]]; then
		DCFILE="docker-compose-${ENV}.yml"
	else
		echo -e "${USAGETAG} ${0} [ env | all - service ]"
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

function stop_all_containers() {
	echo -e "${INFOTAG} Stopping all containers."
	${DC} stop                      && \
	echo -e "${DONETAG} Stopping all containers."             || \
	{ echo -e "${ERRORTAG} While stopping containers." ; exit; }
}

function stop_specific_containers() {
	echo -e "${INFOTAG} Stopping ${CONT_TYPE} containers."
	${DC} ps | grep ${CONT_TYPE} | awk '{print $1}' | xargs -i docker stop '{}'    && \
	echo -e "${DONETAG} Stopping ${CONT_TYPE} containers."             || \
	{ echo -e "${ERRORTAG} While stopping containers." ; exit; }
}

function stop_containers() {
	if [[ $CONT_TYPE == ""  ]] || [[ $CONT_TYPE == "all" ]]; then
		stop_all_containers
	else
		stop_specific_containers
	fi
}

function delete_all_containers() {
	echo -e "${INFOTAG} Deleting all containers."
	${DC} ps -q | xargs -i docker rm '{}'    && \
	echo -e "${DONETAG} All Containers deleted."              || \
	{ echo -e "${ERRORTAG} While deleting containers." ; exit; }
}

function delete_specific_containers() {
	echo -e "${INFOTAG} Deleting ${CONT_TYPE} containers."
	${DC} ps | grep ${CONT_TYPE} | awk '{print $1}' | xargs -i docker rm '{}'    && \
	echo -e "${DONETAG} Deleting ${CONT_TYPE} Containers."              || \
	{ echo -e "${ERRORTAG} While deleting containers." ; exit; }
}

function delete_containers() {
	if [[ $CONT_TYPE == ""  ]] || [[ $CONT_TYPE == "all" ]]; then
		delete_all_containers
	else
		delete_specific_containers
	fi
}

function start_containers() {
	echo -e "${INFOTAG} Starting containers."
	${DC} up -d                     && \
	echo -e "${DONETAG} Starting containres."             || \
	{ echo -e "${ERRORTAG} While starting containers." ; exit; }
}

function check_containers() {
	echo -e "${INFOTAG} Checking if containers are UP."
	CONT_NUM=$(cat ${DCFILE} | grep -E "^  [[:alpha:]]" | wc -l) 
	echo ""
	echo -e "\t - There should be ${CONT_NUM} containers running..." && \
		sleep 1
	
	CONT_NUM=$(cat ${DCFILE} | grep -E "^  [[:alpha:]]" | wc -l) 
	CONT_NUM_DOWN=$(${DC} ps | grep _ | grep ' Exited ' | wc -l)
	CONT_NUM_UP=$(${DC} ps | grep _ | grep ' Up ' | wc -l)

        echo -e "\t - Running containers : ${CONT_NUM_UP}"
        echo -e "\t - Stopped containers : ${CONT_NUM_DOWN}"
	echo ""
        
	if [[ ${CONT_NUM} -eq ${CONT_NUM_UP} ]]; then
                echo -e  "${OKTAG} All containers are running as expected  ${GREENCHECK}"
        else
                echo -e "${ERRORTAG} Running state is NOT good ${REDCROSS}"
        fi
}

#check_docker_binaries
validations
check_compose_file
stop_containers
delete_containers
start_containers
check_containers

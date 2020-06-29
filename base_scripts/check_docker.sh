#!/bin/bash
# Description:
# 	This script will check if docker and docker-compose are installed in the machine.
# 
# Changelog:
# 	- 20.10.2019: Script creation.
#

# IMPORTING BASE SCRIPTS
source ~/scripts/base_scripts/color_variables.sh

function check_docker {
        echo -en "${INFOTAG} Checking docker installation... "
        docker --version &>/dev/null && \
                echo -e "${OKTAG}" || \
                echo -e "${ERRORTAG}"
}

function check_docker_compose {
        echo -en "${INFOTAG} Checking docker-compose installation... "
        docker-compose --version &>/dev/null && \
                echo -e "${OKTAG}" || \
                echo -e "${ERRORTAG}"
}

check_docker
check_docker_compose

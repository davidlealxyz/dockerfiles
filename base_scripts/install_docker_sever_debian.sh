#!/bin/bash

# Description:
# 	Script meant to install docker in Debian 9 (Stretch)
# 	This will install the latest stable version of Docker and Dockercompose
#
# Maintiner:
#   David Leal	
#	Linkedin : www.linkedin.com/in/davidlealxyz
#
# Changelog:
# 	12.04.2019 : Creation date.
#	09.12.2019 : Some documentation comments added :)
#		   : updated docker version
#		   : updated docker-compose version
# 		   : added functionability for debian stretch and buster
#		    
#

source ~/scripts/base_scripts/color_variables.sh

# VERSIONS
DV="5:19.03.5~3-0~debian-$(lsb_release -c | awk '{print $2}')" # Docker version
DCV="1.25.0"			                                       # Docker compose version

## NOTES:
## 	You may find the versions for docker engine and docker compose with the following:
## 	Only after adding the repositoresto the source.lists
## 	Docker engine:
##	$> apt-cache madison docker-ce
##
## 	Docker compose:
##	url: https://github.com/docker/compose/releases
##
## 	This script was based in the official docker installation for debian here:
## 	https://docs.docker.com/install/linux/docker-ce/debian/
##

function uninstall_old_packages () {
	
	echo -e "${INFOTAG} Uninstalling old packages..."
	apt-get remove -y docker docker-engine docker.io containerd runc && \
		echo -e "${DONETAG} Uninstalling old packages." || \
		echo -e "${WARNTAG} Could not remove old packages."
}

function add_dependencies {
	echo -e "${INFOTAG} Installing dependencies..."
	apt-get update
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common
	echo -e "${DONETAG} Installing dependencies."
}

function add_keys {
	echo -e "${INFOTAG} Adding keys..."
	curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
	apt-key fingerprint 0EBFCD88
	echo -e "${DONETAG} Adding Keys."
}

function add_repository {
	echo -e "${INFOTAG} Adding repository to /etc/apt/source.list..."
	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/debian \
		$(lsb_release -cs) \
		stable"
	echo -e "${DONETAG} Repository added."
}

function install_docker {
	echo -e "${INFOTAG} Installing ${BOLD}Docker CE${NC}..."
	apt-get update
	apt-get install -y docker-ce=${DV} docker-ce-cli=${DV} containerd.io
	usermod -aG docker $(whoami)
	echo -e "${DONETAG} ${BOLD}Docker CE${NC} is installed"

}

function install_docker_compose {
	echo -e "${INFOTAG} Installing ${BOLD}Docker Compose${NC}..."
	curl -s -L "https://github.com/docker/compose/releases/download/${DCV}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	echo -e "${DONETAG} ${BOLD}Docker Compose${NC} is installed."
}

function check_docker {
	echo -e "${INFOTAG} Checking docker installation... "
	docker --version &>/dev/null && \
		echo -e "${OKTAG} Docker V${DV} is working." || \
		echo -e "${ERRORTAG} Docker is not working"
}

function check_docker_compose {
	echo -e "${INFOTAG} Checking docker-compose installation... "
	docker-compose --version &>/dev/null && \
		echo -e "${OKTAG} Docker compose V${DCV} is working." || \
		echo -e "${ERRORTAG} Docker compose is not working"
}

uninstall_old_packages
add_dependencies
add_keys
add_repository
install_docker
install_docker_compose
check_docker
check_docker_compose

echo -e "${INFOTAG} if you are going to use docker with other user you might wanna do this:"
echo "	#> usermod -aG docker username"

#!/bin/bash


# The IP address is the Mac IP Brigde IP Address. 
# Use command:
# 		VBoxManage list bridgedifs
# if you are unsure about the address.

export MacIP="192.168.99.1"

# Look for available Docker Machine.

if [$(docker-machine ls | awk 'FNR == 5 {print $1}') eq ""]
	then
	echo "Docker Machine is not found. Please check if Docker is properly Installed."
	echo "Script will now exit."
	exit 1
fi


# This script works with other Docker Images.
if [ $# -eq 0 ]
  then
	export DockerImage="kristiyanto/guidock"
	else
	export DockerImage=$1
fi

echo launching $DockerImage on $(docker-machine ls | awk 'FNR == 2 {print $1}')
# Script starts here ---
docker-machine start $(docker-machine ls | awk 'FNR == 2 {print $1}')
echo "Launching Socat to bind the X11 services."
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
echo "Launching XQuartz"
open -a xquartz &
eval $(docker-machine env $(docker-machine ls | awk 'FNR == 2 {print $1}'))
docker pull $DockerImage
docker run -ti -e DISPLAY=$MacIP:0 $DockerImage

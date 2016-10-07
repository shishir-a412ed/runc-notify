#!/bin/bash
# This script will test whether sd_notify (systemd notify) is 
# working successfully with runc containers.

# Requires: docker daemon (running), docker client, systemctl.
# Script must be run as a root user.

# Author: Shishir Mahajan <shishir dot mahajan at redhat dot com>

main(){
if [[ "$(id -u)" -ne "0" ]]; then
    echo "runc_sd_notify requires root access. Please try again."
    exit 0
fi

init=$(ps -q 1 -o comm=)
if [ "$init" != "systemd" ];then
    echo "Systemd init system is required to run runc_sd_notify. Skipping test."
    exit 0
fi

if ! systemctl is-active docker >/dev/null; then
     echo "Docker daemon is not running. Skipping test."
     exit 0
fi
trap cleanup EXIT
setup
# Let's not build the image `fed_runc` everytime we run this tool. Why?? 
# (1) docker build process is time consuming. disk is cheap.
# (2) `dnf install` fails sporadically due to fedora repo/mirror not available sometimes.
#      If the mirror is not available it blows up the entire test.
#      Error message: Failed to synchronize cache for repo 'fedora'.
#      Reference: https://bugzilla.redhat.com/show_bug.cgi?id=1257034
imageName=$(docker images --format "{{.Repository}}"|grep fed_runc)
if [ "$imageName" != "fed_runc" ];then
   echo "Building docker image fed_runc"
   docker build -t fed_runc .
else
   echo "docker image fed_runc already exists, skipping docker build"
fi
containerID=$(docker create --name fed_runc_container fed_runc echo)
docker export $containerID|tar -C /tmp/fed-runc/rootfs -xf -
systemctl daemon-reload
systemctl start runc
echo "runc_sd_notify completed successfully"
}

cleanup(){
systemctl stop runc
rm -rf /tmp/fed-runc
rm /etc/system/system/runc.service 2>/dev/null
docker rm fed_runc_container
}

setup(){
if [ -f /etc/systemd/system/runc.service ];then
   echo "/etc/systemd/system/runc.service already exists. Skipping test."
   exit 0
fi
install -m 755 runc.service /etc/systemd/system
mkdir -p /tmp/fed-runc/rootfs
cp config.json /tmp/fed-runc
}

main "$@"

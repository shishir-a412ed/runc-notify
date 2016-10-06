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

}

main "$@"

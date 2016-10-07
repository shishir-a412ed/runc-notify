## runc-notify

`runc-notify` is a tool for testing systemd notify (sd_notify) integration with runc containers.

## Setup

	1) git clone https://github.com/shishir-a412ed/runc-notify.git
	2) cd runc-notify

## Dependencies
    
   To run `runc_notify` you must have the following:

	1) A linux distribution (OS) running systemd as init system.
	2) docker daemon (running).
		To check this execute: `systemctl status docker`.
	3) docker client
	4) runc installed in /usr/local/sbin/runc
                
## Run

    `runc-notify` must be run as a root user.
     1) sudo sh
     2) ./runc_sd_notify.sh

## Author
   Shishir Mahajan, 2016


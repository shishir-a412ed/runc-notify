# Dockerfile for installing required dependencies (gcc, systemd-devel)
# and generating `sd_notify` binary.

FROM fedora
ADD sd_notify.c /home/sd_notify.c
RUN dnf -y install gcc 
RUN dnf -y install systemd-devel
RUN gcc -o /home/sd_notify /home/sd_notify.c -lsystemd

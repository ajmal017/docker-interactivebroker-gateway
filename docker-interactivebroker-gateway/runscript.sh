#!/bin/bash

export TWS_MAJOR_VRSN=974
export IBC_INI=/root/IBController/IBController.ini
export IBC_PATH=/opt/IBController
export TWS_PATH=/root/Jts
export TWS_CONFIG_PATH=/root/Jts
export LOG_PATH=/opt/IBController/Logs
export JAVA_PATH=/opt/i4j_jres/1.8.0_152/bin # JRE is bundled starting with TWS 952
export APP=GATEWAY

xvfb-daemon-run /opt/IBController/Scripts/DisplayBannerAndLaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::4001 onto 0.0.0.0:4003"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001

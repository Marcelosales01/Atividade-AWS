#!/bin/bash

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SERVICE="httpd"
STATUS=$(systemctl is-active $SERVICE)
MESSAGE=""

if [ "$STATUS" = "active" ]; then
    MESSAGE="ONLINE"
    echo "$TIMESTAMP - $SERVICE - $STATUS - $MESSAGE" >> /mnt/nfs/marcelo/online.log
else
    MESSAGE="OFFLINE"
    echo "$TIMESTAMP - $SERVICE - $STATUS - $MESSAGE" >> /mnt/nfs/marcelo/offline.log
fi


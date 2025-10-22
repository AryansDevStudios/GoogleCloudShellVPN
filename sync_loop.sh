#!/bin/bash

cd /home/friendlysmpp
INTERVAL=300  # seconds

while true; do
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - Starting sync"
    git add .
    git commit -m "Auto-sync $(date '+%Y-%m-%d %H:%M:%S')"
    git push
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - Sync complete"

    for ((i=INTERVAL; i>0; i--)); do
        printf "\r[INFO] $(date '+%Y-%m-%d %H:%M:%S') - Next sync in %3d seconds..." "$i"
        sleep 1
    done
    echo ""  # ensure newline after countdown
done

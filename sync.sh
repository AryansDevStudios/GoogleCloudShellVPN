#!/bin/bash

echo "[INFO] $(date) - Starting sync"
git add .
git commit -m "Auto-sync $(date '+%Y-%m-%d %H:%M:%S')"
git push
echo "[INFO] $(date) - Sync complete"
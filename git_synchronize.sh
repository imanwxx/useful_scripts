#! /bin/bash
export PATH="usr/bin:/bin:/usr/local/bin"
LOG_FILE = "GIT_CRON.log"
GIT_REPO="/home/wx/c1_pictures/picture"
cd "$GIT_REPO" || exit 1
git add .
git commit -m "auto commit at $(date +'%Y-%m-%d %H:%M:%S')"
git push origin
echo "==============================" >> "$LOG_FILE"
echo "git cron at $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "==============================" >> "$LOG_FILE"

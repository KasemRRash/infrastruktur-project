#!/bin/bash

LOG_DIR="/usr/lib/cgi-bin/rhodes/logs"

while IFS="|" read zeit typ mmsi rest; do
datum=$(echo $zeit | cut -d ' ' -f 1)
LOG_FILE="$LOG_DIR/rhodes_$datum.log"
echo "$zeit|$typ|$mmsi|$rest" >> "$LOG_FILE" #Neue Datei mit Datum entsteht
done

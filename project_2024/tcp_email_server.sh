#!/bin/bash
queue_dir="/data/workuser/email_queue"
mkdir -p "$queue_dir"
while true; do
  ncat -k -l -p 4000  | while IFS= read -r line; do
  if [ -z "$line" ]; then
      continue
    fi
    timestamp=$(date +'%Y%m%d%H%M%S%N')
    echo "$line" > "$queue_dir/$timestamp.txt"
    echo "Erfolgreich bekommen"
  done
done

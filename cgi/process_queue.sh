#!/bin/bash
queue_dir="/data/workuser/email_queue"
processed_dir="/data/workuser/processed_queue"
mkdir -p "$processed_dir"
while true; do
  for file in "$queue_dir"/*.txt; do
    [ -e "$file" ] || continue  
    line=$(cat "$file")
    emailLogin=$(echo "$line" | cut -d',' -f1)
    email_subject=$(echo "$line" | cut -d',' -f2)
    email_body=$(echo "$line" | cut -d',' -f3)
  if bash /data/workuser/send_email.sh "$emailLogin" "$email_subject" "$email_body"; then
      mv "$file" "$processed_dir/"
    else
      echo "Error sending email for file $file" >> /data/workuser/error_log.txt
      mv "$file" "$error_dir/"
    fi
    sleep 0.3
  done
  sleep 1
done

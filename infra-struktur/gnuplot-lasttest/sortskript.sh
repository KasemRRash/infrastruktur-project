#!/bin/bash

log_file="logfile.txt"
output_csv="response_times.csv"

echo "Request Number,Response Time (ms)" > $output_csv

request_number=1

grep "Response time" "$log_file" | while read -r line; do
    response_time=$(echo "$line" | sed -n 's/.*Response time: \([0-9]*\)ms.*/\1/p')

    echo "$request_number,$response_time" >> $output_csv

    ((request_number++))
done

echo "Daten erfolgreich extrahiert und in $output_csv gespeichert."


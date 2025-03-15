#!/usr/bin/env bash

DATA_FILE="data.csv"
OUTPUT_FILE="type_18.csv"
DATUM=$(date)

ZEIT_VORHER=$(date --date="5 minutes ago" +"%Y-%m-%d %H:%M:%S")

> "$OUTPUT_FILE"

sort -t '|' -k3,3 -u "$DATA_FILE" | while IFS='|' read -r timestamp type mmsi speed name longitude latitude unbekannt5 unbekannt6 unbekannt7 unbekannt8 unbekannt9 unbekannt10; do
  if [[ "$timestamp" > "$ZEIT_VORHER" ]] && [[ "$latitude" =~ ^-?[0-9]+\.[0-9]+$ ]] && [[ "$longitude" =~ ^-?[0-9]+\.[0-9]+$ ]]; then

    echo "$timestamp|$mmsi|$longitude|$latitude" >> "$OUTPUT_FILE"
  fi
done < "$DATA_FILE"

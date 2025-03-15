#!/usr/bin/env bash

DATA_FILE="data.csv"
OUTPUT_FILE="aktuell.csv"
DATUM=$(date)

# die letzten 5 Minuten
ZEIT_VORHER=$(date --date="5 minutes ago" +"%Y-%m-%d %H:%M:%S")

# aktuell.csv erstellen
> "$OUTPUT_FILE"

sort -t '|' -k3,3 -u "$DATA_FILE" | while IFS='|' read -r timestamp unbekannt1 mmsi unbekannt2 name unbekannt3 position unbekannt4 longitude latitude grad unbekannt6 unbekannt7 unbekannt8 unbekannt9 unbekannt10; do
  # Prüfen, ob der Zeitstempel in den letzten 5 Minuten liegt
  if [[ "$timestamp" > "$ZEIT_VORHER" ]]; then
    # Formatierte Zeile in die Ausgabedatei schreiben
    echo "$timestamp|$mmsi|$name|$position|$longitude|$latitude|$grad" >> "$OUTPUT_FILE"
  fi
done < "$DATA_FILE"

echo "$DATUM Daten wurden gefiltert und in $OUTPUT_FILE gespeichert."


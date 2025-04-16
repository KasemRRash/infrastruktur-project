#!/bin/bash

last_received_id=${1:-0}

echo "Content-type: application/json"
echo ""

source db_config.sh

SQL_QUERY="
SELECT ships.mmsi, ships.ship_name, positions.latitude, positions.longitude, positions.timestamp
FROM positions
INNER JOIN ships ON positions.ship_mmsi = ships.mmsi
WHERE positions.id > $last_received_id
ORDER BY positions.id;
"

RESULT=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -B -e "$SQL_QUERY")

RESULT=$(echo "$RESULT" | sed -e '1d')

echo "["

first_record=true
while IFS=$'\t' read -r mmsi ship_name latitude longitude timestamp; do
    # Überprüfe, ob mmsi, latitude und longitude gesetzt sind
    if [ -z "$mmsi" ] || [ -z "$latitude" ] || [ -z "$longitude" ]; then
        continue
    fi

    if [ "$first_record" = false ]; then
        echo ","
    fi
    first_record=false

    echo -n "  {"
    echo -n "\"mmsi\": \"$mmsi\","
    echo -n "\"ship_name\": \"$ship_name\","
    echo -n "\"latitude\": $latitude,"
    echo -n "\"longitude\": $longitude,"
    echo -n "\"timestamp\": \"$timestamp\""
    echo -n "}"
done <<< "$RESULT"

# JSON-Ausgabe beenden
echo
echo "]"

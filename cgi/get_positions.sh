#!/bin/bash
last_received_id=${1:-0}
echo "Content-type: application/json"
echo ""
source db_config.sh
SQL_QUERY="
SELECT p.id, s.mmsi, s.ship_name, p.latitude, p.longitude, p.timestamp
FROM positions p
INNER JOIN ships s ON p.ship_mmsi = s.mmsi
WHERE p.ship_mmsi IN (
    SELECT DISTINCT p2.ship_mmsi
    FROM positions p2
    WHERE p2.timestamp >= NOW() - INTERVAL 5 MINUTE
)
AND p.timestamp >= NOW() - INTERVAL 1 HOUR
AND p.id > $last_received_id
ORDER BY p.id;

"
RESULT=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -B -e "$SQL_QUERY")
if [ -z "$RESULT" ]; then
    echo "[]"
    exit 0
fi

RESULT=$(echo "$RESULT" | sed -e '1d')
echo "["
first_record=true
while IFS=$'\t' read -r id mmsi ship_name latitude longitude timestamp; do
    if [ -z "$mmsi" ] || [ -z "$latitude" ] || [ -z "$longitude" ]; then
        continue
    fi
    if [ "$first_record" = false ]; then
        echo ","
    fi
    first_record=false
    echo -n "  {"
    echo -n "\"id\": \"$id\","
    echo -n "\"mmsi\": \"$mmsi\","
    echo -n "\"ship_name\": \"$ship_name\","
    echo -n "\"latitude\": $latitude,"
    echo -n "\"longitude\": $longitude,"
    echo -n "\"timestamp\": \"$timestamp\""
    echo -n "}"
done <<< "$RESULT"
echo
echo "]"

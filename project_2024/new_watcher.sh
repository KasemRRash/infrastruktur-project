#!/usr/bin/env bash

rhodescheck=$(cat /usr/lib/cgi-bin/project_2024/rhodes-last.txt)
rhodesvergleich=$(wc -l < /usr/lib/cgi-bin/project_2024/data.csv)
if test "$rhodescheck" -eq "$rhodesvergleich" ; then
  kill "$(cat /usr/lib/cgi-bin/project_2024/rhodes.pid)" &>/dev/null
  nohup ncat -e /usr/lib/cgi-bin/project_2024/readwrite.sh rhodes 8082 &>/dev/null &
  echo "$!" > /usr/lib/cgi-bin/project_2024/rhodes.pid
fi
echo "$rhodesvergleich" > /usr/lib/cgi-bin/project_2024/rhodes-last.txt

source /usr/lib/cgi-bin/project_2024/db_config.sh
CSV_FILE="/usr/lib/cgi-bin/project_2024/data.csv"
TEMP_FILE="/usr/lib/cgi-bin/project_2024/temp_data.csv"

while true; do

    if [ -s "$CSV_FILE" ]; then
        while IFS="|" read -r timestamp typ mmsi spalte4 ship_name spalte6 spalte7 spalte8 longitude latitude spalte11 spalte12 spalte13 spalte14 spalte15 spalte16 spalte17
        do
            if [[ "$typ" == "1" || "$typ" == "3" ]]; then
                EXISTING_SHIP=$(mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -D "$DB_NAME" -se "SELECT COUNT(*) FROM ships WHERE mmsi='$mmsi';")
                if [[ "$EXISTING_SHIP" -eq 0 ]]; then
                    SQL_QUERY_SHIP="INSERT INTO ships (mmsi, timestamp, ship_name) VALUES ('$mmsi', '$timestamp', '$ship_name');"
                else
                    SQL_QUERY_SHIP="UPDATE ships SET timestamp='$timestamp', ship_name='$ship_name' WHERE mmsi='$mmsi';"
                fi
                mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "$DB_NAME" -e "$SQL_QUERY_SHIP"
                SQL_QUERY_POSITION="INSERT INTO positions (ship_mmsi, latitude, longitude, timestamp) VALUES ('$mmsi', '$latitude', '$longitude', '$timestamp');"
                mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "$DB_NAME" -e "$SQL_QUERY_POSITION"

            # Verarbeitung für Schiffstyp 18
            elif [[ "$typ" == "18" ]]; then
                latitude=$spalte5
                longitude=$spalte4
                EXISTING_SHIP=$(mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -D "$DB_NAME" -se "SELECT COUNT(*) FROM ships WHERE mmsi='$mmsi';")
                if [[ "$EXISTING_SHIP" -eq 0 ]]; then
                    SQL_QUERY_SHIP="INSERT INTO ships (mmsi, timestamp, ship_name) VALUES ('$mmsi', '$timestamp', '');"
                else
                    SQL_QUERY_SHIP="UPDATE ships SET timestamp='$timestamp' WHERE mmsi='$mmsi';"
                fi
                mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "$DB_NAME" -e "$SQL_QUERY_SHIP"
                SQL_QUERY_POSITION="INSERT INTO positions (ship_mmsi, latitude, longitude, timestamp) VALUES ('$mmsi', '$latitude', '$longitude', '$timestamp');"
                mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "$DB_NAME" -e "$SQL_QUERY_POSITION"
            fi
            tail -n +2 "$CSV_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$CSV_FILE"
        done < "$CSV_FILE"
    else
        sleep 5
        mariadb -u $DB_USER -p$DB_PASS -h $DB_HOST $DB_NAME -e "
        DELETE FROM positions WHERE timestamp < NOW() - INTERVAL 7 DAY;
        "
    fi

done


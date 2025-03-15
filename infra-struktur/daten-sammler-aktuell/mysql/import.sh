#!/bin/bash


CSV_FILE="/home/kasrashrash/daten-sammler-aktuell/aktuell.csv"
TABLE_NAME="Schiffsdaten"


mariadb -e "
LOAD DATA LOCAL INFILE '$CSV_FILE'
INTO TABLE $TABLE_NAME
FIELDS TERMINATED BY '|'
OPTIONALLY ENCLOSED BY ''
LINES TERMINATED BY '\n'
(timestamp, mmsi, name, position, longitude, latitude);
"

echo "Daten aus $CSV_FILE wurden in die Tabelle $TABLE_NAME importiert."








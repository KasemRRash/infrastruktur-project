#!/bin/bash

while true; do

    # Warten auf endskript2.sh
    while [ ! -f ./endskript2.sh ]; do
        sleep 1
    done


    # endskript2.sh ausführen
    ./endskript2.sh &> /dev/null &


    sleep 1


    while [ ! -f ./import.sh ]; do
      sleep 1
    done


    # Import-Skript im mysql-Verzeichnis ausführen
    ./import.sh &> /dev/null &


    sleep 1
  
    while [ ! -f ./mysql-tabell-neu.sh ]; do
      sleep 1
    done

    # MySQL-Tabellen-Skript ausführen
    ./mysql-tabell-neu.sh &> /dev/null &


    sleep 1

    # Warten auf Abschluss aller parallel laufenden Skripte
    wait


    # Pause, bevor der nächste Durchlauf beginnt
    sleep 5

done


#!/usr/bin/env bash

while true; do

    while [ ! -f ./endskript_mmsi_only.sh ]; do
        sleep 1
    done

    ./endskript_mmsi_only.sh &> /dev/null &
    mmsi_pid=$!

    wait

    while [ ! -f ./endskript_type_1_3.sh ]; do
        sleep 1
    done

    ./endskript_type_1_3.sh &> /dev/null &
    type_13_pid=$!


    wait

    while [ ! -f ./endskript_type_18 ]; do
      sleep 1
    done

    wait

    ./endskript_type_18.sh &> /dev/null &

    type_18_pid=$!

    wait

    while ps -p $mmsi_pid > /dev/null && ps -p $type_13_pid > /dev/null && ps -p $type_18_pid > /dev/null; do
        sleep 5
    done

    if ! ps -p $mmsi_pid > /dev/null; then
        echo "ncat-Prozess gestoppt, starte neu..." > /dev/null
    fi

    if ! ps -p $type_13_pid > /dev/null; then
        echo "endskript2.sh-Prozess gestoppt, starte neu..." > /dev/null
    fi

    if ! ps -p $type_18_pid > /dev/null; then
        echo "import.sh-Prozess gestoppt, starte neu..." > /dev/null
    fi

    sleep 10

done &

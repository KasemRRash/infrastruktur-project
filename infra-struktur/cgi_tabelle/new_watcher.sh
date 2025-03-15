#!/usr/bin/env bash

# Überprüfe, ob benötigte Dateien existieren
if [ ! -f rhodes-last.txt ] || [ ! -f data.csv ] || [ ! -f rhodes.pid ]; then
    echo "Eine oder mehrere benötigte Dateien fehlen."
    exit 1
fi

# Lese und vergleiche die Zeilenzahlen
rhodescheck=$(cat rhodes-last.txt | tr -d '[:space:]')
rhodesvergleich=$(wc -l < data.csv | tr -d '[:space:]')

if [ "$rhodescheck" -eq "$rhodesvergleich" ]; then
    # Überprüfen und beenden des Prozesses, falls er läuft
    if kill -0 $(cat rhodes.pid) &>/dev/null; then
        kill $(cat rhodes.pid) &>/dev/null
    fi

    # Starte neue Prozesse im Hintergrund
    ncat rhodes 8082 -e ./readwrite.sh &
    ncat_pid=$!
    bash ./loadships.sh &
    loadships_pid=$!

    # Speichern der PID
    echo "$ncat_pid" > rhodes.pid
fi

# Aktualisiere den Vergleichswert
echo "$rhodesvergleich" > rhodes-last.txt


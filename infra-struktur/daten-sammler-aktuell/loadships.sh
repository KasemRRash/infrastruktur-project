#!/bin/bash

# Output Header
echo "Content-Type: text/plain"
echo ""

# Hier wird das eigentliche Skript ausgeführt
cd /home/kasrashrash/daten-sammler-aktuell/ && ./endskript2.sh
cd /home/kasrashrash/daten-sammler-aktuell/mysql/ && ./import.sh
cd /html/kasrashrash/mysql-tabelle && ./mysql-tabelle.sh

# Rückmeldung
echo "Skript erfolgreich ausgeführt"

date > report.log

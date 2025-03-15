#!/usr/bin/env bash

# Datenbank-Zugangsdaten

# HTML-Dateipfad
HTML_FILE="/var/www/html/docker-kasrashrash-web/data.html"

# Temporäre Datei für die SQL-Abfrage
TEMP_HTML_FILE="temp.html"

# Aktuelle Zeit minus 5 Minuten
TIME_INTERVAL=$(date -u +"%Y-%m-%d %H:%M:%S" -d "5 minutes ago")

# MySQL-Befehl ausführen und HTML-Zeilen in eine temporäre Datei speichern
mariadb --skip-column-names -e "
SELECT CONCAT(
    '<tr><td>', timestamp, '</td><td>', mmsi, '</td><td>', name, '</td><td>', position, '</td><td>', longitude, '</td><td>', latitude, '</td></tr>'
) AS html_row
FROM Schiffsdaten
WHERE timestamp >= '$TIME_INTERVAL'
ORDER BY timestamp DESC
" > "$TEMP_HTML_FILE"

# HTML-Datei erstellen oder überschreiben
{
    echo "<!DOCTYPE html>"
    echo "<html lang=\"en\">"
    echo "<head>"
    echo "    <meta charset=\"UTF-8\">"
    echo "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">"
    echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "    <title>Schiffsdaten</title>"
    echo "    <link rel=\"stylesheet\" href=\"tabelle.css\">"
    echo "</head>"
    echo "<body>"
    echo "    <table>"
    echo "        <thead>"
    echo "            <tr>"
    echo "                <th>Timestamp</th>"
    echo "                <th>MMSI</th>"
    echo "                <th>Name</th>"
    echo "                <th>Position</th>"
    echo "                <th>Longitude</th>"
    echo "                <th>Latitude</th>"
    echo "            </tr>"
    echo "        </thead>"
    echo "        <tbody>"
    cat "$TEMP_HTML_FILE"
    echo "        </tbody>"
    echo "    </table>"
    echo "</body>"
    echo "</html>"
} > "$HTML_FILE"

# Temporäre Datei löschen
rm "$TEMP_HTML_FILE"

# Bestätigung ausgeben
echo "HTML-Datei wurde erstellt: $HTML_FILE"

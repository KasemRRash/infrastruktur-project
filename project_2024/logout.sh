#!/bin/bash

echo "Content-Type: text/plain"
echo ""

cookieline=$(echo "$HTTP_COOKIE" | tr ";" "\n" | grep "^session_id=")
session_id=$(echo "$cookieline" | cut -d "=" -f 2)


if [ -n "$session_id" ]; then
    source db_config.sh

    # Session aus der Datenbank löschen
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
    DELETE FROM sessions WHERE session_id = '$session_id';
    "

    if [ $? -eq 0 ]; then
        echo "Set-Cookie: session_id=; Path=/docker-infra-2024-l-web/project_2024/; Expires=Thu, 01 Jan 1970 00:00:00 GMT; HttpOnly"
        echo "Abmeldung erfolgreich"
    else
        echo "Fehler beim Loeschen der Session."
    fi
else
    echo "Fehler: Keine gueltige Sitzung gefunden."
fi


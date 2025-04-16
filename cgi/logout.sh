#!/bin/bash

echo "Content-type: application/json"
echo ""

source db_config.sh

parse_cookies() {
    local cookies="$1"
    IFS=';' read -r -a pairs <<< "$cookies"
    for pair in "${pairs[@]}"; do
        IFS='=' read -r key value <<< "$pair"
        key=$(echo "$key" | sed 's/ //g')
        eval "$key=\"$value\""
    done
}

cookies="$HTTP_COOKIE"
parse_cookies "$cookies"

if [ -n "$session_id" ]; then
    # Lösche die Session aus der Datenbank
    delete_session=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
    DELETE FROM sessions WHERE session_id='$session_id';
    ")

    if [ $? -eq 0 ]; then
        echo "Set-Cookie: session_id=deleted; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT"
        echo '{"status":"success", "message":"Logout erfolgreich"}'
    else
        echo '{"status":"error", "message":"Fehler beim Löschen der Session"}'
    fi
else
    echo '{"status":"error", "message":"Keine gültige Session gefunden"}'
fi


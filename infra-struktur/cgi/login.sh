#!/bin/bash

echo "Content-type: application/json"
source db_config.sh

generate_session_id() {
    echo $(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9')
}

parse_query_string() {
    local query="$1"
    local key_value
    IFS='&' read -r -a pairs <<< "$query"
    for pair in "${pairs[@]}"; do
        IFS='=' read -r key value <<< "$pair"
        key=$(echo "$key" | sed 's/%20/ /g' | sed 's/+/ /g')
        value=$(echo "$value" | sed 's/%20/ /g' | sed 's/+/ /g' | sed 's/%40/@/g')
        eval "$key=\"$value\""
    done
}

QUERY_STRING=$(echo "$QUERY_STRING")
parse_query_string "$QUERY_STRING"

password_hash=$(echo -n "$passwordLogin" | sha256sum | awk '{print $1}')

result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
SELECT id, firstname FROM users WHERE email='$emailLogin' AND password='$password_hash';
")

if [ "$result" ]; then
    session_id=$(generate_session_id)
    user_id=$(echo $result | awk '{print $1}')
    insert_session=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
    INSERT INTO sessions (session_id, user_id) VALUES ('$session_id', '$user_id');
    ")

    if [ $? -eq 0 ]; then
        echo "Set-Cookie: session_id=$session_id; Path=/; HttpOnly"
        echo ""
        echo '{"status":"success"}'
    else
        echo ""
        echo '{"status":"error", "message":"Fehler bei der Erstellung der Sitzung"}'
    fi
else
    echo ""
    echo '{"status":"error", "message":"Fehler bei der Anmeldung"}'
fi


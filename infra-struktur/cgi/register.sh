#!/bin/bash

echo "Content-type: application/json"
echo ""
source db_config.sh

parse_query_string(){
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
password_hash=$(echo -n "$password" | sha256sum | awk '{print $1}')

insert_result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
INSERT INTO users (firstname, lastname, email, password, phone)
VALUES ('$firstname', '$lastname', '$email', '$password_hash', '$phonenumber');
" 2>&1)

if [ $? -eq 0 ]; then
    echo '{"status":"success", "message":"Registrierung erfolgreich"}'
else
    echo '{"status":"error", "message":"Fehler bei der Registrierung", "mysql_error":"'"$insert_result"'"}'
fi


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

session_result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
SELECT user_id FROM sessions WHERE session_id='$session_id';
")

if [ "$session_result" ]; then
    user_id=$session_result
    echo '{"status":"success", "user_id":"'$user_id'"}'
else
    echo '{"status":"error", "message":"Nicht angemeldet"}'
fi


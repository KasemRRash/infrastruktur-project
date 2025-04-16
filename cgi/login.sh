#!/bin/bash

echo "Content-Type: text/plain"
source db_config.sh

IFS='&' read -r -a pairs <<< "$QUERY_STRING"
for pair in "${pairs[@]}"; do
    IFS='=' read -r key value <<< "$pair"
    key=$(echo "$key" | sed 's/%20/ /g' | sed 's/+/ /g')
    value=$(echo "$value" | sed 's/%20/ /g' | sed 's/+/ /g' | sed 's/%40/@/g')

    case $key in
        emailLogin) emailLogin=$value ;;
        passwordLogin) passwordLogin=$value ;;
    esac
done

password_hash=$(echo -n "$passwordLogin" | sha256sum | sed 's/ .*//')
result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
SELECT id, firstname FROM users WHERE email='$emailLogin' AND password='$password_hash';
")

if [ "$result" ]; then
  user_id=$(echo $result | sed 's/\([0-9]*\).*/\1/' )
  session_id=$(pwgen 40 1)

    insert_session=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
    INSERT INTO sessions (session_id, user_id) VALUES ('$session_id', '$user_id');
    ")

    if [ $? -eq 0 ]; then
        echo "Set-Cookie: session_id=$session_id; Path=/docker-infra-2024-l-web/; HttpOnly"
        echo ""
        email_subject="HEllo_from_there-:)"
        email_body="User $emailLogin hat sich erfolgreich angemeldet."
        echo -e "$emailLogin, $email_subject, $email_body" | ncat localhost 4000
        echo "Login erfolgreich"
    else
        echo ""
        echo "Fehler bei der Erstellung der Sitzung"
    fi
else
    echo ""
    echo "Fehler bei der Anmeldung"
fi

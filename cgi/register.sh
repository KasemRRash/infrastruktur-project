#!/bin/bash

echo "Content-type: text/plain"
echo ""
source db_config.sh
IFS='&' read -r -a pairs <<< "$QUERY_STRING"
for pair in "${pairs[@]}"; do
    IFS='=' read -r key value <<< "$pair"
    key=$(echo "$key" | sed 's/%20/ /g' | sed 's/+/ /g')
    value=$(echo "$value" | sed 's/%20/ /g' | sed 's/+/ /g' | sed 's/%40/@/g')

    case $key in
        firstname) firstname=$value ;;
        lastname) lastname=$value ;;
        email) email=$value ;;
        password) password=$value ;;
        phonenumber) phonenumber=$value ;;
    esac
done
password_hash=$(echo -n "$password" | sha256sum | sed 's/ .*//')
insert_result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -sse "
INSERT INTO users (firstname, lastname, email, password, phone)
VALUES ('$firstname', '$lastname', '$email', '$password_hash', '$phonenumber');
" 2>&1)

if [ $? -eq 0 ]; then
    echo "success: Registrierung abgeschlossen"
else
    echo "error: Fehler bei der Registrierung - $insert_result"
fi

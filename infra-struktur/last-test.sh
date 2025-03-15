#!/bin/bash

# Anzahl der parallelen Anfragen
num_requests=100
# URL der Login-Seite (stellen Sie sicher, dass diese URL korrekt ist)
url="http://informatik.hs-bremerhaven.de/docker-infra-2024-l-web/cgi-bin/project_2024/login.sh"

# Login-Daten
email="ahmad@gmail.com"
password="1111"

echo "Starting login load test with $num_requests parallel requests to $url"

# Funktion zum Senden einer Login-Anfrage und Messen der Antwortzeit
send_login_request() {
    start_time=$(date +%s%3N)
    response=$(curl -s -L -w "%{http_code}" -o response_body.txt "$url?emailLogin=$email&passwordLogin=$password")
    end_time=$(date +%s%3N)
    response_time=$((end_time - start_time))
    http_code=$(tail -n1 <<< "$response")
    response_body=$(<response_body.txt)
    echo "Response code: ${http_code}, Response time: ${response_time}ms, Response body: ${response_body}"
}

# Schleife zur Erstellung der Hintergrundprozesse
for ((i=1; i<=$num_requests; i++))
do
    send_login_request &
done

# Warten, bis alle Hintergrundprozesse abgeschlossen sind
wait

echo "Login load test completed."


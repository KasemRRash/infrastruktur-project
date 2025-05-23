#!/bin/bash

num_requests=400
url="http://localhost:8080/login.sh"

email="kasem@gmail.com"
password="12345"

echo "Starting login load test with $num_requests parallel requests to $url"

send_login_request() {
    start_time=$(date +%s%3N)
    response=$(curl -s -L -w "%{http_code}" -o response_body.txt "$url?emailLogin=$email&passwordLogin=$password")
    end_time=$(date +%s%3N)
    response_time=$((end_time - start_time))
    http_code=$(tail -n1 <<< "$response")
    response_body=$(<response_body.txt)
    echo "Response code: ${http_code}, Response time: ${response_time}ms, Response body: ${response_body}"
}

for ((i=1; i<=$num_requests; i++))
do
    send_login_request &
done

wait

echo "Login load test completed."

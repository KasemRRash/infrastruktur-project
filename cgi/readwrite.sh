#!/usr/bin/env bash

while read -r line; do
    echo "$line" >> /usr/lib/cgi-bin/project_2024/data.csv
done


#!/usr/bin/env bash

rhodescheck=$(cat rhodes-last.txt)
rhodesvergleich=$(wc -l < data.csv)

if test "$rhodescheck" -eq "$rhodesvergleich" ; then
kill $(cat rhodes.pid) &>/dev/null
ncat -e ./readwrite.sh rhodes 8082 &
echo "$!" > rhodes.pid

fi

echo "$rhodesvergleich" > rhodes-last.txt

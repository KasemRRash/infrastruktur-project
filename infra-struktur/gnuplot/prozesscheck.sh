#!/bin/bash

LOG_FILE="/usr/lib/cgi-bin/rhodes/logs/rhodes_$(date "+%Y-%m-%d").log"
SKRIPT="/usr/lib/cgi-bin/rhodes/datensammeln.sh"
PID_FILE="/usr/lib/cgi-bin/rhodes/pid.txt"
TIME=$(date "+%H%M")

if test -z "$(ps -ef | grep "ncat --recv-only rhodes 8082 -e $SKRIPT" | grep -v grep)"; then
  #echo "Läuft nicht" #wenn in der Liste aller Prozesse "ncat" nicht steht, für die suche wird der grepBefehl(grep ncat...) mit grep -v grep ausgeschlossen --> läuft der Prozess nicht. -z zeigt, dass die Zeichenkette bei 0 ist
  nohup ncat --recv-only rhodes 8082 -e $SKRIPT > stdout.log 2> stderr.log & #-> nCat verbindung soll neu gestartet werden (komische Nohup-Medlung soll an standart error gesendet werden)
  echo $! > "$PID_FILE"
fi

if test -f "$LOG_FILE"; then
   TIME_FILE=$(tail -n 1 "$LOG_FILE" | cut -d "|" -f 1 | cut -d " " -f 2 | sed "s/://g" | cut -c 1-4) #Letzte Zeile aus dem $LOG_FILE , erste Spalte rausgenommen, zweite Spalte auch, : für Leerzeichen ersetzt,
   if test "$TIME_FILE" -lt "$TIME"; then #Die Zeit vom letzten Schiff ist kleiner als die von die jetzt-Zeit
     #echo "Logfiledatum ist kleiner"
     if test -f "$PID_FILE"; then #-f = Datei existiert oder nicht
       PID=$(cat "$PID_FILE")
       kill $PID
       rm "$PID_FILE"
     fi
     nohup ncat --recv-only rhodes 8082 -e $SKRIPT > stdout.log 2> stderr.log & #Datensammlung wird gestartet und die nohup-Meldung wird an stdout.log und stderr geschickt
und läuft im Hintegrund
     echo $! > "$PID_FILE" #Prozess-ID wird unter $PID_File gespeichert
   fi
 else
  # echo "Logfile nicht vorhanden"
   nohup ncat --recv-only rhodes 8082 -e $SKRIPT > stdout.log 2> stderr.log &
   echo $! > "$PID_FILE"
fi

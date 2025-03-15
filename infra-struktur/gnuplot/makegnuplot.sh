#!/bin/bash

echo "Content-Type: text/html"
echo

DATUM=$(echo "$QUERY_STRING" | sed 's/^date=//g')
LOG_FILE="/usr/lib/cgi-bin/rhodes/logs/rhodes_$DATUM.log"
ERG_FILE="/usr/lib/cgi-bin/rhodes/anzahl_pro_stunde.dat"

if test -s "$LOG_FILE"; then #-s = existiert und ist größer als Null
  STUNDE=$(cat "$LOG_FILE" | cut -d '|' -f 1 | cut -d ' ' -f 2 | cut -d ':' -f 1 | sort | uniq)
 #nimmt LOG_FIle, sucht hier nur die Stunde raus, und überschreibt diese bei Änderungen in ERG_File durch einfaches >
 > $ERG_FILE # entleert .dat-Datei, damit der Überschrieben werden kann
for i in $STUNDE; do
  anzahlSchiffe=$(grep "$i:" "$LOG_FILE" | cut -d '|' -f 3 | sort | uniq | wc -l) #Anzahl der Schiffe: in Log-Datei nach der MMSI(<dritte Spalte suchen), sortieren, sodass Doppelungen untereinander stehen und diese mit uniq löschen. Dann die ANzahl der Zeilen(lines) ist die ANzahl der Schiffe
  echo "$i:00 $anzahlSchiffe" >> "$ERG_FILE" # Uhrzeit und ANzahl der Schiffe in .dat-Datei
done

OUTPUT_FILE="/usr/lib/cgi-bin/images/schiffsmeldungen.png"

gnuplot -e "set terminal pngcairo size 800,600 font 'Verdana,12';set output '$OUTPUT_FILE';set title 'Anzahl der Schiffe pro Stunde';set xlabel 'Uhrzeit';set ylabel 'Anzahl der Schiffe';set xdata time ;set timefmt '%H:%M';set format x '%H:%M';set xtics nomirror;set grid;plot '$ERG_FILE' using 1:2 with linespoints title 'Gesamtanzahl Schiffe'"

echo "<!DOCTYPE>
      <html>
      <head>
      <meta charset='utf-8'>
      <title> AIS-Daten | Team 04 </title>
      <link rel='stylesheet' type='text/css' href='https://informatik.hs-bremerhaven.de/docker-step2023-team-04-web/css/teamdesign.css'>
      </head>
      <header>
      <nav>
        <ul>
          <li><a href='index.sh'>Home</a></li>
          <li><a href='ais_aisdaten.sh'>AIS-Daten</a></li>
          <li><a href='ts_login.sh'>Ticketsystem</a></li>
          <li><a href='about.sh'>Über uns</a></li>
        </ul>
       </header>
      <body>
        <h1> Schiffe auslesen </h1>
        <img src='https://informatik.hs-bremerhaven.de/docker-step2023-team-04-web/images/schiffsmeldungen.png' alt='GNUPLOT'>
       </body>
      </html>"
    else
      echo "<!DOCTYPE>
            <html>
            <head>
            <meta charset='utf-8'>
            <title> AIS-Daten | Team 04 </title>
            <link rel='stylesheet' type='text/css' href='https://informatik.hs-bremerhaven.de/docker-step2023-team-04-web/css/teamdesign.css'>
            </head>
            <header>
            <nav>
               <ul>
                 <li><a href='index.sh'>Home</a></li>
                 <li><a href='ais_aisdaten.sh'>AIS-Daten</a></li>
                 <li><a href='ts_login.sh'>Ticketsystem</a></li>
                 <li><a href='about.sh'>Über uns</a></li>
               </ul>
             </header>
           <body>
          <h1> Schiffe auslesen </h1>
           <p> Keine Datensätze für den ausgewählten Tag vorhanden </p>
           </body>
           </html>"
fi

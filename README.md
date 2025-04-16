## Infra-Rhodes

Infra-Rhodes ist eine Webanwendung zur Anzeige und Analyse von Schiffsbewegungen mithilfe empfangener AIS-Daten. Ziel des Projekts war es, reale Schiffspositionen auf einer Live-Karte darzustellen, in Tabellenform auszuwerten und automatisiert in einer Datenbank zu pflegen.

Die Anwendung ermöglicht:
- die Visualisierung von Echtzeit-Schiffspositionen auf einer interaktiven Karte
- eine tabellarische Auflistung und Filterung der empfangenen Daten
- automatische Datenpflege über Cronjobs und Bash-Skripte

## Technologien

| Bereich         | Tools                                           |
|----------------|--------------------------------------------------|
| **Frontend**    | HTML, CSS, JavaScript, [Leaflet.js](https://leafletjs.com) |
| **Backend**     | Bash-Skripte, Cronjobs                          |
| **Datenhaltung**| MariaDB                                         |

## Funktionen

- 🌍 Live-Karte mit Leaflet.js  
- 🛥️ Popup-Schiffsinfos direkt auf der Karte  
- 📊 Filterbare Tabelle mit Schiffsdetails  
- 🔄 Automatische Datenaktualisierung   
- 🗄️ Datenbankintegration zur strukturierten Speicherung  

Dieses Projekt wurde im Rahmen eines Hochschulprojekts entwickelt und diente der Analyse realer Schiffsbewegungen mithilfe öffentlich zugänglicher AIS-Daten.

## Verzeichnisstruktur 

<details> <summary><strong>📁 Projektstruktur anzeigen</strong></summary>
.
├── deploy.sh
├── deploy_local.sh
├── README.md
├── cgi/
│   ├── data.csv
│   ├── db_config.sh
│   ├── delete_from_db.sh
│   ├── get_positions.sh
│   ├── login.sh
│   ├── logout.sh
│   ├── new_watcher.sh
│   ├── process_queue.sh
│   ├── readwrite.sh
│   ├── register.sh
│   ├── rhodes-last.txt
│   ├── rhodes.pid
│   ├── send_email.sh
│   ├── sent_emails.txt
│   └── tcp_email_server.sh
├── db/
│   └── initdata.sql
├── gnuplot-lasttest/
│   ├── last-test.sh
│   ├── logfile.txt
│   ├── new_gnuplot.gp
│   ├── response.gp
│   ├── response_body.txt
│   ├── response_times.gp
│   ├── response_times_plot.png
│   └── sortskript.sh
└── www/
    ├── index.html
    ├── script.js
    ├── style.css
    └── map/
        ├── map-index.html
        ├── map-scropt.js
        ├── map-style.css
        └── test-data.csv


</details>


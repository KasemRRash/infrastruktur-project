// Initialisiere die Karte und setze den Startpunkt auf Bremerhaven mit Zoom-Level 12
var map = L.map('map').setView([53.550507, 8.585815], 12);

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);

// Variable zum Speichern der Schiffmarker (Standorte)
var shipMarkers = {};

// Funktion zum Parsen von CSV-Daten
function parseCSV(csvData) {
    const lines = csvData.split('\n');
    const result = [];

    for (let i = 0; i < lines.length; i++) {
        const currentline = lines[i].split('|');
        result.push(currentline);
    }

    return result;
}

// Funktion zum Laden der Schiffsdaten aus der CSV-Datei
function loadShipData() {
    var xhr = new XMLHttpRequest();
    // datei name muss angepasst werden
    xhr.open('GET', 'data.csv', true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var csvText = xhr.responseText;
            var shipData = parseCSV(csvText);
            displayShipsOnMap(shipData); 
        }
    };
    xhr.send();
}

// Schiffe laden und auf der Karte anzeigen
loadShipData();

// Aktualisiere die Schiffsdaten alle 3 Sekunden
setInterval(loadShipData, 3000);






// Funktion zum Anzeigen der Schiffe auf der Karte
function displayShipsOnMap(shipData) {
    shipData.forEach(ship => {
        // Korrektes Auslesen der Koordinaten aus der 5. und 6. Spalte
        const lon = parseFloat(ship[4]); 
        const lat = parseFloat(ship[5]); 
        const mmsi = ship[1]; // 2. Spalte für MMSI

        // Überprüfen, ob die Koordinaten gültig sind
        if (!isNaN(lat) && !isNaN(lon)) {
            if (shipMarkers[mmsi]) {
                shipMarkers[mmsi].setLatLng([lat, lon]);
            } else {
                var marker = L.marker([lat, lon]).addTo(map);
                marker.bindPopup("MMSI: " + mmsi);
                shipMarkers[mmsi] = marker;
            }
        } else {
            // Wenn die Koordinaten ngültig sind soll eine error n console angezeigt werden  
            console.error(`Ungültige Koordinaten für MMSI: ${mmsi}`);
        }
    });
}



/*
 sollen wir so machen 
    wen man auf ein von die schiffe klickt soll eine tabele angezeigt werden 
    mit schief daten wie  länge name gewicht oder keine ahnung 
    */




// icon 








//name die schiffe 


//----------------------------------------------------
// Leaflet-Karte initialisieren
var map = L.map('map').setView([53.550507, 8.585815], 12);

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);
//----------------------------------------------------








// Funktion, um Koordinaten anzuzeigen, wo man klickt
var popup = L.popup();

function onMapClick(e) {
    popup
        .setLatLng(e.latlng)
        .setContent(e.latlng.toString())
        .openOn(map);
}
map.on('click', onMapClick);






// Variable zum Speichern der Schiffmarker(stanort)
var shipMarkers = {};


// ICON für Schiffe -------- Jungs wenn ich habe einfach ein bild aus internet genommen 
var shipIcon = L.icon({
    iconUrl: 'icon.png',
    iconSize: [32, 32], // Größe 
    iconAnchor: [16, 16], // Punkt im Icon, der die Position markiert (z.B. Mitte des Icons)
    popupAnchor: [0, -16] // Punkt im Icon, an dem sich das Popup öffnet
});// Es fehlt noch die Richtung des Schiffs.




// Funktion zum Parsen von CSV-Daten
function parseCSV(csvData) {
    const lines = csvData.split('\n');
    const headers = lines[0].split(',');
    const result = [];

    for (let i = 1; i < lines.length; i++) {
        const obj = {};
        const currentline = lines[i].split(',');

        for (let j = 0; j < headers.length; j++) {
            obj[headers[j]] = currentline[j];
        }
        result.push(obj);
    }

    return result;
}






// Funktion zum Laden der Schiffsdaten aus der CSV-Datei
function loadShipData() {
    // Speichere den aktuellen Zoom-Level und die Mitte der Karte
    const currentZoom = map.getZoom();
    const currentCenter = map.getCenter();

    fetch('test-data.csv')
        .then(response => response.text())
        .then(csvText => {
            const shipData = parseCSV(csvText);
            console.log('Geladene Schiffsdaten:', shipData);
            displayShipsOnMap(shipData); // Zeige die Schiffe auf der Karte an
            
            // Stelle den Zoom-Level und die Mitte der Karte wieder her
            map.setView(currentCenter, currentZoom);
        })
        .catch(error => console.error('Fehler beim Laden der Schiffsdaten:', error));
}

// Funktion zum Anzeigen der Schiffe auf der Karte
function displayShipsOnMap(shipData) {
    console.log('Anzeigen von Schiffsmarkern:', shipData.length, 'Schiffe');
    shipData.forEach(ship => {
        console.log('Verarbeite Schiff mit MMSI:', ship.mmsi);
        if (ship.lat && ship.lon) {
            const lat = parseFloat(ship.lat);
            const lon = parseFloat(ship.lon);
            const heading = parseFloat(ship.heading);

            if (shipMarkers[ship.mmsi]) {
                shipMarkers[ship.mmsi].setLatLng([lat, lon]);
                shipMarkers[ship.mmsi].setRotationAngle(heading);
            } else {
                var marker = L.marker([lat, lon], {
                    icon: shipIcon,
                    rotationAngle: heading // Dreht das Icon basierend auf dem Heading
                }).addTo(map);
                marker.bindPopup("MMSI: " + ship.mmsi);
                shipMarkers[ship.mmsi] = marker;
            }
        }
    });
}

// Schiffe laden und auf der Karte anzeigen
loadShipData();

// Aktualisiere die Schiffsdaten alle 3 Sekunden
setInterval(loadShipData, 3000);


document.addEventListener('DOMContentLoaded', function() {
    const dataTable = document.getElementById('data-table');
    const loadShipsBtn = document.getElementById('load-ships-btn');

    function fetchData() {
        // Zeitstempel anhängen, um Caching zu vermeiden
        const url = '/docker-kasrashrash-web/data.html?t=' + new Date().getTime();

        fetch(url) // Stelle sicher, dass dieser Pfad korrekt ist
            .then(response => response.text())
            .then(html => {
                dataTable.innerHTML = html; // Ersetze die Tabelle mit den neuen Daten
            })
            .catch(error => {
                console.error('Fehler beim Laden der Daten:', error);
            });
    }

    loadShipsBtn.addEventListener('click', function() {
        loadShipsBtn.disabled = true;
        loadShipsBtn.textContent = "Aktualisiere...";

        // Skript ausführen, um die data.html neu zu generieren
        fetch('/docker-kasrashrash-web/cgi-bin/daten-sammler-aktuell/loadships.sh', {
            method: 'POST',
        })
        .then(response => response.text())
        .then(data => {
            console.log('Script wurde erfolgreich ausgeführt:', data);

            // Kleine Verzögerung einfügen, um sicherzustellen, dass die Datei vollständig generiert ist
            setTimeout(fetchData, 200); // 200 ms Verzögerung

            loadShipsBtn.disabled = false;
            loadShipsBtn.textContent = "Daten aktualisieren";
        })
        .catch(error => {
            console.error('Fehler beim Ausführen des Skripts:', error);
            loadShipsBtn.disabled = false;
            loadShipsBtn.textContent = "Daten aktualisieren";
        });
    });

    // Initiales Laden der Daten
    fetchData();
});

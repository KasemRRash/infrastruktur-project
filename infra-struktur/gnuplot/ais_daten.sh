#!/usr/bin/env bash

echo "Content-Type: text/html"
echo

echo "<!DOCTYPE html>
      <html>
      <head>
      <meta charset='utf-8'>
      <title> AIS-Daten | Team 04 </title>
      </head>
      <body>
       <header>
        <nav>
          <ul>
            <li><a href='index.sh'>Home</a></li>
            <li><a href='about.sh'>Über uns</a></li>
          </ul>
        </nav>
        </header>

        <main>
        <form action='/usr/lib/cgi-bin/gnuplot/makegnuplot.sh' method='get'>
        <h1> Schiffe auslesen </h1>
       <img src="l" width="200" height="200" alt="Funktioniert nicht"><br>
          <label for="date">Datum eingeben:</label>
          <input type='date' name='date'>
          <input type='submit' value='Diagramm erstellen'>
         </form>
          <footer>
           <small>
            Bild unter Creative Commons CC0 veröffentlicht, Copyright <a href='svgsilh.com'>svghsilh.com</a> all rights reserved
           </small>
          </footer>
      </body>
    </html>
"

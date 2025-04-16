create table Schiffsdaten_2 (
  timestamp DATETIME,
  mmsi INT,
  name VARCHAR(255),
  position VARCHAR(255),
  longitude FLOAT,
  latitude FLOAT,
);

create table Position (
 timestamp DATETIME,
 mmsi INT,
 position VARCHAR(255),
 longitude FLOAT,
 latitude FLOAT,
); 

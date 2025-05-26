-- Active: 1748142729050@@127.0.0.1@5432@conservation_db

-- ranger table 
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50)
);

--species table 
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50) NOT NULL
);




--sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER NOT NULL,
    species_id INTEGER NOT NULL,
    sighting_time TIMESTAMP,
    location VARCHAR(50) NOT NULL,
    notes TEXT,

    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),  
    FOREIGN KEY (species_id) REFERENCES species(species_id)
);



--  Problem 1 
INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains')


-- Problem 2 
SELECT COUNT(DISTINCT species_id) FROM sightings 


-- Problem 3   
SELECT * FROM sightings 
 WHERE location LIKE '%Pass%'

-- Problem 4 
SELECT r.name, count(*) AS total_sightings FROM rangers r
  JOIN sightings  s ON  s.ranger_id = r.ranger_id  
  GROUP BY r.name

--  Problem 5 
SELECT common_name FROM species s
  LEFT  JOIN sightings si ON si.species_id = s.species_id 
  WHERE si.sighting_id IS NULL;

-- Problem 6 
SELECT  s.common_name , si.sighting_time, r.name FROM sightings si 
 JOIN species s ON s.species_id = si.species_id
 JOIN rangers r ON r.ranger_id = si.ranger_id 
 ORDER BY si.sighting_time DESC LIMIT 2

-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

 
-- Problem 8 

SELECT 
 sighting_id ,
 CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN  'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) >= 12 AND EXTRACT( HOUR FROM sighting_time) < 17 THEN  'Afternoon'
    ELSE  
    'Evening'
 END 

 FROM sightings


-- Problem 9 

DELETE FROM rangers 
WHERE ranger_id IN (SELECT r.ranger_id FROM rangers r
LEFT JOIN sightings s ON s.ranger_id = r.ranger_id 
WHERE s.sighting_id is NULL)


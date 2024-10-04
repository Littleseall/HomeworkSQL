CREATE TABLE Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Albums (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT
);

CREATE TABLE Tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration INTERVAL NOT NULL,
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES Albums(id)
);

CREATE TABLE Artist_Genre (
    artist_id INT,
    genre_id INT,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES Artists(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

CREATE TABLE Album_Artist (
    album_id INT,
    artist_id INT,
    PRIMARY KEY (album_id, artist_id),
    FOREIGN KEY (album_id) REFERENCES Albums(id),
    FOREIGN KEY (artist_id) REFERENCES Artists(id)
);

CREATE TABLE Collection (
    id SERIAL PRIMARY KEY,
    release_year INT NOT NULL,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE Tracks_Collection (
    collection_id INT,
    tracks_id INT,
    PRIMARY KEY (collection_id, tracks_id),
    FOREIGN KEY (collection_id) REFERENCES Collection(id),
    FOREIGN KEY (tracks_id) REFERENCES Tracks(id)
);

--Задание 1:

INSERT INTO Genres (name) VALUES 
('Pop'), 
('Rock'), 
('Metal');

INSERT INTO Artists (name) VALUES 
('Maroon'), 
('Linkin Park'), 
('System of a Down'), 
('Nightwish');

INSERT INTO Albums (title, release_year) VALUES 
('Jordi', 2021), 
('One More Light', 2017), 
('Hypnotize', 2005),
('Wishmaster', 2000),
('Human.:II:Nature', 2020);

INSERT INTO Tracks (title, duration, album_id) VALUES 
('Lost', '00:02:52', 1),
('Memories', '00:03:09', 1),
('One More Light', '00:04:15', 2),
('Talking to Myself', '00:03:51', 2),
('Lonely Day', '00:02:47', 3),
('Wishmaster', '00:04:24', 4),
('Noise', '00:05:40', 5);

INSERT INTO Artist_Genre (artist_id, genre_id) VALUES 
(1, 1), 
(1, 2),
(2, 2), 
(2, 3), 
(3, 3), 
(4, 3);

INSERT INTO Album_Artist (album_id, artist_id) VALUES 
(1, 1), 
(2, 2),  
(3, 3),  
(4, 4),
(5, 4);

INSERT INTO Collection (release_year, title) VALUES 
(2018, 'Collection One'), 
(2019, 'Collection Two'), 
(2020, 'Collection Three'), 
(2023, 'Collection Four');

INSERT INTO Tracks_Collection (collection_id, tracks_id) VALUES 
(1, 1), 
(1, 3),  
(1, 5),  
(2, 2),  
(2, 4),  
(3, 6),  
(4, 5)

--Задание 2:

SELECT title, duration
FROM Tracks
ORDER BY duration DESC
LIMIT 1;

SELECT title
FROM Tracks
WHERE duration >= '00:03:30';

SELECT title
FROM Collection
WHERE release_year BETWEEN 2018 AND 2020;

SELECT name
FROM Artists
WHERE name NOT LIKE '% %';

SELECT title
FROM Tracks
WHERE title LIKE '%My%';

--Задание 3:

SELECT Genres.name, COUNT(Artist_Genre.artist_id)
   FROM Genres
   LEFT JOIN Artist_Genre ON genres.id = Artist_Genre.genre_id
   GROUP BY genres.name;
  
SELECT COUNT(tracks.id) AS track_count
   FROM Tracks
   JOIN Albums ON tracks.album_id = albums.id
   WHERE albums.release_year BETWEEN 2019 AND 2020;
   
SELECT 
    albums.title AS a_title,
    DATE_TRUNC('minute', AVG(tracks.duration)) + 
    (AVG(tracks.duration) - DATE_TRUNC('minute', AVG(tracks.duration)))
FROM Albums
JOIN Tracks ON albums.id = tracks.album_id
GROUP BY albums.title;

SELECT DISTINCT artists.name
   FROM Artists
   LEFT JOIN Album_Artist ON artists.id = Album_Artist.artist_id
   LEFT JOIN Albums ON Album_Artist.album_id = Albums.id AND Albums.release_year = 2020
   WHERE Albums.id IS NULL;
  
SELECT Collection.title
   FROM Collection
   JOIN Tracks_Collection ON Collection.id = Tracks_Collection.collection_id
   JOIN Tracks ON Tracks_Collection.tracks_id = tracks.id
   JOIN Album_Artist ON tracks.album_id = Album_Artist.album_id
   JOIN Artists ON Album_Artist.artist_id = Artists.id
   WHERE Artists.name = 'Linkin Park';
  
--Задание 4
  
SELECT albums.title
FROM Albums
JOIN Album_Artist ON albums.id = Album_Artist.album_id
JOIN Artist_Genre ON Album_Artist.artist_id = Artist_Genre.artist_id
GROUP BY albums.title
HAVING COUNT(DISTINCT Artist_Genre.genre_id) > 1;
  
SELECT tracks.title
FROM Tracks
LEFT JOIN Tracks_Collection ON tracks.id = Tracks_Collection.tracks_id
WHERE Tracks_Collection.collection_id IS NULL;

SELECT artists.name
FROM Artists
JOIN Tracks ON artists.id = (
    SELECT Album_Artist.artist_id
    FROM Album_Artist
    WHERE Album_Artist.album_id = tracks.album_id
    LIMIT 1)
WHERE tracks.duration = (
    SELECT MIN(duration)
    FROM Tracks);

WITH album_small AS (
    SELECT album_id, COUNT(*) AS tc
    FROM Tracks
    GROUP BY album_id)
SELECT albums.title
FROM Albums
JOIN album_small ON albums.id = album_small.album_id
WHERE album_small.tc = (SELECT MIN(tc) FROM album_small);

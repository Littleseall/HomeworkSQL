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
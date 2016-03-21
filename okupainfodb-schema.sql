drop database if exists okupadb;
create database okupadb;

use okupadb;

CREATE TABLE users (
    id BINARY(16) NOT NULL,
    loginid VARCHAR(15) NOT NULL UNIQUE,
    password BINARY(16) NOT NULL,
	email VARCHAR(255) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
	description VARCHAR(512) NOT NULL,
	localization VARCHAR(264),
    PRIMARY KEY (id)
);

CREATE TABLE coordinates(
	point_id INT(11) NOT NULL AUTO_INCREMENT,
	latitud DOUBLE DEFAULT 0,
	longitud DOUBLE DEFAULT 0,
	PRIMARY KEY (point_id)
);

CREATE TABLE gps(
	point_id INT(11) NOT NULL AUTO_INCREMENT,
	gps POINT DEFAULT NULL,
	PRIMARY KEY (point_id)
) 	ENGINE=INNODB;

CREATE TABLE user_roles (
    userid BINARY(16) NOT NULL,
    role ENUM ('creador', 'usuario'),
    FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
    PRIMARY KEY (userid, role)
);

CREATE TABLE events (
	id BINARY(16) NOT NULL,
	creatorid BINARY(16) NOT NULL,
    title VARCHAR(100) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
	participantes VARCHAR(1000),
    last_modified TIMESTAMP NOT NULL,
	valoracion VARCHAR(100),
	localization VARCHAR(264)NOT NULL,
    creation_timestamp DATETIME not null default current_timestamp,
);


/*CREATE TABLE tipo(
	id BINARY(16) NOT NULL,
	tipo VARCHAR(50)NOR NULL,
);*/

/*CREATE TABLE asistencia(
	eventoid BINARY(16) NOT NULL,
	confirmacion BOOLEAN NOT NULL,
)



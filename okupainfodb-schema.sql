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
	asistencia VARCHAR(512), /* Eventos a los que se ha apuntado el usuario*/
	PRIMARY KEY (id)
);

CREATE TABLE casals(
	id BINARY(16) NOT NULL,
	loginid VARCHAR(15) NOT NULL UNIQUE,
	password BINARY(16) NOT NULL,
	email VARCHAR(255) NOT NULL,
	fullname VARCHAR(255) NOT NULL,
	description VARCHAR(512) NOT NULL,
	valoracion FLOAT (16) NOT NULL, /* Positiva o Negativa según las votaciones*/
	localization VARCHAR(264) NOT NULL, /*Donde se encuentra el casal (Pasaremos la dirección a la API de Google Maps que nos devolvera las coordenadas*/
	latitud DOUBLE DEFAULT 0,
	longitud DOUBLE DEFAULT 0,
	eventos VARCHAR(512) NOT NULL,/* Eventos que ha creado el casal*/
	PRIMARY KEY (id)
);

CREATE TABLE events (
	id BINARY(16) NOT NULL,
	creatorid BINARY(16) NOT NULL,
 	title VARCHAR(100) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	descripcion VARCHAR(500) NOT NULL,
	participantes VARCHAR(1000),
	valoracion VARCHAR(100),
	localization VARCHAR(264)NOT NULL,
	latitud DOUBLE DEFAULT 0,
	longitud DOUBLE DEFAULT 0,
	last_modified TIMESTAMP NOT NULL,
  	creation_timestamp DATETIME not null default current_timestamp,
   	PRIMARY KEY (id)
);


CREATE TABLE auth_tokens (
	userid BINARY(16) NOT NULL,
	token BINARY(16) NOT NULL,
	FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
	PRIMARY KEY (token)
);

CREATE TABLE user_roles (
	userid BINARY(16) NOT NULL,
	role ENUM ('creador', 'usuario'),
	FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
	PRIMARY KEY (userid, role)
);

CREATE TABLE casals_events(
	casalid BINARY(16) NOT NULL,
	eventoid BINARY(16) NOT NULL,
	FOREIGN KEY (casalid) REFERENCES casals(id),
	FOREIGN KEY (eventoid) REFERENCES events(id),
	PRIMARY KEY (casalid, eventoid)
);

CREATE TABLE users_events(
 	userid BINARY(16) NOT NULL,
	eventoid BINARY(16) NOT NULL,
	FOREIGN KEY (userid) REFERENCES users(id),
	FOREIGN KEY (eventoid) REFERENCES events(id),
	PRIMARY KEY (userid, eventoid)
);

CREATE TABLE comments_casals (
 	id BINARY(16) NOT NULL,
	creatorid BINARY(16) NOT NULL,
	casalid BINARY (16) NOT NULL,
	content VARCHAR(512) NOT NULL,
	creation_timestamp DATETIME not null default current_timestamp,
	FOREIGN KEY (casalid) REFERENCES casals(id),
	FOREIGN KEY (creatorid) REFERENCES users(id),
	PRIMARY KEY(id)
);

CREATE TABLE comments_events (
	id BINARY(16) NOT NULL,
	creatorid BINARY(16) NOT NULL,
	eventoid BINARY(16) NOT NULL,
	content VARCHAR(512) NOT NULL,
	creation_timestamp DATETIME not null default current_timestamp,
	FOREIGN KEY (creatorid) REFERENCES users(id),
	FOREIGN KEY (eventoid) REFERENCES events(id),
 	PRIMARY KEY(id)
);


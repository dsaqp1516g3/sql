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
	PRIMARY KEY (id)
);

CREATE TABLE events (
	id BINARY(16) NOT NULL,
	creatorid BINARY(16) NOT NULL,
 	title VARCHAR(100) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	descripcion VARCHAR(500) NOT NULL,
	valoracion VARCHAR(100),
	localization VARCHAR(264)NOT NULL,
	latitud DOUBLE DEFAULT 0,
	longitud DOUBLE DEFAULT 0,
	last_modified TIMESTAMP NOT NULL,
  	creation_timestamp DATETIME not null default current_timestamp,
  	FOREIGN KEY (creatorid) REFERENCES casals(id),
  	PRIMARY KEY (id)
);

CREATE TABLE auth_tokens (
	userid BINARY(16) NOT NULL,
	token BINARY(16) NOT NULL,
	FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
	PRIMARY KEY (token)
);

/*CREATE TABLE auth_tokensc (
  casalid BINARY(16) NOT NULL,
  token BINARY(16) NOT NULL,
  FOREIGN KEY (casalid) REFERENCES casals(id) on delete cascade,
  PRIMARY KEY (token)
);

CREATE TABLE casals_roles (
	casalid BINARY(16) NOT NULL,
	role ENUM ('admin', 'casal'),
	FOREIGN KEY (casalid) REFERENCES casals(id) on delete cascade,
	PRIMARY KEY (casalid,role)
);*///Provisional a modo de prueba

CREATE TABLE user_roles (
	userid BINARY(16) NOT NULL,
	role ENUM ('admin', 'registered'),
	FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
	PRIMARY KEY (userid,role)
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

insert into users (id, loginid, password, email, fullname, description) values (UNHEX(REPLACE(UUID(),'-','')), 'okupa', UNHEX(MD5('okupa')), 'okupa@info.com', 'okupainfo','okupa principal');
select @userid:=id from users where loginid = 'okupa';
insert into user_roles (userid, role) values (@userid, 'registered');

insert into casals (id, loginid, password, email, fullname, description, valoracion, localization, latitud, longitud) values (UNHEX(REPLACE(UUID(),'-','')), 'casal', UNHEX(MD5('casal')), 'casal@casal.com','supercasal', 'casal per a joves', +10, 'carrer antic', 32, 2);

select @creatorid:=id from casals where loginid = 'casal';
insert into events (id, creatorid, title, tipo, descripcion, valoracion, localization, latitud, longitud, last_modified, creation_timestamp) values (UNHEX(REPLACE(UUID(),'-','')), @creatorid, 'quedada','barbacoa','mengem amb el amics',-1, 'carrer nou',42,1, '0000-00-00 00:00:00','NOW');

select @userid:=id from users where loginid = 'okupa';
select @eventoid:=id from events where title = 'quedada';
insert into users_events(userid, eventoid) values(@userid, @eventoid);

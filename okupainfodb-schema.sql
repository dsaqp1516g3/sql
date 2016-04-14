drop database if exists okupadb;
create database okupadb;

use okupadb;

CREATE TABLE users (
 	id BINARY(16) NOT NULL,
	loginid VARCHAR(15) NOT NULL UNIQUE,
	password BINARY(16) NOT NULL,
	email VARCHAR(255) NOT NULL,
	fullname VARCHAR(255) NOT NULL,
	description VARCHAR(512),
	PRIMARY KEY (id)
);

CREATE TABLE casals(
	casalsid BINARY(16) NOT NULL,
  adminid  BINARY(16) NOT NULL,
	localization VARCHAR(264) NOT NULL, /*Donde se encuentra el casal (Pasaremos la dirección a la API de Google Maps que nos devolvera las coordenadas*/
	latitud DOUBLE DEFAULT 0,
	longitud DOUBLE DEFAULT 0,
  validado BOOLEAN NOT NULL DEFAULT FALSE,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(512),
  FOREIGN KEY (adminid) REFERENCES users(id),
	PRIMARY KEY (casalsid)
);

CREATE TABLE valoraciones_casals(
  userid BINARY(16) NOT NULL,
  casalsid BINARY(16) NOT NULL,
  valoracion BOOLEAN NOT NULL,
  FOREIGN KEY (userid) REFERENCES users(id),
  FOREIGN KEY (casalsid) REFERENCES casals(casalsid),
  PRIMARY KEY (userid,casalsid)
);

CREATE TABLE events (
	id BINARY(16) NOT NULL,
	casalsid BINARY(16) NOT NULL,
 	title VARCHAR(100) NOT NULL,
	descripcion VARCHAR(500) NOT NULL,
	localization VARCHAR(264)NOT NULL,
	latitud DOUBLE DEFAULT 0,
	longitud DOUBLE DEFAULT 0,
	last_modified TIMESTAMP NOT NULL,
	creation_timestamp DATETIME not null default current_timestamp,
  FOREIGN KEY (casalsid) REFERENCES casals(casalsid),
  PRIMARY KEY (id)
);

CREATE TABLE events_pictures (
  eventid BINARY(16) NOT NULL,
  userid BINARY(16) NOT NULL,
  filename VARCHAR(16) NOT NULL,
  FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
  FOREIGN KEY (eventid) REFERENCES events(id) on delete cascade,
  PRIMARY KEY (eventid,userid)
);

CREATE TABLE users_pictures (
  userid BINARY(16) NOT NULL,
  filename VARCHAR(16) NOT NULL,
  FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
  FOREIGN KEY (eventid) REFERENCES events(id) on delete cascade,
  PR
);

CREATE TABLE auth_tokens (
	userid BINARY(16) NOT NULL,
	token BINARY(16) NOT NULL,
	FOREIGN KEY (userid) REFERENCES users(id) on delete cascade,
	PRIMARY KEY (token)
);

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
	FOREIGN KEY (casalid) REFERENCES casals(casalsid),
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

/*Mirar como crear Sting*/

insert into users (id, loginid, password, email, fullname, description) values (UNHEX(REPLACE(UUID(),'-','')), 'okupa', UNHEX(MD5('1234')), 'okupa@info.com', 'okupainfo','okupa principal');
select @okupaid:=id from users where loginid = 'okupa';
insert into user_roles (userid, role) values (@okupaid, 'registered');

insert into users (id, loginid, password, email, fullname, description) values (UNHEX(REPLACE(UUID(),'-','')), 'spongebob', UNHEX(MD5('1234')), 'spongebob@info.com', 'Bob Esponja','okupa en Fondo Bikini');
select @bobid:=id from users where loginid = 'spongebob';
insert into user_roles (userid, role) values (@bobid, 'registered');

insert into users (id, loginid, password, email, fullname, description) values (UNHEX(REPLACE(UUID(),'-','')), 'admin', UNHEX(MD5('1234')), 'admin@info.com', 'Administrador', null);
select @adminid:=id from users where loginid = 'admin';
insert into user_roles (userid, role) values (@adminid, 'admin');

insert into casals (casalsid, adminid, email, name, description, localization, latitud, longitud) values (UNHEX(REPLACE(UUID(),'-','')), @adminid, 'casal@casal.com', 'Casal Zeus', 'Te sentirás en el Olimpo', 'Passeig de Gràcia, la Dreta de l\'Eixample, Eixample, Barcelona, BCN, Catalonia, 08007, Spain', 41.3897264, 2.1679474);

insert into casals (casalsid, adminid, email, name, description, localization, latitud, longitud, validado) values (UNHEX(REPLACE(UUID(),'-','')), @adminid, 'casal2@casal.com', 'Casal Sex Pistols', 'Anarchy in the UK', 'Avenida de Gràcia, la Dreta de l\'Eixample, Eixample, Barcelona, BCN, Catalonia, 08007, Spain', 41.3942409, 2.158823, true);

select @casalsid:=email from casals where email = 'casal2@casal.com';
insert into events (id, casalsid, title, descripcion, localization, latitud, longitud) values (UNHEX(REPLACE(UUID(),'-','')), @casalsid, 'Kedada fumeta','fumem amb el amics','Avenida de Gràcia, la Dreta de l\'Eixample, Eixample, Barcelona, BCN, Catalonia, 08007, Spain', 41.3942409, 2.158823);

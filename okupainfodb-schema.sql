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
	asistencia VARCHAR(512), /* Eventos a los que se ha apuntado el usuario o puede que no vaya a ninguno*/
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
	eventos VARCHAR(512),/* Eventos que ha creado el casal, puede no haber creado alguno*/
	PRIMARY KEY (id)
);

CREATE TABLE events (
	id BINARY(16) NOT NULL,
	creatorid BINARY(16) NOT NULL,
 	title VARCHAR(100) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	descripcion VARCHAR(500) NOT NULL,
	participantes VARCHAR(1000),/*initialized to null when created*/
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

insert into users (id, loginid, password, email, fullname, description, asistencia) values (UNHEX(REPLACE(UUID(),'-','')), 'okupa', UNHEX(MD5('okupa')), 'okupa@info.com', 'okupainfo','okupa principal', NULL);

select @participantes:=id from users where asistencia = 'quedada';
select @asistencia:=id from events where participantes = 'okupa';
select @eventos:=id from events where creatorid = 'casal';
select @creatorid:=id from casals where loginid = 'casal';

insert into events (id, creatorid, title, tipo, descripcion, participantes, valoracion, localization, latitud, longitud, last_modified, creation_timestamp) values (UNHEX(REPLACE(UUID(),'-','')), @creatorid, 'quedada','barbacoa','mengem amb el amics',NULL,-1, 'carrer nou',42,1, '0000-00-00 00:00:00','NOW');

select @participantes:=id from users where asistencia = 'quedada';
select @asistencia:=id from events where participantes = 'okupa';
select @eventos:=id from events where creatorid = 'casal';
select @creatorid:=id from casals where loginid = 'casal';

insert into casals (id, loginid, password, email, fullname, description, valoracion, localization, latitud, longitud, eventos) values (UNHEX(REPLACE(UUID(),'-','')), 'casal', UNHEX(MD5('casal')), 'casal@casal.com','supercasal', 'casal per a joves', +10, 'carrer antic', 32, 2, NULL);

select @participantes:=id from users where asistencia = 'quedada';
select @asistencia:=id from events where participantes = 'okupa';
select @eventos:=id from events where creatorid = 'casal';
select @creatorid:=id from casals where loginid = 'casal';



/*insert into users (id, loginid, password, email, fullname) values (UNHEX(REPLACE(UUID(),'-','')), 'admin', UNHEX(MD5('admin')), 'admin@admin.com', 'admin1');
select @userid:=id from users where loginid = 'admin';
insert into user_roles (userid, role) values (@userid, 'admin');
insert into users (id, loginid, password, email, fullname) values (UNHEX(REPLACE(UUID(),'-','')), 'user', UNHEX(MD5('user')), 'user@user.com', 'user1');
select @userid:=id from users where loginid = 'user';
insert into user_roles (userid, role) values (@userid, 'registered');
insert into groups(id, name) values (UNHEX(REPLACE(UUID(),'-','')),'unicos');
select @groupid:=id from groups where name = 'unicos';
insert into themes (id, userid, groupid, title, content) values (UNHEX(REPLACE(UUID(),'-','')),@userid,@groupid,'1r tema','Tema super entretenido');*/



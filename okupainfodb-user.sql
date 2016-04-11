drop user 'okupainfo'@'localhost';
create user 'okupainfo'@'localhost' identified by 'okupainfo';
grant all privileges on okupadb.* to 'okupainfo'@'localhost';
flush privileges;

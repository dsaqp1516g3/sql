drop user 'okupainfo'@'localhost';
create user 'okupainfo'@'localhost' identified by 'okupainfo';
grant all privileges on okupainfodb.* to 'okupainfo'@'localhost';
flush privileges;

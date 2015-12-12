CREATE TABLE student
(
	sid		integer,
	name		char(30),
	major		char(30),
	standing	char(30),
	age		integer,
	PRIMARY KEY (sid)
);

CREATE TABLE class
(
	classname	char(30),
	time		char(30),
	room		char(30),
	PRIMARY KEY (classname),
	UNIQUE	(time,room)
);

CREATE TABLE enrolled
(
	sid		integer,
	classname	char(30),
	PRIMARY KEY (sid,classname),
	FOREIGN KEY (sid) REFERENCES student
		ON DELETE CASCADE,
	FOREIGN KEY (classname) REFERENCES class
);

INSERT INTO student (sid,name,major,standing,age) VALUES (051135593,'Maria White','English','SR',21);
INSERT INTO student (sid,name,major,standing,age) VALUES (060839453,'Charles Harris','Architecture','SR',22);
INSERT INTO student (sid,name,major,standing,age) VALUES (099354543,'Susan Martin','Law','JR',20);
INSERT INTO student (sid,name,major,standing,age) VALUES (112348546,'Joseph Thompson','Computer Science','SO',19);
INSERT INTO student (sid,name,major,standing,age) VALUES (115987938,'Christopher Garcia','Computer Science','JR',20);
INSERT INTO student (sid,name,major,standing,age) VALUES (132977562,'Angela Martinez','History','SR',20);
INSERT INTO student (sid,name,major,standing,age) VALUES (269734834,'Thomas Robinson','Psychology','SO',18);
INSERT INTO student (sid,name,major,standing,age) VALUES (280158572,'Margaret Clark','Animal Science','FR',18);

INSERT INTO class (classname,time,room) VALUES ('Data Structures','MWF 10:00-11:00','R128');
INSERT INTO class (classname,time,room) VALUES ('Database Systems','MWF 12:30-1:45','1320 DCL');
INSERT INTO class (classname,time,room) VALUES ('Operating System Design','TuTh 12-1:20','20 AVW');
INSERT INTO class (classname,time,room) VALUES ('Archaeology of the Incas','MWF 3-4:15','R128');

INSERT INTO enrolled (sid,classname) VALUES (051135593,'Data Structures');
INSERT INTO enrolled (sid,classname) VALUES (060839453,'Data Structures');
INSERT INTO enrolled (sid,classname) VALUES (051135593,'Database Systems');
INSERT INTO enrolled (sid,classname) VALUES (060839453,'Database Systems');
INSERT INTO enrolled (sid,classname) VALUES (051135593,'Operating System Design');
INSERT INTO enrolled (sid,classname) VALUES (099354543,'Operating System Design');
INSERT INTO enrolled (sid,classname) VALUES (112348546,'Operating System Design');

INSERT INTO student (sid,name,major,standing,age) VALUES (112348546,'Juan Rodriguez,','Psychology','JR',20);

INSERT INTO class (classname,time,room) VALUES ('Algorithms','MWF 12:30-1:45','1320 DCL');

INSERT INTO enrolled (sid,classname) VALUES (561254634,'Data Structures');
INSERT INTO enrolled (sid,classname) VALUES (051135593,'Communication Networks');

DELETE FROM class c WHERE c.classname = 'Data Structures';
DELETE FROM student s WHERE s.sid = 051135593; 

DROP TABLE enrolled;
DROP TABLE student;
DROP TABLE class;

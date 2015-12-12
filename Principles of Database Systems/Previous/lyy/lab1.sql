
create table student(
		sid int,
		name varchar(20),
		major varchar(40),
		standing varchar(20),
		age int,
		PRIMARY KEY(sid));

create table class(
		course_name varchar(40),
		schedule varchar(40),
		room_number varchar(20),
		PRIMARY KEY(course_name),
		UNIQUE(schedule,room_number));

create table enrolled(
		sid int,
		course_name varchar(40),
		PRIMARY KEY (sid,course_name),
		FOREIGN KEY (sid) REFERENCES student ON DELETE CASCADE,
		FOREIGN KEY (course_name) REFERENCES class);

INSERT INTO student(sid,name,major,standing,age)
VALUES(051135593,'Maria White','English','SR',21);
INSERT INTO student(sid,name,major,standing,age)
VALUES(060839453,'Charles Harris','Architecture','SR',22);
INSERT INTO student(sid,name,major,standing,age)
VALUES(099354543,'Susan Martin','Law','JR',20);
INSERT INTO student(sid,name,major,standing,age)
VALUES(112348546,'Joseph Thompson','Computer Science','SO',19);
INSERT INTO student(sid,name,major,standing,age)
VALUES(115987938,'Christopher Garcia','Computer Science','JR',20);
INSERT INTO student(sid,name,major,standing,age)
VALUES(132977562,'Angela Martinez','history','SR',20);
INSERT INTO student(sid,name,major,standing,age)
VALUES(269734834,'Thomas Robinson','Psychology','SO',18);
INSERT INTO student(sid,name,major,standing,age)
VALUES(280158572,'Margaret Clark','Animal Science','FR',18);

INSERT INTO class(course_name,schedule,room_number)
VALUES('Data Structure','MWF 10:00-11:00','R128');
INSERT INTO class(course_name,schedule,room_number)
VALUES('Database System','MWF 12:30-1:45','1320 DCL');
INSERT INTO class(course_name,schedule,room_number)
VALUES('Operating System Design','TuTh 12-1:20','20 AVW');
INSERT INTO class(course_name,schedule,room_number)
VALUES('Archaeology of the Incas','MWF 3-4:15','R128');

INSERT INTO enrolled(sid,course_name)
VALUES(051135593,'Data Structure');
INSERT INTO enrolled(sid,course_name)
VALUES(060839453,'Data Structure');
INSERT INTO enrolled(sid,course_name)
VALUES(051135593,'Database System');
INSERT INTO enrolled(sid,course_name)
VALUES(060839453,'Database System');
INSERT INTO enrolled(sid,course_name)
VALUES(051135593,'Operating System Design');
INSERT INTO enrolled(sid,course_name)
VALUES(099354543,'Operating System Design');
INSERT INTO enrolled(sid,course_name)
VALUES(112348546,'Operating System Design');


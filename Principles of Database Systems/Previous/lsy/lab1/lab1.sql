CREATE TABLE student
(
	StudentID INTEGER,
	StudentName char(100),
	StudentMajor char(100),
	StudentStanding char(100),
	StudentAge INTEGER,
	PRIMARY KEY (StudentID)
);
CREATE TABLE classes
(
	ClassName char (100),
	ScheduleTime char (100),
	RoomNumber char (100),
	PRIMARY KEY (ClassName),
	UNIQUE (ScheduleTime, RoomNumber) 
);
CREATE TABLE enrolled
(
	StudentID INTEGER,
	ClassName char(100),
	PRIMARY KEY (StudentID, ClassName),
	FOREIGN KEY (StudentID) REFERENCES student ON DELETE CASCADE, 
	FOREIGN KEY (ClassName) REFERENCES classes 
);
INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('051135593', 'Maria White', 'English', 'SR', '21');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('060839453', 'Charles Harris', 'Archetecture', 'SR', '22');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('099354543', 'Susan Martin', 'Law', 'JR', '20');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('112348546', 'Joseph Thompson', 'Computer Science', 'SO', '19');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('115987938', 'Christopher Garcia', 'Computer Science', 'JR', '20');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('132977562', 'Angela Martinez', 'History', 'SR', '20');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('269734834', 'Thomas Robinson', 'Psychology', 'SO', '18');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('280158572', 'Margaret Clark', 'Animal Science', 'FR', '18');

INSERT INTO classes (ClassName, ScheduleTime, RoomNumber)
VALUES ('Data Structures', 'MWF 10:00­11:00', 'R128');

INSERT INTO classes (ClassName, ScheduleTime, RoomNumber)
VALUES ('Database Systems', 'MWF 12:30­1:45', '1320 DCL');

INSERT INTO classes (ClassName, ScheduleTime, RoomNumber)
VALUES ('Operating System Design', 'TuTh 12­1:20', '20 AVW');

INSERT INTO classes (ClassName, ScheduleTime, RoomNumber)
VALUES ('Archaeology of the Incas', 'MWF 3­4:15', 'R128');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('051135593', 'Data Structures');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('060839453', 'Data Structures');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('051135593', 'Database Systems');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('060839453', 'Database Systems');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('051135593', 'Operating System Design');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('099354543', 'Operating System Design');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('112348546', 'Operating System Design');

INSERT INTO student (StudentID, StudentName, StudentMajor, StudentStanding, StudentAge)
VALUES ('112348546', 'Juan Rodriguez', 'Psychology', 'JR', '20');

INSERT INTO classes (ClassName, ScheduleTime, RoomNumber)
VALUES ('Algorithms', 'MWF 12:30­1:45', '1320 DCL');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('561254634', 'Data Structures');

INSERT INTO enrolled (StudentID, ClassName)
VALUES ('051135593', 'Communication Networks');

DELETE FROM classes
WHERE  ClassName='Data Structures' AND ScheduleTime='MWF 10:00­11:00' AND RoomNumber='R128';

DELETE FROM student
WHERE	StudentID='051135593' AND StudentName='Maria White' AND StudentMajor='English' AND StudentStanding='SR' AND StudentAge='21';

DROP TABLE enrolled;

DROP TABLE student;

DROP TABLE classes;





















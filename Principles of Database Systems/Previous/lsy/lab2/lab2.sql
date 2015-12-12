CREATE TABLE student
(
	sid INTEGER,
	sname CHAR (100),
	sex CHAR (100),
	age INTEGER,
	year INTEGER,
	gpa FLOAT (100),
	PRIMARY KEY (sid)
);
CREATE TABLE dept
(
	dname CHAR (100),
	numphds CHAR (100),
	PRIMARY KEY (dname)
);
CREATE TABLE prof
(
	pname CHAR (100),
	dname CHAR (100),
	PRIMARY KEY (pname)
);
CREATE TABLE course
(
	cno INTEGER,
	cname CHAR (100),
	dname CHAR (100),
	PRIMARY KEY (cno, dname)
);
CREATE TABLE major
(
	dname CHAR (100),
	sid INTEGER,
	PRIMARY KEY (sid, dname)
);
CREATE TABLE section
(
	dname CHAR (100),
	cno INTEGER,
	sectno INTEGER,
	pname CHAR (100),
	PRIMARY KEY (dname, cno, sectno)
);
CREATE TABLE enroll
(
	sid INTEGER,
	grade CHAR (100),
	dname CHAR (100),
	cno INTEGER,
	sectno INTEGER,
	PRIMARY KEY (sid, dname, sectno,cno)
);

/* 1 */
SELECT P.pname
FROM prof P, dept D
WHERE P.dname = D.dname AND D.numphds < 50;

/* 2 */
SELECT S.sname
FROM student S
WHERE S.gpa <= ALL (SELECT S1.gpa
					FROM student S1);

/* 3 */				
SELECT E.cno, E.sectno, AVG (S.gpa)
FROM student S, enroll E
WHERE E.dname = 'Computer Sciences' AND E.sid = S.sid
GROUP BY E.cno, E.sectno;

/* 4 */
SELECT  C.cname, C.cno, E.sectno
FROM course C, enroll E
WHERE C.cno = E.cno AND E.dname = C.dname 
GROUP BY C.cname, C.cno, E.sectno
HAVING COUNT (*) < 6;
													

/* 5 */
SELECT S.sname, S.sid
FROM student S, enroll E
WHERE S.sid = E.sid 
GROUP BY S.sname, S.sid
HAVING COUNT (E.sid) = (SELECT MAX(COUNT(*))
						FROM student S1, enroll E1
						WHERE S1.sid = E1.sid
						GROUP BY S1.sid);

/* 6 */
SELECT D.dname
FROM student S, major M, dept D
WHERE M.sid = S.sid AND D.dname = M.dname AND S.age < 18 AND 0 < (SELECT COUNT (*)
																  FROM major M1
																  WHERE M1.dname = M.dname);
																  
/* 7 */
SELECT S.sname, E.dname
FROM  student S, course C, enroll E
WHERE  E.sid = S.sid AND C.cno = E.cno AND C.dname = E.dname AND C.cname LIKE '%College Geometry%';

/* 8 */

SELECT DISTINCT D.dname, D.numphds
FROM dept D, major M
WHERE M.dname = D.dname AND M.dname NOT IN (SELECT M1.dname
											FROM major M1
											WHERE M1.sid IN (SELECT E.sid
															FROM  student S, course C, enroll E
															WHERE  E.sid = S.sid AND C.cno = E.cno AND C.dname = E.dname AND C.cname LIKE '%College Geometry%'));



/* 9 */
SELECT S.sname
FROM student S, course C, enroll E, course C1, enroll E1
WHERE S.sid = E.sid AND C.cno = E.cno AND E1.sid = S.sid AND C1.cno = E1.cno AND C.dname = 'Computer Sciences' AND C1.dname = 'Mathematics' ;

/* 10 */	
SELECT  MAX(S.age) - MIN(S.age)
FROM student S, major M
WHERE S.sid = M.sid  AND M.dname = 'Computer Sciences';

/* 11 */
SELECT M.dname, AVG (S.gpa)
FROM major M, dept D, student S 
WHERE  S.sid = M.sid 
GROUP BY M.dname
HAVING min(S.gpa) < 1;	
											
/* 12 */
SELECT S.sid, S.sname, S.gpa
FROM student S 
WHERE  NOT EXISTS (SELECT E1.cno
					FROM enroll E1
					WHERE E1.dname = 'Civil Engineering' AND NOT EXISTS (SELECT E2.cno
																		FROM enroll E2
																		WHERE E2.sid = S.sid AND E1.cno = E2.cno));




















































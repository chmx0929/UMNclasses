CREATE TABLE student
(
    sid      integer,
    sname    char(30),
    sex      char(30),
    age      integer,
    year     integer,
    gpa      number,
    PRIMARY KEY (sid)
);

CREATE TABLE dept
(
    dname     char(30),
    numphds   integer,
    PRIMARY KEY (dname)
);

CREATE TABLE prof
(
    pname     char(30),
    dname     char(30),
    PRIMARY KEY (pname)
);

CREATE TABLE course
(
    cno       integer,
    cname     char(30),
    dname     char(30),
    PRIMARY KEY (cno,dname)
);

CREATE TABLE major
(
    dname     char(30),
    sid       integer,
    PRIMARY KEY (dname,sid)
);

CREATE TABLE section
(
    dname     char(30),
    cno       integer,
    sectno    integer,
    pname     char(30),
    PRIMARY KEY (dname,cno,sectno)
);

CREATE TABLE enroll
(
    sid       integer,
    grade     number,
    dname     char(30),
    cno       integer,
    sectno    integer,
    PRIMARY KEY (sid,dname,cno,sectno)
);

SELECT P.pname FROM dept D, prof P WHERE D.dname = P.dname AND D.numphds < 50;

SELECT S.sname FROM student S WHERE S.gpa = (SELECT MIN(S2.gpa) FROM student S2);

SELECT E.cno, E.sectno, AVG(S.gpa) FROM enroll E, student S WHERE E.sid =S.sid AND E.dname ='Computer Sciences' GROUP BY E.cno, E.sectno;

SELECT cname, cno, sectno FROM (SELECT C.cname, C.cno, E.sectno, COUNT(E.sid) AS NUM FROM enroll E, course C WHERE C.cno = E.cno GROUP BY C.cname, C.cno, E.sectno) WHERE NUM < 6;

SELECT S.sname, S.sid FROM student S WHERE S.sid IN (SELECT sid FROM enroll GROUP BY sid HAVING COUNT(sid) = (SELECT MAX(NUM) FROM (SELECT E.sid ,COUNT(E.sid) AS NUM FROM enroll E GROUP BY E.sid))); 

SELECT M.dname FROM major M WHERE sid IN (SELECT S.sid FROM student S WHERE S.age < 18);

SELECT S.sname, M.dname FROM student S JOIN major M ON S.sid = M.sid WHERE S.sid IN (SELECT E.sid FROM enroll E, course C WHERE C.cno = E.cno AND C.cname LIKE 'College Geometry%');

SELECT D.dname, D.numphds FROM dept D WHERE D.dname NOT IN (SELECT DISTINCT M.dname FROM student S JOIN major M ON S.sid = M.sid WHERE S.sid IN (SELECT E.sid FROM enroll E, course C WHERE C.cno = E.cno AND C.cname LIKE 'College Geometry%'));

SELECT S.sname FROM student S WHERE S.sid IN (SELECT E.sid FROM enroll E WHERE E.dname ='Computer Sciences' INTERSECT SELECT E.sid FROM enroll E WHERE E.dname ='Mathematics');

SELECT MAX(S.age)-MIN(S.age) AS Age_Diff FROM student S, major M WHERE S.sid = M.sid AND M.dname ='Computer Sciences';

SELECT M.dname, AVG(S.gpa) AS Avg_Gpa FROM major M JOIN student S ON S.sid = M.sid WHERE M.dname IN (SELECT DISTINCT M2.dname FROM major M2 JOIN student S2 ON M2.sid = S2.sid WHERE S2.gpa < 1.0) GROUP BY	M.dname;

SELECT S.sid, S.sname, S.gpa FROM student S JOIN enroll E ON S.sid = E.sid WHERE E.dname = 'Civil Engineering' HAVING COUNT(DISTINCT E.cno) = (SELECT COUNT(C.cno) FROM course C WHERE C.dname ='Civil Engineering') GROUP BY S.sid, S.sname, S.gpa;

/* PART 1 */
/* 1.1 */
	SELECT S.age
	FROM student S
	WHERE S.age = 20;                               
/* 1.2 */
	SELECT S.year
	FROM student S
	WHERE S.year = 5;                               
/* 1.3 */
	SELECT S.gpa
	FROM student S
	WHERE S.gpa = 4;                                 

/* 2.1 */
	CREATE INDEX Sage ON student(age);
	SELECT S.age
	FROM student S
	WHERE S.age = 20;
	DROP INDEX Sage;                               
/* 2.2 */
	CREATE INDEX Syear ON student(age);
	SELECT S.year
	FROM student S
	WHERE S.year = 5;
	DROP INDEX Syear;                               
/* 2.3 */
	CREATE INDEX Sgpa ON student(age);
	SELECT S.gpa
	FROM student S
	WHERE S.gpa = 4;
	DROP INDEX Sgpa;   

/* 3.1 */
	CREATE INDEX Sage ON student USING hash(age);
	SELECT S.age
	FROM student S
	WHERE S.age = 20 ;
	DROP INDEX Sage;                               
/* 3.2 */
	CREATE INDEX Syear ON student USING hash(age);
	SELECT S.year
	FROM student S
	WHERE S.year = 5;
	DROP INDEX Syear;                               
/* 3.3 */
	CREATE INDEX Sgpa ON student USING hash(age);
	SELECT S.gpa
	FROM student S
	WHERE S.gpa = 4;
	DROP INDEX Sgpa;   

/* HASH 4.1 */
	CREATE INDEX Sage ON student USING hash(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 1 ;
	DROP INDEX Sage;                                

/* HASH 4.2 */
	CREATE INDEX Sage ON student USING hash(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 20 ;
	DROP INDEX Sage; 

/* HASH 4.3 */
	CREATE INDEX Sage ON student USING hash(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 50 ;
	DROP INDEX Sage; 

/* B-tree 4.1 */
	CREATE INDEX Sage ON student(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 1 ;
	DROP INDEX Sage;                                

/* B-tree 4.2 */
	CREATE INDEX Sage ON student(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 20 ; 
	DROP INDEX Sage; 

/* B-tree4.3 */
	CREATE INDEX Sage ON student(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 50 ; 
	DROP INDEX Sage; 

/* HASH 5.1 */
	CREATE INDEX Sage ON student USING hash(age);
	SELECT S.age
	FROM student S
	WHERE S.age = 20;
	DROP INDEX Sage; 

/* HASH 5.2 */
	CREATE INDEX Sage ON student USING hash(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 10 AND S.age < 20 ; 
	DROP INDEX Sage; 

/* B-tree 5.1 */
	CREATE INDEX Sage ON student(age);
	SELECT S.age
	FROM student S
	WHERE S.age = 20;
	DROP INDEX Sage; 

/* B-tree 5.2 */
	CREATE INDEX Sage ON student(age);
	SELECT S.age
	FROM student S
	WHERE S.age > 10 AND S.age < 20;  
	DROP INDEX Sage; 

/* 6 */
	CREATE INDEX Sage ON student USING hash(age);
	CREATE INDEX Ssex ON student USING hash(sex);
	CREATE INDEX Sage ON student(age);
	CREATE INDEX Ssex ON student(sex);
	
	SELECT S.sid FROM student S WHERE S.age > 15 AND S.sex = 'male'; 

	DROP INDEX Sage; 
	DROP INDEX Ssex;
	/* For question 6 , just play with queries with those 4 indexes, there will be total 9 different situations, which i included the time reocords in the report */


/* PART 2 */
/* 1.1 */
	SELECT S.age
	FROM student S
	WHERE S.age < 30; 

/* 1.2 */
	SELECT DISTINCT S.age
	FROM student S
	WHERE S.age < 30;                               

/* 2.1 */
	SELECT  S.age, AVG(s.year)
	FROM student S
	WHERE S.age > 20 AND S.year = 4
	GROUP BY S.age;                                   

/* 2.2 */
	SELECT  S.age, AVG(s.year)
	FROM student S
	WHERE S.year = 4
	GROUP BY S.age
	HAVING S.age > 20;                              

/* 3.1 */
	SELECT  DISTINCT M.dname
	FROM major M
	JOIN student S
	ON M.sid = S.sid
	WHERE  S.age < 30;                     

/* 3.2 */
	SELECT  DISTINCT M.dname
	FROM major M
	WHERE M.sid  IN (SELECT S.sid
         			 FROM student S
                     WHERE S.age < 30);





















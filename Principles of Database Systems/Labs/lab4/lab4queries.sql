--Part 1
--1.
select year from student where year = 4;
select gpa from student where gpa > 3;
select age from student where age = 20;


--2.
CREATE INDEX index_age ON student (age); 
CREATE INDEX index_year ON student (year); 
CREATE INDEX index_gpa ON student (gpa); 
select age from student where age = 20;
select year from student where year = 4;
select gpa from student where gpa > 3;


--3.
DROP INDEX index_age; 
DROP INDEX index_year;   
DROP INDEX index_gpa;   
CREATE INDEX index_age ON student USING hash (age); 
CREATE INDEX index_year ON student USING hash (year); 
CREATE INDEX index_gpa ON student USING hash (gpa); 

select age from student where age = 20;
select year from student where year = 4;
select gpa from student where gpa > 3;


--4. 
--Hash Index
DROP INDEX index_age;
CREATE INDEX index_age ON student USING hash (age);
select age from student where age > 1;
select age from student where age > 10;
select age from student where age > 50;

--B+ tree index
DROP INDEX index_age;
CREATE INDEX index_age ON student (age);
select age from student where age > 1;
select age from student where age > 10;
select age from student where age > 50;


--5. 
--B+ Tree index
DROP INDEX index_age;
CREATE INDEX index_age ON student (age);
select age from student where age = 20;
select age from student where age > 10 and age < 20;

--Hash index
DROP INDEX index_age;
CREATE INDEX index_age ON student USING hash (age);
select age from student where age = 20;
select age from student where age > 10 and age < 20;


--6.
DROP INDEX index_age;

-- No index at all
select * from student where age > 15 and sex = 'Male';

-- B+ tree index on age
CREATE INDEX index_age ON student (age);
select * from student where age > 15 and sex = 'Male';

-- Hash index on both age and sex
DROP INDEX index_age;
CREATE INDEX index_age ON student USING hash (age);
CREATE INDEX index_sex ON student USING hash (sex);
select * from student where age > 15 and sex = 'Male';

-- B+ tree index on age and Hash index on sex
DROP INDEX index_age;
CREATE INDEX index_age ON student (age);
select * from student where age > 15 and sex = 'Male';



--Part 2
--1.
select * from student where age < 30;
select distinct * from student where age < 30;

--2.
--Use HAVING
select age, avg(gpa) as AVGGPA from student group by age having age > 22;

--Use where
select age, avg(gpa) as AVEGPA from student where age > 22 group by age;


--3.
--Use join and where
select distinct m.dname from major m
join student s on s.sid = m.sid and s.age < 30;

--Use IN and nested query
select distinct m.dname from major m where m.sid in (select s.sid from student s where s.age < 30) ;

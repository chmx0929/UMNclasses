1.
select distinct p.pname
from dept d,prof p
where d.dname=p.dname and d.numphds<50

2.
select distinct sname
from student
where gpa=min(gpa)

3.
select cno,sectno,avg(grade) as gpa
from enroll
where dname='Computer Science'
group by cno,sectno

4.
select c.cname,c.cno,e.sectno
from course c,enroll e
where e.cno=c.cno
group by c.cno,c.name,e.sectno
having count(sid)<6

5.
select s.sname,e.sid
from student s,enroll e
where s.sid=e.sid
group by s.sname,e.sid
having count(*)=max(*)

6.
select distinct dname
from major
where sid in (select sid
	      from student
	      where age<18)

7.
select 

8.


9.
select s.sname
from student s,enroll e
where s.sid=e.sid and e.dname='Computer Science' and s.sid in(select *
							      from student s2,enroll e2
							      where s2.sid=e2.sid and e2.dname='Mathematics')

10.
select max(age)-min(age) as age_difference
from student
where sid in(select sid
	     from major
	     where dname='Computer Science')

11.
select dname,avg(grade) as gpa
from enroll
group by dname,sid
having avg(grade)<1.0

12.
select sid,sname,gpa
from student s
where not exists(select *
		 from course c
		 where not exists(select *
				  from enroll e
				  where e.sid=s.sid and e.cno=c.cno and e.dname='Civil Engineering'))

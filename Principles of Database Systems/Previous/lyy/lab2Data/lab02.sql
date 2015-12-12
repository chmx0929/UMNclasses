/*1.*/
select distinct p.pname
from dept d,prof p
where d.dname=p.dname and d.numphds<50;

/*2.*/
select distinct sname
from student
where gpa=(select min(gpa)
	   from student);


/*3.*/
select cno,sectno,avg(gpa) as gpa
from enroll e,student s
where dname='Computer Sciences' and e.sid=s.sid
group by cno,sectno;

/*4.*/
select c.cname,c.cno,e.sectno
from course c,enroll e
where e.cno=c.cno and e.dname=c.dname
group by c.cno,c.cname,e.sectno
having count(*)<6;

/*5.*/
select s.sname,e.sid
from student s,enroll e
where s.sid=e.sid
group by s.sname,e.sid
having count(*)=(select max(count(*))
		 from enroll
		 group by sid);

/*6.*/
select distinct dname
from major
where sid in (select sid
	      from student
	      where age<18);

/*7.*/
select distinct s.sname,e.dname
from student s,enroll e,course c
where s.sid=e.sid and e.cno=c.cno and c.cname like 'College Geometry _';

/*8.*/
select distinct m1.dname,d.numphds
from dept d,major m1
where m1.dname=d.dname
  and m1.dname not in(select m2.dname
	    	      from major m2
   	     	      where m2.sid in (select e.sid
				      from course c,enroll e
				      where c.cname like 'College Geometry _'
				        and e.cno=c.cno and e.dname=c.dname));
/*9.*/
select s.sname
from student s,enroll e
where s.sid=e.sid and e.dname='Computer Sciences' and s.sid in(select s2.sid
							      from student s2,enroll e2
							      where s2.sid=e2.sid and e2.dname='Mathematics');

/*10.*/
select max(age)-min(age) as age_difference
from student
where sid in(select distinct sid
	     from major
	     where dname='Computer Sciences');

/*11.*/
select m.dname,avg(s.gpa)
from major m,student s
where s.sid=m.sid
group by m.dname
having 1<=(select count(*)
	   from major m1,student s1
	   where s1.sid=m1.sid and m1.dname=m.dname and s1.gpa<1);

/*12.*/
select sid,sname,gpa
from student s
where not exists(select *
		 from course c
		 where dname='Civil Engineering' and not exists(select *
				 				from enroll e
								where e.sid=s.sid and e.cno=c.cno and e.dname=c.dname));

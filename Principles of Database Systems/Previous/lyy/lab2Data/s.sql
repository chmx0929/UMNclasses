select distinct s.sname,m.dname
from student s,enroll e,course c,major m
where s.sid=e.sid and e.cno=c.cno and e.dname=c.dname and c.cname like 'College Geometry _'and m.sid=s.sid;

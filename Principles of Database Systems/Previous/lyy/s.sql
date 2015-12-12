select distinct sname
from student
where gpa=(select min(gpa)
	   from student);


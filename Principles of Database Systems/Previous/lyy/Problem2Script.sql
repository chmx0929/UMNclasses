/* Csci 4707 Homework 2 Script */
-- Author: Christopher Jonathan

-- Part D Number 1

/* SuppInfo Table */

create table SuppInfo (
	sid integer,
	pid integer,
	primary key(sid, pid));

insert into SuppInfo values (1, 1);
insert into SuppInfo values (1, 2);
insert into SuppInfo values (2, 1);
insert into SuppInfo values (3, 1);
insert into SuppInfo values (4, 1);
insert into SuppInfo values (4, 2);
insert into SuppInfo values (5, 1);
insert into SuppInfo values (5, 2);
insert into SuppInfo values (5, 3);
	
/* Purchases Table */

create table Purchase(
	purchaseid integer,
	custid integer,
	prodid integer,
	purchaseMethod integer,
	primary key(purchaseid));
	
insert into Purchase values (1, 1, 1, 1);
insert into Purchase values (2, 1, 1, 2);
insert into Purchase values (3, 1, 1, 3);
insert into Purchase values (4, 2, 1, 1);
insert into Purchase values (5, 2, 1, 3);
insert into Purchase values (6, 3, 1, 1);
insert into Purchase values (7, 3, 1, 2);
insert into Purchase values (8, 4, 1, 1);
	
/* 
Problem D1a Expected Output

1,4 or 4,1
2,3 or 3,2

Problem D1b Expected Output

2
3


      select distinct s1.suppid,s2.suppid,s3.prodid
      from SuppInfo s1,SuppInfo s2,SuppInfo s3
      where s1.suppid<s2.suppid and s1.suppid=s3.suppid and exists(select *
     						                   from SuppInfo b1,SuppInfo b2,SuppInfo b3
						                   where b1.suppid<b2.suppid and b2.suppid=b3.suppid and s1.suppid=b1.suppid and s2.suppid=b2.suppid and s3.prodid=b3.prodid));


*/

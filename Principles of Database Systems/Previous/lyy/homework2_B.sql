/* Homework2_B     */
/* Yangyun Li      */
/* 5026569 lixx3524*/

D.1a
select distinct s1.suppid,s2.suppid
from SuppInfo s1,SuppInfo s2
where s1.suppid<s2.suppid
MINUS
select Temp1.suppid,Temp2.suppid
from((select distinct s1.suppid,s2.suppid,s3.prodid
      from SuppInfo s1,SuppInfo s2,SuppInfo s3
      where s1.suppid<s2.suppid and s1.suppid=s3.suppid) Temp1
      UNION
     (select distinct s1.suppid,s2.suppid,s3.prodid
      from SuppInfo s1,SuppInfo s2,SuppInfo s3
      where s1.suppid<s2.suppid and s2.suppid=s3.suppid) Temp2
      MINUS
     (Temp1 intersect Temp2));

D.1b
select distinct p1.custid
from Purchase p1,Purchase p2
where p1.custid=p2.custid and p1.purchaseMethod<>p2.purchaseMethod
MINUS
select distinct p1.custid
from Purchase p1,Purchase p2,Purchase p3
where p1.custid=p2.custid and p2.custid=p3.custid and p1.purchaseMethod<>p2.purchaseMethod and p1.purchaseMethod<>p3.purchaseMethod and p2.purchaseMethod<>p3.purchaseMethod;

D.2
select distinct s1.barId,s2.barId
from Serves s1,Serve s2
where s1.barId<s2barId and s1.beerId=s2.beerId
group by s1.barId,s2.barId
having count(*)=(select count(*)
                 from Serves s3
                 where s3.barid=s1.barId)
   and count(*)=(select count(*)
                 from Serves s4
                 where s4.barId=s2.barId)

D.3
select cname
from Customer
where cid NOT IN (select cid
		  from Buys
		  where pid NOT IN(select pid
				   from Product p
				   where NOT EXISTS (select *
						     from Customer c
						     where NOT EXISTS(select *
								      from Buys b
								      where p.pid=b.pid and c.cid=b.cid))));


D.4
select name
from Actors a
where NOT EXISTS(select *
		 from Cast c,Movies m,Directors d
		 where d.did=m.did and m.mid=c.mid and c.aid=a.aid and d.name<>'Spielberg');

/*D1a*/ 
	(SELECT DISTINCT S1.suppid s1, S2.suppid S2
	FROM SuppInfo S1, SuppInfo S2
	WHERE S1.suppid < S2.suppid) AllPairs
	MINUS
	(SELECT Temp1.T1, Temp1.T2
	FROM ((SELECT AllPairs.S1 T1, AllPairs.s2 T2, S1.prodid
		  	FROM AllPairs, S1
		  	WHERE AllPairs.S1 = S1.suppid) Temp1
		  	UNION
		  	(SELECT AllPairs.s1 T3, AllPairs.s2 T4, S1.prodid
		  	FROM AllPairs, S1
		  	WHERE AllPairs.s2 = S1.suppid) Temp2
		  	MINUS
		  	(Temp1 INTERSECT Temp2))) BadPairs;	
/*D1b*/
	SELECT P1.custid
	FROM Purchases P1, Purchases P2,
	WHERE P1.purchaseMethod < P2.purchaseMethod AND P1.custid = P2.custid
	EXCEPT
	SELECT P1.custid
	FROM Purchases P1, Purchases P2, Purchases P3,
	WHERE P1.purchaseMethod < P2.purchaseMethod AND P2.purchaseMethod < P3.purchaseMethod AND P1.custid = P2.custid AND P2.custid = P3.custid;
				

/*D2*/
	SELECT S1.barId, S2.barId
	FROM Serves S1, Serves S2
	WHERE S1.barId < S2.barId AND S1.beerId = S2.beerId
	GROUP BY S1.barId, S2.barId
	HAVING COUNT(*) = (SELECT COUNT(S3.beerId)
						FROM Serves S3
						WHERE S3.barId = S1.barId) AND COUNT(*) = (SELECT COUNT (S4.barId)
																	FROM Serves S4
																	WHERE S4.barId, S2.barId); 
	
/*D3*/

/*D4*/
	SELECT A.name
	FROM Actors A, 
	WHERE A.aid IN (SELECT C.aid
					FROM Cast C, Directories D, Movies M
					WHERE M.mid = C.mid AND D.did = M.did AND D.name = "Spielberg"
					EXCEPT
					SELECT C1.aid
					FROM Cast C1, Directories D1, Movies M1
					WHERE M.mid = C.mid AND D.did = M.did AND D.name != "Spielberg");

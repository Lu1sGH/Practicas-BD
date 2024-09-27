SPOOL C:\guest\schemasetup\VistasEmployee.txt

SET ECHO OFF;

DROP VIEW VISTA_E9;
DROP VIEW VISTA_E8;
DROP VIEW VISTA_E7;
DROP VIEW VISTA_E6;
DROP VIEW VISTA_E5;
DROP VIEW VISTA_E4;
DROP VIEW VISTA_E3;
DROP VIEW VISTA_E2;
DROP VIEW VISTA_E1;

REM VISTA DEL ARBOL E
REM VISTA_E1
CREATE VIEW VISTA_E1 AS
select * from project
where Pname='ProductX';
	
REM VISTA_E2
CREATE VIEW VISTA_E2 AS
SELECT PNUMBER FROM VISTA_E1;

REM VISTA_E3
CREATE VIEW VISTA_E3 AS
SELECT ESSN, PNO
FROM WORKS_ON;
	
REM VISTA_E4
CREATE VIEW VISTA_E4 AS
SELECT * FROM VISTA_E2, VISTA_E3
WHERE PNUMBER=PNO;
	
REM VISTA_E5
CREATE VIEW VISTA_E5 AS
SELECT ESSN FROM VISTA_E4;

REM VISTA_E6
CREATE VIEW VISTA_E6 AS
select * from EMPLOYEE
where BDATE>TO_DATE('1957-12-31', 'YYYY-MM-DD');

REM VISTA_E7
CREATE VIEW VISTA_E7 AS
SELECT SSN, LNAME
FROM VISTA_E6;
	
REM VISTA_E8
CREATE VIEW VISTA_E8 AS
SELECT * FROM VISTA_E5, VISTA_E7
WHERE ESSN=SSN;
	
REM VISTA_E9
CREATE VIEW VISTA_E9 AS
SELECT LNAME
FROM VISTA_E8;
	
SELECT LNAME	
FROM EMPLOYEE, WORKS_ON, PROJECT
WHERE Pname='ProductX' AND ESSN=SSN AND
BDATE>TO_DATE('1957-12-31', 'YYYY-MM-DD') AND
PNUMBER=PNO;
		
select * from VISTA_E1;
PAUSE		
select * from VISTA_E2;
PAUSE	
select * from VISTA_E3;
PAUSE
select * from VISTA_E4;
PAUSE
select * from VISTA_E5;
PAUSE
select * from VISTA_E6;
PAUSE
select * from VISTA_E7;
PAUSE
select * from VISTA_E8;
PAUSE
select * from VISTA_E9;
PAUSE

PROMPT CIFRAS CONTROL 
select count(*) "VISTA_E1" from VISTA_E1;
select count(*) "VISTA_E2" from VISTA_E2;
select count(*) "VISTA_E3" from VISTA_E3;
select count(*) "VISTA_E4" from VISTA_E4;
select count(*) "VISTA_E5" from VISTA_E5;
select count(*) "VISTA_E6" from VISTA_E6;
select count(*) "VISTA_E7" from VISTA_E7;
select count(*) "VISTA_E8" from VISTA_E8;
select count(*) "VISTA_E9" from VISTA_E9;

SPOOL OFF

--GRANT CREATE VIEW TO c##employee;
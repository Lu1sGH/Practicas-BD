set pagesize 99
set colsep '!! '
set linesize 250
set null s/Datos

--DROP TABLE TAB1 CASCADE CONSTRAINTS;
--DROP TABLE TAB2 CASCADE CONSTRAINTS;

CREATE TABLE TAB1 (
	ID_T1 NUMBER(4), --Da una restriccion de PK a ID_T1. La CONSTRAINT se llama TAB_1_PK.
	ID_TAB2 NUMBER(4)); -- 
	
CREATE TABLE TAB2(
	ID_T2 NUMBER(4)); --Da una restriccion de PK a ID_T2. La CONSTRAINT se llama TAB_2_PK.
	
ALTER SESSION SET CONSTRAINTS = DEFERRED;
ALTER SESSION SET CONSTRAINTS = IMMEDIATE;

ALTER TABLE TAB2 ADD CONSTRAINT TAB_2_PK
	PRIMARY KEY (ID_T2); --Da una restriccion de PK a ID_T2. La CONSTRAINT se llama TAB_2_PK.

ALTER TABLE TAB1 ADD CONSTRAINT TAB_1_PK
	PRIMARY KEY (ID_T1); --Da una restriccion de PK a ID_T1. La CONSTRAINT se llama TAB_1_PK.

ALTER TABLE TAB1 ADD CONSTRAINT TAB1_TAB2_FK
	FOREIGN KEY (ID_TAB2)
	REFERENCES  TAB2 (ID_T2) --Vuelve ID_TAB2 una FK referenciando a TAB2. La CONSTRAINT se llama TAB1_TAB2_FK
	ENABLE NOVALIDATE;
	
ALTER TABLE TAB1 MODIFY CONSTRAINTS TAB1_TAB2_FK 
	ENABLE VALIDATE;
	
INSERT INTO TAB1 VALUES (10,100);
INSERT INTO TAB1 VALUES (20,200);
INSERT INTO TAB1 VALUES (30,300);
INSERT INTO TAB1 VALUES (40,400);

INSERT INTO TAB2 VALUES (200);
INSERT INTO TAB2 VALUES (300);
INSERT INTO TAB2 VALUES (400);
INSERT INTO TAB2 VALUES (100);

SELECT * FROM TAB1;
SELECT * FROM TAB2;


col owner format a8
col constraint_name format a12
col table_name format a5
col constraint_type format a2
col deferrable format a14
col deferred format a9
col search_condition format a39
COL VALIDATED FORMAT A9

select owner, constraint_name,table_name,
	constraint_type,status,deferrable,deferred,VALIDATED,
	SEARCH_CONDITION 
	from user_constraints
	where table_name IN  ('TAB1','TAB2');
	
COL COLUMN_NAME FORMAT A16
COL POSITION    FORMAT 999	
SELECT OWNER,CONSTRAINT_NAME,TABLE_NAME,
	COLUMN_NAME,POSITION
	FROM USER_CONS_COLUMNS
	WHERE table_name IN  ('TAB1','TAB2');
	
DELETE FROM TAB1;
DELETE FROM TAB2;
	
	
REM 
REM ACTIVEMOS LA RESTRICCION
REM 
alter table TAB1
enable constraint TAB1_TAB2_FK;
REM
REM DISACTIVEMOS LA RESTRICCION 
REM 
alter table TAB1
DISABLE constraint TAB1_TAB2_FK;


	
	
	
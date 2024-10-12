SPOOL C:\guest\schemasetup\CTEmployee.txt

SET ECHO OFF;

REM Employee
REM ESTUDIANTES Sierra Fierro Samuel Isaac / Cesar Abraham / De la Cruz Fuentes Diego

SET PAGESIZE 99
SET LINESIZE 150
set colsep ' |=| '
set null Nulos
COLUMN timestamp_col NEW_VALUE timestamp_var
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS "Fecha de ejecucion" FROM dual;

REM (Ramez & Navathe, 2010)
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE DEPT_LOCATIONS CASCADE CONSTRAINTS;
DROP TABLE DEPENDENT CASCADE CONSTRAINTS;
DROP TABLE PROJECT CASCADE CONSTRAINTS;
DROP TABLE WORKS_ON CASCADE CONSTRAINTS;

CREATE TABLE EMPLOYEE (
    Fname VARCHAR2(15),
    Minit VARCHAR2(1),
    Lname VARCHAR2(15),
    Ssn NUMBER(9), 
    Bdate DATE,
    Address VARCHAR2(25),
    Sex CHAR(1),
    Salary NUMBER(8,2),
    Super_ssn VARCHAR2(9),
    Dno NUMBER(2)
);

CREATE TABLE DEPARTMENT (
    Dname VARCHAR2(15),
    Dnumber NUMBER(2),
    Mgr_ssn NUMBER(9), 
    Mgr_start_date DATE
);

CREATE TABLE DEPT_LOCATIONS (
    Dnumber NUMBER(2),
    Dlocation VARCHAR2(20)
);

CREATE TABLE WORKS_ON (
    Essn NUMBER(9), 
    Pno NUMBER(2),
    Hours FLOAT(2)
);

CREATE TABLE DEPENDENT (
    Essn NUMBER(9), 
    Dependent_name VARCHAR2(15),
    Sex VARCHAR2(1),
    Bdate DATE,
    Relationship VARCHAR2(20)
);


CREATE TABLE PROJECT (
  Pname VARCHAR2(15),
  Pnumber NUMBER(2),
  Plocation VARCHAR2(15),
  Dnum NUMBER(2)
);
REM PRIMARY KEY
ALTER TABLE EMPLOYEE
ADD CONSTRAINT pk_employee PRIMARY KEY (Ssn);
ALTER TABLE DEPARTMENT
ADD CONSTRAINT pk_department PRIMARY KEY (Dnumber);
ALTER TABLE PROJECT
ADD CONSTRAINT pk_project PRIMARY KEY (Pnumber);
ALTER TABLE WORKS_ON
ADD CONSTRAINT pk_works_on PRIMARY KEY (Essn, Pno);
ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation);
ALTER TABLE DEPENDENT
ADD CONSTRAINT pk_dependent PRIMARY KEY (Essn, Dependent_name);

REM  FOREIGN KEY
ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_department_mgr_ssn FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT fk_dept_locations_dnumber FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE WORKS_ON
ADD CONSTRAINT fk_works_on_essn FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE WORKS_ON
ADD CONSTRAINT fk_works_on_pno FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber);
ALTER TABLE DEPENDENT
ADD CONSTRAINT fk_dependent_essn FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE PROJECT
ADD CONSTRAINT fk_project_dnum FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_employee_dno FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_employee_super_ssn FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);

--CHECK
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_fname_lname CHECK (
    REGEXP_LIKE(Fname, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
    AND REGEXP_LIKE(Lname, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_minit CHECK (Minit = UPPER(Minit));
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_ssn_length CHECK (
    REGEXP_LIKE(Ssn, '^\d{9}$')
);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_super_ssn_length CHECK (
    REGEXP_LIKE(Super_ssn, '^\d{9}$')
);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_address CHECK (
    REGEXP_LIKE(Address, '^[A-Za-zÁÉÍÓÚÑáéíóúñ0-9_,\s]+$')
);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_dno_positive CHECK (Dno > 0);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_salary_positive CHECK (Salary > 0);
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_bdate CHECK (Bdate > DATE '1900-01-01');
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_employee_sex CHECK (Sex IN ('M', 'F'));


-- DEPARTMENT
ALTER TABLE DEPARTMENT
ADD CONSTRAINT chk_department_dname CHECK (
    REGEXP_LIKE(Dname, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);

ALTER TABLE DEPARTMENT
ADD CONSTRAINT chk_department_mgr_start_date CHECK (Mgr_start_date > DATE '1900-01-01');

-- DEPT_LOCATIONS
ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT chk_dept_locations_dnumber CHECK (Dnumber > 0);

ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT chk_dept_locations_dlocation CHECK (
    REGEXP_LIKE(Dlocation, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);

-- WORKS_ON
ALTER TABLE WORKS_ON
ADD CONSTRAINT chk_works_on_hours CHECK (Hours >= 0);

ALTER TABLE WORKS_ON
ADD CONSTRAINT chk_works_on_pno CHECK (Pno > 0);

-- PROJECT
ALTER TABLE PROJECT
ADD CONSTRAINT chk_project_pname CHECK (
    REGEXP_LIKE(Pname, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);

ALTER TABLE PROJECT
ADD CONSTRAINT chk_project_plocation CHECK (
    REGEXP_LIKE(Plocation, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);

-- DEPENDENT
ALTER TABLE DEPENDENT
ADD CONSTRAINT chk_dependent_dependent_name CHECK (
    REGEXP_LIKE(Dependent_name, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);

ALTER TABLE DEPENDENT
ADD CONSTRAINT chk_dependent_sex CHECK (Sex IN ('M', 'F'));


ALTER TABLE DEPENDENT
ADD CONSTRAINT chk_dependent_bdate CHECK (Bdate > DATE '1900-01-01');

ALTER TABLE DEPENDENT
ADD CONSTRAINT chk_dependent_relationship CHECK (
    REGEXP_LIKE(Relationship, '^[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+$')
);

INSERT ALL 
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('John', 'B', 'Smith', 123456789, TO_DATE('1965-01-09', 'YYYY-MM-DD'), '731_Fondren,_Houston,_TX', 'M', 30000, 333445555, 5)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Frankin', 'T', 'Wong', 333445555, TO_DATE('1955-12-08', 'YYYY-MM-DD'), '698_Voss,_Houston,_TX', 'M', 40000, 888665555, 5)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Alcia', 'J', 'Zelaya', 999887777, TO_DATE('1968-01-19', 'YYYY-MM-DD'), '9921_Castle,_Spring,_TX', 'F', 25000, 987654321, 4)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Jennifer', 'S', 'Wallace', 987654321, TO_DATE('1941-06-20', 'YYYY-MM-DD'), '291_Beny,_Bellaire,_TX', 'F', 43000, 888665555, 4)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Ramesh', 'K', 'Narayan', 666884444, TO_DATE('1962-09-15', 'YYYY-MM-DD'), '975_Fire_Oak,_Humble,_TX', 'M', 38000, 333445555, 5)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Joyce', 'A', 'English', 453453453, TO_DATE('1972-07-31', 'YYYY-MM-DD'), '5691_Rice,_Houston,_TX', 'F', 25000, 333445555, 5)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Ahmad', 'V', 'Jabbar', 987987987, TO_DATE('1969-03-29', 'YYYY-MM-DD'), '980_Dallas,_Houston,_TX', 'M', 25000, 987654321, 4)
INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('James', 'E', 'Borg', 888665555, TO_DATE('1937-11-10', 'YYYY-MM-DD'), '450_Stone,_Houston,_TX', 'M', 55000, NULL, 1)
SELECT * FROM DUAL;

INSERT ALL 
INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES ('Research', 5, 333445555, TO_DATE('1988-05-22', 'YYYY-MM-DD'))
INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES ('Administration', 4, 987654321, TO_DATE('1995-01-01', 'YYYY-MM-DD'))
INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES ('Headquarters', 1, 888665555, TO_DATE('1981-06-19', 'YYYY-MM-DD'))
SELECT * FROM DUAL;

INSERT ALL 
INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES (1, 'Houston')
INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES (4, 'Stafford')
INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES (5, 'Bellaire')
INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES (5, 'Sugarland')
INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES (5, 'Houston')
SELECT * FROM DUAL;

INSERT ALL 
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (123456789, 1, 32.5)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (123456789, 2, 7.5)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (666884444, 3, 40.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (453453453, 1, 20.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (453453453, 2, 20.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (333445555, 2, 10.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (333445555, 3, 10.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (333445555, 10, 10.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (333445555, 20, 10.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (999887777, 30, 30.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (999887777, 10, 10.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (987987987, 10, 35.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (987987987, 30, 5.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (987654321, 30, 20.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (987654321, 20, 15.0)
    INTO WORKS_ON (Essn, Pno, Hours) VALUES (888665555, 20, NULL)
SELECT * FROM DUAL;

INSERT ALL 
    INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES ('ProductX', 1, 'Bellaire', 5)
    INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES ('ProductY', 2, 'Sugarland', 5)
    INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES ('ProductZ', 3, 'Houston', 5)
    INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES ('Computerization', 10, 'Stafford', 4)
    INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES ('Reorganization', 20, 'Houston', 1)
    INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES ('Newbenefits', 30, 'Stafford', 4)
SELECT * FROM DUAL;

INSERT ALL 
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (333445555, 'Alice', 'F', TO_DATE('1986-04-05', 'YYYY-MM-DD'), 'Daughter')
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (333445555, 'Theodore', 'M', TO_DATE('1983-10-25', 'YYYY-MM-DD'), 'Son')
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (333445555, 'Joy', 'F', TO_DATE('1958-05-03', 'YYYY-MM-DD'), 'Spouse')
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (987654321, 'Abner', 'M', TO_DATE('1942-02-28', 'YYYY-MM-DD'), 'Spouse')
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (123456789, 'Michael', 'M', TO_DATE('1988-01-04', 'YYYY-MM-DD'), 'Son')
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (123456789, 'Alice', 'F', TO_DATE('1988-12-30', 'YYYY-MM-DD'), 'Daughter')
    INTO DEPENDENT (ESSN, Dependent_name, Sex, Bdate, Relationship) VALUES (123456789, 'Elizabeth', 'F', TO_DATE('1967-05-05', 'YYYY-MM-DD'), 'Spouse')
SELECT * FROM DUAL;

SET COLSEP '| * |'
SET LINESIZE 300
SET PAGESIZE 200

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM DEPT_LOCATIONS;
SELECT * FROM DEPENDENT;
SELECT * FROM PROJECT;
SELECT * FROM WORKS_ON;

SPOOL OFF;

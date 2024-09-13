REM CREACIÓN DEL USUARIO ESTUDIANTE Y DB STUDENT

set pagesize 99;
set linesize 250;
col parameter format a36;
col value format a35;
set colsep '||';
set null n/Datos;
select parameter, value from NLS_SESSION_PARAMETERS;

REM CREACIÓN DEL USUARIO

CONNECT / as SYSDBA

CREATE USER C##student IDENTIFIED by stdnt
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT, RESOURCE TO C##student;

ALTER USER C##student QUOTA 1G ON USERS;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CONNECT C##student/stdnt

SHOW USER

REM CREACIÓN DEL ESQUEMA ESTUDIANTE

@C:\guest\schemasetup\createStudent.sql

REM RESTAURACIÓN DEL ESQUEMA ESTUDIANTE

@C:\guest\schemasetup\rebuildStudent.sql

REM TABLAS ADICIONALES

@C:\guest\schemasetup\sql_book_add_tables.sql

@C:\guest\schemasetup\drop_extra_tables.sql
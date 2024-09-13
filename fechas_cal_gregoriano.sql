SPOOL C:\Users\ORA_bases\2021_02_24_clase_2\salida\fechasG.TXT

select sysdate from dual;
select dump (sysdate) from dual;
select systimestamp from dual;
select dump (systimestamp) from dual;

select to_timestamp_tz('01-SEP-2024 07:25:32.000001000 +1', 'DD-MON-YYYY HH24:MI:SS.FF9 TZH') ESTAMPA from dual;
select dump(to_timestamp_tz('01-SEP-2024 07:25:32.000001000 +1', 'DD-MON-YYYY HH24:MI:SS.FF9 TZH')) ESTAMPADUMP from dual;

rem calendario Gregoriano modificado papa Gregorio XIII el 5 de oct de 1582

select      to_char(TO_DATE('24-Feb-2021 12:00 pm','dd-Mon-yyyy hh:mi am'), 'DL') FECHA
			from dual;
select      to_char(TO_DATE('24-Feb-2021 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('4-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'DL') FECHA
			from dual;
select      to_char(TO_DATE('5-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'DL') FECHA
			from dual;
select      to_char(TO_DATE('6-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('7-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('8-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('9-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('10-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('11-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('12-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('13-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('14-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('15-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHA
			from dual;
select      to_char(TO_DATE('16-Oct-1582 7:00 Am','dd-Mon-yyyy hh:mi am'), 'J') FECHANU
			from dual;
REM FECHA EN ORACLE DEL 1 DE ENERO DE 4712 AC
select      to_char(TO_DATE('01-JAN--4712 7:00 Am','dd-Mon-sYYYY hh:mi am'), 'J')
                FECHANU
			from dual;
select      to_char(TO_DATE('01-Jan--4712 7:00 Am','dd-Mon-sYYYY  hh:mi am'), 'DL') FECHANU
			from dual;			
select      to_char(TO_DATE('01-Jan-1 7:00 Am','dd-Mon-sYYYY hh:mi am'), 'J') FECHANU
			from dual;
select      to_char(TO_DATE('21-Jan-2021 7:00 Am','dd-Mon-sYYYY hh:mi am'), 'J') FECHANU
			from dual;
select      to_char(TO_DATE('20-Aug-2021 7:00 Am','dd-Mon-sYYYY hh:mi am'), 'J') FECHANU
			from dual;
	 

----------------------------------------------------------
REM 
REM EJEMPLO DE GENERAR FECHA AL AZAR DENTRO DE UN PERIODO ESPECIFICO

SELECT TO_CHAR(TO_DATE('01/01/2020','mm/dd/yyyy'),'J') FROM DUAL;

SELECT TO_CHAR(TO_DATE('02/02/2022','mm/dd/yyyy'),'J') FROM DUAL;



SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2458850,2458850+364)),'J') fecha  FROM DUAL;
col fecha format a29
SELECT TO_CHAR(TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2458870,2458870+364)),'J')
              ,'DD/fmMonth/YYYY') fecha  FROM DUAL;

------------------------------------------------------------------------			
REM FECHA 			
column fecha format a40 just center;			
select to_char(sysdate, 'dd-Mon-yyyy hh:mi am') fecha
from dual;
select to_char(sysdate, 'dd-mon-yyyy hh:mi am') fecha
from dual;
select to_char(sysdate, 'fmdd-Month-yyyy hh:mi am') fecha 
from dual;
select to_char(sysdate, 'fmday dd-Mon-yyyy hh:mi am') fecha
from dual;
select to_char(sysdate, 'fmday dd-Mon-yyyy hh:mi am', 'NLS_DATE_LANGUAGE=FRENCH') 
   fecha FROM DUAL;
   
select to_char(sysdate, 'fmday dd-Mon-yyyy hh:mi am', 'NLS_DATE_LANGUAGE=GERMAN') 
   fecha FROM DUAL;
select to_char(sysdate, 'fmday dd-Month-yyyy hh:mi am', 'NLS_DATE_LANGUAGE=GERMAN') 
   fecha FROM DUAL;
select to_char(sysdate, 'fmDay dd-Month-yyyy hh:mi am', 'NLS_DATE_LANGUAGE=ITALIAN') 
   fecha FROM DUAL;
select to_char(sysdate, 'fmDay dd-Month-yyyy hh:mi am', 'NLS_DATE_LANGUAGE=PORTUGUESE') 
   fecha FROM DUAL;
select to_char(sysdate, 'fmDL dd-Month-yyyy hh:mi am', 'NLS_DATE_LANGUAGE=PORTUGUESE') 
   fecha FROM DUAL;
REM FECHA EN FORMATO LARGO     DL
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = FRENCH') FROM DUAL;
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = ENGLISH') FECHA FROM DUAL;
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = FRENCH') FECHA FROM DUAL;
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = CATALAN') FECHA FROM DUAL;
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = PORTUGUESE') FECHA FROM DUAL;
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = ENGLISH') FECHA FROM DUAL;
select to_char(sysdate, 'DL','NLS_DATE_LANGUAGE = SPANISH') FECHA FROM DUAL;
REM FECHA EN FORMATO CORTO     DS
select to_char(sysdate, 'DS','NLS_DATE_LANGUAGE = FRENCH') FECHA FROM DUAL;
select to_char(sysdate, 'DS','NLS_DATE_LANGUAGE = SPANISH') FECHA FROM DUAL;   
alter session set nls_date_language = 'ENGLISH';

spool off
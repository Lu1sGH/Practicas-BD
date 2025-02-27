SPOOL C:\guest\schemasetup\Cap5OUT.txt
/*												CAP 5
|||||||||||||||||||||||||||||||||||||| 5.1 "Applying Oracle's Date Format Models" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 191)
--Despliega el apellido y la fecha de registro de los estudiantes cuya id sea 123 o 161 o 190.
SELECT last_name, registration_date
FROM student
WHERE student_id IN (123, 161, 190);

--(Rischert, 2010, 192)
--Despliega el apellido y la fecha de registro de los estudiantes cuya id sea 123 o 161 o 190.
--Cambia el formato en el que se muestra la fecha.
SELECT last_name, registration_date,
TO_CHAR(registration_date, 'MM/DD/YYYY')
AS "Formatted"
FROM student
WHERE student_id IN (123, 161, 190);

--(Rischert, 2010, 193)
--Despliega el apellido, día en minús, día en mayús, la fecha y la hora de resgistro de los estudiantes
-- cuya id sea 123 o 161 o 190.
SELECT last_name,
TO_CHAR(registration_date, 'Dy') AS "1.Day",
TO_CHAR(registration_date, 'DY') AS "2.Day",
TO_CHAR(registration_date, 'Month DD, YYYY') --Ej. February 02, 2007
AS "Look at the Month",
TO_CHAR(registration_date, 'HH:MI PM') AS "Time"
FROM student
WHERE student_id IN (123, 161, 190);

--(Rischert, 2010, 194)
--Despliega el apellido y dos formatos diferentes de fecha de los alumnos cuya id sea 123 o 161 o 190.
SELECT last_name,
TO_CHAR(registration_date, 'fmMonth ddth, YYYY') --fm quita los espacios extra entre el mes y día
"Eliminating Spaces",	--El formato de parámetro th incluye el st, nd, rd & th después de cada num.
TO_CHAR(registration_date, 'Ddspth "of" fmMonth') --El formato de parámetro sp deletrea la fecha
"Spelled out"	--Ej. Second of February. Dd indica que la primera letra del día es es mayús. Lo mismo con el mes.
FROM student
WHERE student_id IN (123, 161, 190);

--(Rischert, 2010, 195)
--Despliega el apellido y la fecha de registro de los estudiantes cuya fecha de registro sea el
-- 22 de Enero del 2007.
SELECT last_name, registration_date
FROM student
WHERE registration_date = TO_DATE('22-JAN-2007', 'DD-MON-YYYY');

--(Rischert, 2010, 195)
--Despliega un error porque el formato de fecha tiene que concordar con el texto.
SELECT last_name, registration_date
FROM student
WHERE registration_date = TO_DATE('22/01/2007', 'DD-MON-YYYY');

--(Rischert, 2010, 196)
--Despliega el apellido y la fecha de registro de los estudiantes cuya fecha de registro sea el
-- 22 de Enero del 2007.
--ORACLE puede hacer conversiones implícitas cuando el texto está en el formato default.
--El formato default está determinado por el NLS_DATE_FORMAT.
SELECT last_name, registration_date
FROM student
WHERE registration_date = '22-JAN-07';

--(Rischert, 2010, 197)
--Despliega el codigo del tipo de calf, la descripción y la fecha de creación en donde la fecha de
-- creación sea el 31 de diciembre de 1998
SELECT grade_type_code, description, created_date
FROM grade_type
WHERE created_date = '31-DEC-98'; --del 50 al 99 se considera 1900. Del 00 al 49 se considera 2000.

--(Rischert, 2010, 198)
--Revisa si tu instalación tiene el formato DD-MON-RR o DD-MON-RRRR que interpretan lo anterior como
-- años de 1900 o del 2000.
SELECT SYS_CONTEXT ('USERENV', 'NLS_DATE_FORMAT')
FROM dual;

--(Rischert, 2010, 198)
--Despliega el año 1967 y el año 2017.
SELECT TO_CHAR(TO_DATE('17-OCT-67','DD-MON-RR'),'YYYY') "1900",
TO_CHAR(TO_DATE('17-OCT-17','DD-MON-RR'),'YYYY') "2000"
FROM dual;

--(Rischert, 2010, 198)
--Despliega el apellido y le fecha de registro (con hora, min y ss) de los estudiantes que fueron registrados
-- el 22 de Enero del 2007
SELECT last_name,
TO_CHAR(registration_date, 'DD-MON-YYYY HH24:MI:SS') --Si al crear el registro ninguna hora fue ingresada, se 
FROM student -- tomará como la media noche. 00:00:00 O 12:00:00 AM. 
WHERE registration_date = TO_DATE('22-JAN-2007', 'DD-MON-YYYY');

--(Rischert, 2010, 199)
--Despliega la id del estudiante, fecha de inscripción de la tabla enrollment donde la fecha sea igual
-- al 7 de Febrero del 2007.
--La función TRUNC hace que la hora sea interpretada como las 00:00:00.
SELECT student_id, TO_CHAR(enroll_date, 'DD-MON-YYYY HH24:MI:SS')
FROM enrollment
WHERE TRUNC(enroll_date) = TO_DATE('07-FEB-2007', 'DD-MON-YYYY');

--(Rischert, 2010, 199)
--Despliega la id del estudiante, fecha de inscripción de la tabla enrollment donde la fecha sea igual
-- al 7 de Febrero del 2007.
--La fecha está en formato ANSI
SELECT student_id, TO_CHAR(enroll_date, 'DD-MON-YYYY HH24:MI:SS')
FROM enrollment
WHERE enroll_date >= DATE '2007-02-07'
AND enroll_date < DATE '2007-02-08';

--(Rischert, 2010, 200)
--Despliega la id del estudiante, fecha de inscripción de la tabla enrollment donde la fecha sea igual
-- al 7 de Febrero del 2007.
--La fecha está en formato ANSI TIMESTAMP
SELECT student_id, TO_CHAR(enroll_date, 'DD-MON-YYYY HH24:MI:SS')
FROM enrollment
WHERE enroll_date >= TIMESTAMP '2007-02-07 00:00:00'
AND enroll_date < TIMESTAMP '2007-02-08 00:00:00';

--(Rischert, 2010, 204)
--Despliega el no. de curso, la id de la sección y la fecha de inicio de la tabla sección donde la 
-- fecha de inicio sea Domingo.
--No despliega ninguna tabla porque al pasar el día a char este tendrá una long de 9 chars, 'Sunday   '. 
--'Sunday' solo tiene 6. 
SELECT course_no, section_id,
TO_CHAR(start_date_time, 'Day DD-Mon-YYYY HH:MI am')
FROM section
WHERE TO_CHAR(start_date_time, 'Day') = 'Sunday';

--(Rischert, 2010, 204)
--Despliega el no. de curso, la id de la sección y la fecha de inicio de la tabla sección donde la 
-- fecha de inicio sea Domingo.
--'fm' (fill mode) quita los espacios extra.
SELECT course_no, section_id,
TO_CHAR(start_date_time, 'Day DD-Mon-YYYY HH:MI am')
FROM section
WHERE TO_CHAR(start_date_time, 'fmDay') = 'Sunday';

--(Rischert, 2010, 205)
--Despliega el id de la sección y la fecha de inicio cuya fecha de inicio esté entre el 01 de julio y 31 de julio del 2007.
--PRECAUCIÓN: Esta instrucción evalua texto literal. Cosas muy raras pasan cuando se hace esto.
--Ej. 14-APR-2007 entra en la condición porque 1 está entre el rango de 0 y 3
SELECT section_id, 
TO_CHAR(start_date_time, 'DD-MON-YYYY HH24:MI:SS')
FROM section
WHERE TO_CHAR(start_date_time, 'DD-MON-YYYY HH24:MI:SS')
>= '01-JUL-2007 00:00:00'
AND TO_CHAR(start_date_time, 'DD-MON-YYYY HH24:MI:SS')
<= '31-JUL-2007 23:59:59';

--(Rischert, 2010, 206)--(Rischert, 2010, 206)
--No regresa nada porque '9' no está en el rango de '0' y '3'
SELECT *
FROM dual
WHERE '9' BETWEEN '01' AND '31';

--(Rischert, 2010, 206)
--'1' está en el rango de '0'  y '3', entonces regresa el contenido de dual (x);
SELECT *
FROM dual
WHERE '14-APR-2007 09:30:00' BETWEEN '01-JUL-2007 00:00:00'
AND '31-JUL-2007 23:59:59';

--(Rischert, 2010, 207)
--Despliega el no. de curso, el id de la sección y la fecha de inicio cuyo día de inicio sea el Domingo.
--TO_CHAR() también se puede usar en las consultas.
SELECT course_no, section_id,
TO_CHAR(start_date_time, 'Day DD-Mon-YYYY HH:MI am')
FROM section
WHERE TO_CHAR(start_date_time, 'fmDay') = 'Sunday';

--========================================================================================================================
--													Ejercicios 5.1

--a) Display the course number, section ID, and starting date and time for sections taught on May 4, 2007.
SELECT course_no, section_id, TO_CHAR(start_date_time, 'DD-MM-YYYY HH24:MI')
FROM course
WHERE TRUNC(start_date_time) = TO_DATE('04-MAY-2007', 'DD-MON-YYYY');

--b) Show the student records that were modified on or before January 22, 2007. Display the date a
--record was modified and each student’s first and last name, concatenated in one column.
SELECT first_name||' '||last_name Nombre,
TO_CHAR(modified_date, 'DD-MM-YYYY HH:MI P.M.') Modificacion
from student
WHERE TRUNC(modified_date) <= TO_DATE('22-01-2007', 'DD-MM-YYYY');

--c) Display the course number, section ID, and starting date and time for sections that start on Sundays.
SELECT course_no, section_id
TO_CHAR(start_date_time, 'DY DD-MON-YYYY HH:MI am')
FROM section
WHERE TO_CHAR(start_date_time, 'DY') = 'SUN';

--d) List the section ID and starting date and time for all sections that begin and end in July 2007.
SELECT section_id, 
TO_CHAR(start_date_time, 'DD-MON-YYYY HH24:MI:SS')
FROM Section
WHERE start_date_time >= TO_DATE('01-07-2007', 'DD-MM-YYYY')
AND start_date_time < TO_DATE('01-08-2007', 'DD-MM-YYYY')
--WHERE start_date_time BETWEEN
--TO_DATE('07/01/2007', 'MM/DD/YYYY')
--AND TO_DATE('07/31/2007 23:59:59', 'MM/DD/YYYY HH24:MI:SS')

--e) Determine the day of the week for December 31, 1899.
SELECT TO_CHAR(TO_DATE('31-12-1899', 'DD-MM-YYYY'), 'Dy')
FROM dual;


--f) Execute the following statement. Write the questions to obtain the desired result. Pay particular
--attention to the ORDER BY clause.

--Despliega la sección y su día de inicio de la tabla section cuya ID sea 146 o 127 o 121 o 155 o 110 o 85
-- o 148. Las tuplas deben de estar ordenadas por los días de la semana iniciando en Domingo.
SELECT 'Section '||section_id||' begins on '||
TO_CHAR(start_date_time, 'fmDay')||'.' AS "Start"
FROM section
WHERE section_id IN (146, 127, 121, 155, 110, 85, 148)
ORDER BY TO_CHAR(start_date_time, 'D');

--========================================================================================================================

/*												CAP 5
|||||||||||||||||||||||||||||||||||||| 5.2 "Performing Date and Time Math" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 210)
--Despliega la fecha del sistema operativo de la maquina en la que se encuentra la DB.
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI')
FROM dual;

--(Rischert, 2010, 210)
--Despliega los días que faltan para el 01 de enero del 2025.
SELECT TO_DATE('01-JAN-2025','DD-MON-YYYY')-TRUNC(SYSDATE) int,  --En enteros
TO_DATE('01-JAN-2025','DD-MON-YYYY')-SYSDATE dec --En decimales
FROM dual;

--(Rischert, 2010, 211)
--Despliega la hora actual del sistema, la que será en 3 horas, en un día y 36 horas después.
--Los días se manejan como números enteros.
SELECT TO_CHAR(SYSDATE, 'MM/DD HH24:MI:SS') now,
TO_CHAR(SYSDATE+3/24, 'MM/DD HH24:MI:SS')
AS now_plus_3hrs,
TO_CHAR(SYSDATE+1, 'MM/DD HH24:MI:SS') tomorrow,
TO_CHAR(SYSDATE+1.5, 'MM/DD HH24:MI:SS') AS
"36Hrs from now"
FROM dual;

--(Rischert, 2010, 211)
--Despliega la fecha de la víspera del nuevo año 2000 y la fecha del primer Domingo del año 2000.
SELECT TO_CHAR(TO_DATE('12/31/1999','MM/DD/YYYY'),
'MM/DD/YYYY DY') "New Year's Eve",
TO_CHAR(NEXT_DAY(TO_DATE('12/31/1999',
'MM/DD/YYYY'),
'SUNDAY'),'MM/DD/YYYY DY')
"First Sunday"
FROM dual;

--(Rischert, 2010, 212)
--Despliega y redondea de dos formas diferentes la fecha del sistema.
SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI') now, 
TO_CHAR(ROUND(SYSDATE),'DD-MON-YYYY HH24:MI') day, --Redondea a las 00:00
TO_CHAR(ROUND(SYSDATE,'MM'),'DD-MON-YYYY HH24:MI') --Redondea al 1er día el mes más cercano usando 'MM'.
mon
FROM dual;

--(Rischert, 2010, 212)
--Despliega las fechas de inicio y la extracción de su mes, año y días
-- de la tabla section en donde el mes de inicio sea el 4, y los ordena por mes.
SELECT TO_CHAR(start_date_time, 'DD-MON-YYYY') "Start Date",
EXTRACT(MONTH FROM start_date_time) "Month", --Extrae el mes
EXTRACT(YEAR FROM start_date_time) "Year", --Extrae el año
EXTRACT(DAY FROM start_date_time) "Day" --Extrae el día 
FROM section
WHERE EXTRACT(MONTH FROM start_date_time) = 4
ORDER BY start_date_time;

--(Rischert, 2010, 212)
--Despliega la extracción de año, mes y día de una fecha en texto. La fecha está en ANSI format.
SELECT EXTRACT(YEAR FROM DATE '2010-03-11') year, 
EXTRACT(MONTH FROM DATE '2010-03-11') month,
EXTRACT(DAY FROM DATE '2010-03-11') day
FROM dual;

--========================================================================================================================
--													Ejercicios 5.2

--a) Determine the number of days between February 13, 1964, and the last day of the February 1964.
SELECT LAST_DAY(TO_DATE('13-FEB-1964','DD-MON-YYYY')) - TO_DATE('13-FEB-1964','DD-MON-YYYY') days
FROM dual;

--b) Compute the number of months between September 29, 1999, and August 17, 2007.
SELECT MONTHS_BETWEEN(TO_DATE('17-AUG-2007','DD-MON-YYYY'), 
TO_DATE('29-SEP-1999','DD-MON-YYYY')) months
FROM dual;

--c) Add three days to the current date and time.
SELECT TO_CHAR(SYSDATE+3, 'DD-MON-YYYY HH24:MI:SS') "3 días después..."
FROM dual;

--========================================================================================================================

/*												CAP 5
||||||||||||||||||||||||||||| 5.3 "Understanding the TIMESTAMP and TIME ZONE Data Types"|||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 221)
--Despliega la fecha y hora (local) actual del sistema. Incluye en la hora los ms.
SELECT LOCALTIMESTAMP
FROM dual;

--(Rischert, 2010, 222)
--Despliega la fecha y hora actual del sistema. Incluye en la hora los ms y la zona horaria de acuerdo al UTC.
SELECT SYSTIMESTAMP
FROM dual;

--(Rischert, 2010, 222)
--Despliega el tiempo de la sesión (de la computadora de la sesión) y el tiempo local (del servidor).
--CURRENT_TIMESTAMP incluye la zona horaria.
--No tienen el mismo tipo de dato.
SELECT CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM dual;

--(Rischert, 2010, 222)
--Despliega la fecha y hora de la sesión (de la computadora de la sesión, no del servidor).
SELECT TO_CHAR(CURRENT_DATE, 'DD-MON-YYYY HH:MI:SS PM') 
FROM dual;

--(Rischert, 2010, 223)
--Despliega la zona horaria en la que se encuentra la sesión.
SELECT SESSIONTIMEZONE
FROM dual;

--(Rischert, 2010, 224)
--Cambia la zona horaria de la sesión.
ALTER SESSION SET TIME_ZONE = 'America/New_York'; --A una región
ALTER SESSION SET TIME_ZONE = dbtimezone; --A la misma del servidor
ALTER SESSION SET TIME_ZONE = local; --Resetea a la zona horaria de la sesión.

--(Rischert, 2010, 224)
--Despliega la zona horaria del servidor.
SELECT DBTIMEZONE
FROM dual;

--(Rischert, 2010, 225)
--Despliega las dos timestaps (escritas en ANSI) convertidas de tiempo local a UTC.
--SYS_EXTRACT_UTC convierte un valor de tipo TIMESTAMP WITH TIME ZONE a UTC.
SELECT SYS_EXTRACT_UTC(TIMESTAMP '2009-02-11 7:00:00 -8:00')
"West coast to UTC",
SYS_EXTRACT_UTC(TIMESTAMP '2009-02-11 10:00:00 -5:00')
"East coast to UTC"
FROM dual;

--(Rischert, 2010, 226)
--Extrae la hora, los minutos, los segundos, el año, el mes y el día de la misma TIMESTAMP.
--El tipo de dato es TIMESTAMP.
SELECT EXTRACT(HOUR FROM TIMESTAMP '2009-02-11 15:48:01.123') hour,
EXTRACT(MINUTE FROM TIMESTAMP '2009-02-11 15:48:01.123') minute,
EXTRACT(SECOND FROM TIMESTAMP '2009-02-11 15:48:01.123') second,
EXTRACT(YEAR FROM TIMESTAMP '2009-02-11 15:48:01.123') year,
EXTRACT(MONTH FROM TIMESTAMP '2009-02-11 15:48:01.123') month,
EXTRACT(DAY FROM TIMESTAMP '2009-02-11 15:48:01.123') day
FROM dual;

--(Rischert, 2010, 226)
--Despliega col_timestamp_w_tz y extrae el año, mes, día, hora, minuto y segundos de este mismo, de la tabla date_example.
--El tipo de dato de col_timestamp_w_tz es TIMESTAMP WITH TIME ZONE.
SELECT col_timestamp_w_tz,
EXTRACT(YEAR FROM col_timestamp_w_tz) year,
EXTRACT(MONTH FROM col_timestamp_w_tz) month,
EXTRACT(DAY FROM col_timestamp_w_tz) day,
EXTRACT(HOUR FROM col_timestamp_w_tz) hour,
EXTRACT(MINUTE FROM col_timestamp_w_tz) min,
EXTRACT(SECOND FROM col_timestamp_w_tz) sec
FROM date_example;

--(Rischert, 2010, 227)
--Despliega la zona, los minutos de la zona, la región y la abreviación de la zona.
--Si la region no está configurada o es ambigua, tanto region y ABBR serán UNKNOWN.
SELECT col_timestamp_w_tz,
EXTRACT(TIMEZONE_HOUR FROM col_timestamp_w_tz) tz_hour,
EXTRACT(TIMEZONE_MINUTE FROM col_timestamp_w_tz) tz_min,
EXTRACT(TIMEZONE_REGION FROM col_timestamp_w_tz) tz_region,
EXTRACT(TIMEZONE_ABBR FROM col_timestamp_w_tz) tz_abbr
FROM date_example;

--(Rischert, 2010, 227)
--Describe el tipo de datos de las columnas de date_example.
DESCRIBE date_example;

--(Rischert, 2010, 228)
--Despliega col_timestamp_w_tz de la tabla date_example donde col_timestamp_w_tz sea igual que a la TIMESTAMP
-- 24-FEB-09 04.25.32.000000.
--TO_TIMESTAMP_TZ convierte un texto en TIMESTAMP WITH TIME ZONE.
SELECT col_timestamp_w_tz
FROM date_example
WHERE col_timestamp_w_tz = TO_TIMESTAMP_TZ
('24-FEB-09 04.25.32.000000 PM -05:00',
'DD-MON-RR HH.MI.SS.FF AM TZH:TZM');

--(Rischert, 2010, 229)
--Despliega col_timestamp_w_tz pero en la zona local 'America/Los_Angeles' y no en UTC.
SELECT col_timestamp_w_tz AT TIME ZONE 'America/Los_Angeles'
FROM date_example;
 
--(Rischert, 2010, 229)
--Despliega col_timestamp_w_tz pero en la zona UTC de la base de datos.
SELECT col_timestamp_w_tz AT TIME ZONE DBTIMEZONE
FROM date_example;

--(Rischert, 2010, 232)
--Se puede comparar TIMESTAMP y DATE porque Oracle hace la conversión automatica, dejando los ms en 0.
SELECT col_timestamp
FROM date_example
WHERE col_timestamp = TO_DATE('24-FEB-2009 04:25:32 PM',
'DD-MON-YYYY HH:MI:SS AM');

--(Rischert, 2010, 233)
--Despliega la conversión de col_date a TIMESTAMP y a CHAR.
SELECT TO_TIMESTAMP(col_date) "TO_TIMESTAMP", --Pone la hora en la media noche
TO_CHAR(col_date, 'DD-MON-YYYY HH24:MI')
AS "DISPLAY DATE"
FROM date_example;

--(Rischert, 2010, 235)
--Despliega la zona UTC de las siguientes regiones.
SELECT TZ_OFFSET('Europe/London') "London",
TZ_OFFSET('America/New_York') "NY",
TZ_OFFSET('America/Chicago') "Chicago",
TZ_OFFSET('America/Denver') "Denver",
TZ_OFFSET('America/Los_Angeles') "LA"
FROM dual;

--(Rischert, 2010, 235)
--Da error porque ya se está usando la máscara HH24 con A.M./P.M. Estos solo se pueden usar con HH o HH12.
SELECT col_timestamp_w_tz
FROM date_example
WHERE col_timestamp_w_tz =
TO_TIMESTAMP_TZ('24-FEB-2009 16:25:32 PM -05:00',
'DD-MON-YYYY HH24:MI:SS PM TZH:TZM');

--========================================================================================================================
--													Ejercicios 5.3

--a) Describe the default display formats of the result returned by the following SQL query.
SELECT col_date, col_timestamp, col_timestamp_w_tz
FROM date_example;
/*
COL_DATE  COL_TIMESTAMP 			   COL_TIMESTAMP_W_TZ
--------- ---------------------------- ------------------
24-FEB-09 24-FEB-09 04.25.32.000000 PM 24-FEB-09 04.25.32.000000 PM -05:00
1 row selected.
*/
--Despliega los valores de las columnas col_date, col_timestamp y col_timestamp_w_tz en formato 
--DD-MM-RR HH.MI.SS.FF AM +/- TZH:TZM.

--b) Explain the result of the following SELECT statement. Are there alternate ways to rewrite the
--query’s WHERE clause?
SELECT col_timestamp
FROM date_example
WHERE col_timestamp = '24-FEB-09 04.25.32.000000 PM';
/*
COL_TIMESTAMP
----------------------------
24-FEB-09 04.25.32.000000 PM
1 row selected.
*/
--Despliega el uso del tipo de dato TIMESTAMP. Se podría reescribir la condición con un
--WHERE col_timestamp = TO_TIMESTAMP('24-FEB-2009 04:25:32.000000 PM', 'DD-MON-YYYY HH:MI:SS.FF AM')
--para que la conversión sea explícita.

--c) What function can you utilize to display the seconds component of a TIMESTAMP data type
--column?
--La función EXTRACT(SECOND FROM '') o TO_CHAR('', 'SS')

--d) What do you observe about the text literal of the following query’s WHERE clause?
SELECT col_timestamp_w_tz
FROM date_example
WHERE col_timestamp_w_tz = '24-FEB-09 04.25.32.000000 PM -05:00'
/*
COL_TIMESTAMP_W_TZ
-----------------------------------
24-FEB-09 04.25.32.000000 PM -05:00
1 row selected.
*/
--Despliega la columna col_timestamp_w_tz usando un timestamp with timezone en forma textual.
--La conversión se hace implícitamente.

--e) The following SQL statements are issued against the database server. Explain the results.
SELECT SESSIONTIMEZONE
FROM dual;
/*
SESSIONTIMEZONE
---------------
-05:00
1 row selected.
*/
SELECT col_timestamp_w_tz, col_timestamp_w_local_tz
FROM date_example;
/*
COL_TIMESTAMP_W_TZ 					COL_TIMESTAMP_W_LOCAL_TZ
----------------------------------- ----------------------------
24-FEB-09 04.25.32.000000 PM -05:00 24-FEB-09 04.25.32.000000 PM
1 row selected.
*/
ALTER SESSION SET TIME_ZONE = '-8:00';
--Session altered.
SELECT col_timestamp_w_tz, col_timestamp_w_local_tz
FROM date_example;
/*
COL_TIMESTAMP_W_TZ 					COL_TIMESTAMP_W_LOCAL_TZ
----------------------------------- ----------------------------
24-FEB-09 04.25.32.000000 PM -05:00 24-FEB-09 01.25.32.000000 PM
1 row selected.
*/
ALTER SESSION SET TIME_ZONE = '-5:00';
--Session altered.

--Al modificar el parámetro TIME_ZONE, solo afecta la forma en que se muestran los valores de tipo TIMESTAMP WITH LOCAL TIME
--ZONE. Estos valores almacenan internamente la fecha y hora en UTC, pero cuando se consultan, se convierten automáticamente a
--la zona horaria de la sesión. Esto los diferencia de los valores TIMESTAMP WITH TIME ZONE, que almacenan explícitamente la
--zona horaria con la que fueron guardados y al consultarse, no ajustan su valor a la zona horaria de la sesión.

--========================================================================================================================

/*												CAP 5
||||||||||||||||||||||||||||| 5.4 "Performing Calculations with the Interval Data Types"|||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 240)
--Despliega el id del estudiante, su fecha de regristro y su "fecha de graduación" cuya id sea 123.
--TO_YMINTERVAL('01-06') representa 1 año y 6 meses, y se suma a la fecha de registro.
SELECT student_id, registration_date,
registration_date+TO_YMINTERVAL('01-06') "Grad. Date"
FROM student
WHERE student_id = 123;

--(Rischert, 2010, 241)
--Extrae los minutos del intervalo de 12 horas y 51 minutos.
SELECT EXTRACT(MINUTE FROM INTERVAL '12:51' HOUR TO MINUTE)
FROM dual;

--(Rischert, 2010, 241)
--Despliega la fecha de creación, la fecha de inicio, la diferencia entre la fecha de inicio y creación (en decimales)
-- y la diferencia en días, horas, minutos, segundos y ms.
SELECT DISTINCT TO_CHAR(created_date, 'DD-MON-YY HH24:MI') 
"CREATED_DATE",
TO_CHAR(start_date_time, 'DD-MON-YY HH24:MI')
"START_DATE_TIME",
start_date_time-created_date "Decimal",
NUMTODSINTERVAL(start_date_time-created_date,'DAY')
"Interval"
FROM section
ORDER BY 3;

--(Rischert, 2010, 242)
--Despliega el valor de col_timestamp y la diferencia entre SYSTIMESTAMP y col_timestamp expresada en días,
-- horas, minutos, segundos y ms.
--La precisión de DAY es puesta en 4 para aceptar números más largos.
SELECT col_timestamp,
(SYSTIMESTAMP - col_timestamp) DAY(4) TO SECOND
"Interval Day to Second"
FROM date_example;

--(Rischert, 2010, 243)
--Despliega el valor de col_timestamp, la diferencia entre SYSTIMESTAMP y col_timestamp y lo expresa en un
-- intervalo de años-meses.
SELECT col_timestamp,
(SYSTIMESTAMP - col_timestamp) YEAR TO MONTH
"Interval Year to Month"
FROM date_example;

--(Rischert, 2010, 243)
--Describe las columnas de la tabla meeting.
DESCRIBE meeting;

--(Rischert, 2010, 243)
--Despliega la id de las juntas, su fecha y hora de inicio y fin de la tabla meeting. 
SELECT meeting_id,
TO_CHAR(meeting_start, 'DD-MON-YYYY HH:MI PM') "Start",
TO_CHAR(meeting_end, 'DD-MON-YYYY HH:MI PM') "End"
FROM meeting;

--(Rischert, 2010, 244)
--Despliega la id de las juntas, su fecha y hora de inicio y fin de la tabla meeting, donde la fecha de inicio
-- y fin se superponen al día 1 de Julio del 2009 a las 3:30 PM en un intervalo de 2 horas.
SELECT meeting_id,
TO_CHAR(meeting_start, 'dd-mon-yyyy hh:mi pm') "Start",
TO_CHAR(meeting_end, 'dd-mon-yyyy hh:mi pm') "End"
FROM meeting
WHERE (meeting_start, meeting_end)
OVERLAPS
(to_date('01-JUL-2009 3:30 PM', 'DD-MON-YYYY HH:MI PM'),
INTERVAL '2' HOUR);

--(Rischert, 2010, 244)
--Despliega la id de las juntas, su fecha y hora de inicio y fin de la tabla meeting, donde la fecha de inicio
-- y fin NO se superponen al día 1 de Julio del 2009 a las 3:30 PM en un intervalo de 2 horas.
SELECT meeting_id,
TO_CHAR(meeting_start, 'DD-MON-YYYY HH:MI PM') "Start",
TO_CHAR(meeting_end, 'DD-MON-YYYY HH:MI PM') "End"
FROM meeting
WHERE NOT (meeting_start, meeting_end)
OVERLAPS
(TO_DATE('01-JUL-2009 3:30PM', 'DD-MON-YYYY HH:MI PM'),
INTERVAL '2' HOUR);
--SINTAXIS: event OVERLAPS event

--========================================================================================================================
--													Ejercicios 5.4

--a) Explain the result of the following SQL statement.
--Despliega, de la tabla section, la id de la sección, la fecha de creación, la fecha de inicio y el intervalo de días y
-- horas que hay entre la fecha de creación y de inicio, donde el intervalo está entre los 100 y 120 días.
--El despliegue se hace en orden del menor intervalo al mayor.
SELECT section_id "ID",
TO_CHAR(created_date, 'MM/DD/YY HH24:MI')
"CREATED_DATE",
TO_CHAR(start_date_time, 'MM/DD/YY HH24:MI')
"START_DATE_TIME",
NUMTODSINTERVAL(start_date_time-created_date, 'DAY')
"Interval"
FROM section
WHERE NUMTODSINTERVAL(start_date_time-created_date, 'DAY')
BETWEEN INTERVAL '100' DAY(3) AND INTERVAL '120' DAY(3)
ORDER BY 3;
/*
ID 	CREATED_DATE   START_DATE_TIM Interval
--- -------------- -------------- ----------------------
79 	01/02/07 00:00 04/14/07 09:30 102 09:29:59.999999999
87 	01/02/07 00:00 04/14/07 09:30 102 09:29:59.999999999
...
152 01/02/07 00:00 04/29/07 09:30 117 09:29:59.999999999
125 01/02/07 00:00 04/29/07 09:30 117 09:29:59.999999999
17 rows selected.
*/

--b) Explain the result of the following SQL statements. What do you observe?
SELECT NUMTODSINTERVAL(360, 'SECOND'),
NUMTODSINTERVAL(360, 'MINUTE')
FROM dual;
/*
NUMTODSINTERVAL(360,'SECOND') NUMTODSINTERVAL(360,'MINUTE')
----------------------------- -----------------------------
0 0:6:0.0 					  0 6:0:0.0
1 row selected.
*/
--Despliega el intervalo de 360 segundos expresados en 6 minutos y también el intervalo de 360 minutos
-- expresado en 6 horas.
--El NUM es interpretado de acuerdo al segundo parámetro.

SELECT NUMTODSINTERVAL(360, 'HOUR'),
NUMTODSINTERVAL(360, 'DAY')
FROM dual;
/*
NUMTODSINTERVAL(360,'HOUR')   NUMTODSINTERVAL(360,'DAY')
----------------------------- -----------------------------
15 0:0:0.0 					  360 0:0:0.0
1 row selected.
*/
--Despliega el intervalo de 360 horas expresados en 15 días y también el intervalo de 360 días
-- expresado en 360 días.

--Si NUM excede el rango de los valores que puede aceptar, ej. las horas, lo expresa en días, y si hay
-- resto, este se expresa en horas.
--========================================================================================================================

/*												CAP 5
||||||||||||||||||||||||||||||||||| 5.5 "Converting from One Data Type to Another" |||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 249)
--Despliega, de la tabla course, el no. de curso y la descripción donde el no. de curso sea igual a 350.
--Se hace una conversión implícita de '350' a 350 (número).
SELECT course_no, description
FROM course
WHERE course_no = '350';

--(Rischert, 2010, 250)
--Describe las columnas de la tabla conversion_example.
DESCRIBE conversion_example;

--(Rischert, 2010, 250)
--Despliega todas las tuplas de la tabla conversion_example.
SELECT *
FROM conversion_example;

--(Rischert, 2010, 250)
--Despliega, de la tabla conversion_example, la tupla donde el no. de curso es igual a '123'.
SELECT *
FROM conversion_example
WHERE course_no = '123';

--(Rischert, 2010, 250)
--Da un error, porque implicitamente se van a convertir los valores de la columna course_no a números, pero no
--todos los valores son aptos para esta conversión.
SELECT *
FROM conversion_example
WHERE course_no = 123;

--(Rischert, 2010, 251)
--Despliega, de la tabla conversion_example, la tupla donde el no. de curso es igual a '123'.
--Hace una conversión explícita para evitar el error anterior.
SELECT *
FROM conversion_example
WHERE course_no = TO_CHAR(123);

--(Rischert, 2010, 251)
--Despliega, de la tabla conversion_example, la tupla donde el no. de curso es igual a '123'.
--La func CAST() hace una conversión de un tipo de dato a otro. 
--En este caso, hay que especificar el tamaño.
SELECT *
FROM conversion_example
WHERE course_no = CAST(123 AS VARCHAR2(3));

--(Rischert, 2010, 251)
--Despliega la fecha 29 de marzo del 2009 como tipo DATE y TIMESTAMP WITH LOCAL TIME ZONE.
--La fecha se da en texto y se le aplica un casteo a los tipos correspondientes.
SELECT CAST('29-MAR-09' AS DATE) DT,
CAST('29-MAR-09' AS TIMESTAMP WITH LOCAL TIME ZONE) TZ
FROM dual;

--(Rischert, 2010, 252)
--Despliega, de la tabla section, la id de la sección y la fecha de inicio en donde la fecha de inicio
--esté entre el primer y último día de julio del 2007.
--Las fechas en la condición se dan como textos pero se les aplica un casteo.
SELECT section_id,
TO_CHAR(start_date_time, 'DD-MON-YYYY HH24:MI:SS')
FROM section
WHERE start_date_time >= CAST('01-JUL-2007' AS DATE)
AND start_date_time < CAST('01-AUG-2007' AS DATE)

--(Rischert, 2010, 252)
--Despliega la fecha 4 de Julio del 2007 con la hora de las 7 AM (por la zona horaria).
--Aplica un casteo al texto '04-JUL-2007 10:00:00 AM' para convertirlo a un tipo timestamp, ya que 
--la función FROM_TZ() requiere como primer parámetro ese tipo de dato.
SELECT FROM_TZ(CAST('04-JUL-2007 10:00:00 AM' AS TIMESTAMP),
'America/New_York') AT TIME ZONE 'America/Los_Angeles'
"FROM_TZ Example"
FROM dual;

--(Rischert, 2010, 252)
--Despliega 3 veces el intervalo de 1 año y 6 meses.
--Hay diferentes formas de hacer lo mismo.
SELECT CAST('1-6' AS INTERVAL YEAR TO MONTH) "CAST",
TO_YMINTERVAL('1-6') "TO_YMINTERVAL",
NUMTOYMINTERVAL(1.5, 'YEAR') "NUMTOYMINTERVAL"
FROM dual;

--(Rischert, 2010, 253)
--Despliega el costo, de la tabla course, como BINARY_FLOAT de aquellos cursos cuyo no. de curso sea menor a 80.
SELECT CAST(cost AS BINARY_FLOAT) AS cast,
TO_BINARY_FLOAT(cost) AS to_binary_float
FROM course
WHERE course_no < 80;

--(Rischert, 2010, 254)
--Despliega, de la tabla course, el no. de curso, el costo y el costo, pero con formato, de aquellos cursos cuyo no.
--de curso sea menor a 25.
SELECT course_no, cost,
TO_CHAR(cost, '999,999') formatted
FROM course
WHERE course_no < 25;

--(Rischert, 2010, 254)
--Despliega, de la tabla course, el no. de curso, el costo y el costo, pero con formato, de aquellos cursos cuyo no.
--de curso sea menor a 25.
--El formato ahora se aplica únicamente para la columna "SQL*PLUS" y para la columna "CHAR" mediante la fun TO_CHAR().
COL "SQL*PLUS" FORMAT 999,999;
SELECT course_no, cost "SQL*PLUS",
TO_CHAR(cost, '999,999') "CHAR"
FROM course
WHERE course_no < 25;

--========================================================================================================================
--													Ejercicios 5.5

/*Use the following SQL statement as the source query for Exercises a through c.
SELECT zip, city
FROM zipcode
WHERE zip = 10025;*/

--a) Rewrite the query, using the TO_CHAR function in the WHERE clause.
SELECT zip, city
FROM zipcode
WHERE zip = TO_CHAR(10025);

--b) Rewrite the query, using the TO_NUMBER function in the WHERE clause.
SELECT zip, city
FROM zipcode
WHERE TO_NUMBER(zip) = 10025;

--c) Rewrite the query, using CAST in the WHERE clause.
SELECT zip, city
FROM zipcode
WHERE zip = CAST(10025 AS VARCHAR2(5));

--d) Write the SQL statement that displays the following result. Note that the last column in the result
--shows the formatted COST column with a leading dollar sign and a comma to separate the
--thousands. Include the cents in the result as well.
/*
COURSE_NO COST 		FORMATTED
--------- --------- ---------
330 	  1195 		$1,195.00
1 row selected.
*/
SELECT course_no, cost, TO_CHAR(cost, '$999,999.99') AS "FORMATTED"
FROM course
WHERE course_no = 330;

--e) List the COURSE_NO and COST columns for courses that cost more than 1500. The third, fourth,
--and fifth columns show the cost increased by 15 percent. Display the increased cost columns, one
--with a leading dollar sign, and separate the thousands, and in another column show the same
--formatting but rounded to the nearest dollar. The result should look similar to the following
--output.
/*
COURSE_NO  OLDCOST 	  NEWCOST  FORMATTED  ROUNDED
---------- ---------- -------- ---------- ----------
80 		   1595 	  1834.25  $1,834.25  $1,834.00
1 row selected
*/
SELECT course_no, cost AS "OLDCOST",
cost*1.15 AS "NEWCOST",
TO_CHAR(cost*1.15, '$999,999.99') AS "FORMATTED",
TO_CHAR(ROUND(cost*1.15), '$999,999.99') AS "ROUNDED"
FROM course
WHERE cost > 1500;

--f) Based on Exercise e, write the query to achieve this result. Use the fm format mask to eliminate
--the extra spaces.
/*
Increase
---------------------------------------------------------
The price for course# 80 has been increased to $1,834.25.
1 row selected.
*/

SELECT 'The price for course# '||course_no||' has been increased to '||TO_CHAR(cost*1.15, 'fm$999,999.99')||'.'
FROM course
WHERE cost > 1500;


--========================================================================================================================


SPOOL OFF
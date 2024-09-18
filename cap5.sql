/*												CAP 5
|||||||||||||||||||||||||||||||||||||| 5.1 "Applying Oracle's Date Format Models" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
col parameter format a36;
col value format a35;
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
--Despliega un error porque el formato de fehca tiene que concordar con el texto.
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
WHERE TO_CHAR(start_date_time, 'Day') = 'Sunday'

--(Rischert, 2010, 204)
--Despliega el no. de curso, la id de la sección y la fecha de inicio de la tabla sección donde la 
-- fecha de inicio sea Domingo.
--'fm' (fill mode) quita los espacios extra.
SELECT course_no, section_id,
TO_CHAR(start_date_time, 'Day DD-Mon-YYYY HH:MI am')
FROM section
WHERE TO_CHAR(start_date_time, 'fmDay') = 'Sunday'

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
WHERE '9' BETWEEN '01' AND '31'

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
WHERE TO_CHAR(start_date_time, 'fmDay') = 'Sunday'

--========================================================================================================================
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
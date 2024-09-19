SPOOL C:\guest\schemasetup\Cap3OUT.txt
REM Zarate Lozano Luis Axel
REM 3BM2

REM CAP 3
REM |||||||||||||||||||||||||||||||||||||| 3.1 "The WHERE Clause" ||||||||||||||||||||||||||||||||||||||
REM Rischert, A. (2010). Oracle SQL By Example.

set pagesize 300;
set linesize 250;
col parameter format a36;
col value format a35;
set colsep '||';
set null n/Datos;

REM (Rischert, 2010, 103)
REM Despliega datos del instructor donde el apellido sea igual 'Schorin'
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name = 'Schorin';

REM (Rischert, 2010, 103)
REM Despliega datos del instructor donde el apellido sea igual 'schorin'
REM No se seleccionará ninguna fila, porque se toman en cuenta mayús y minús.
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name = 'schorin'; 
	 

REM (Rischert, 2010, 103)
REM Selecciona los datos del instructor
REM donde el instructor es diferente(<>) de 'Schorin'
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name <> 'Schorin';
	
REM (Rischert, 2010, 104)
REM Despliega la descripción y costo de los cursos que cuesten más de 1195
SELECT description, cost
FROM course
WHERE cost >= 1195;

REM (Rischert, 2010, 104)
REM Despliega la descripción y costo de los cursos cuyos costos estén entre
REM 1000 y 1100.
SELECT description, cost
FROM course
WHERE cost BETWEEN 1000 AND 1100;
	
REM (Rischert, 2010, 105)
REM Despliega la descripción y costo de los cursos cuyo costo sea 1095 o 1595
SELECT description, cost
FROM course
WHERE cost IN (1095, 1595);

REM (Rischert, 2010, 105)
REM Selecciona los datos del instructor cuyo apellido concuerde con el patrón 'S%'
REM '%' denota más carácteres antes o después del patrón.
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name LIKE 'S%';
	
REM (Rischert, 2010, 105)
REM Selecciona los datos del instructor cuyo apellido concuerde con el patrón '_o%'
REM '_' denota un carácter antes o después del patrón.
SELECT first_name, last_name
FROM instructor
WHERE last_name LIKE '_o%';
	
REM (Rischert, 2010, 106)
REM Selecciona los datos del instructor cuyo apellido no concuerde con el patrón 'S%'
REM Not nega los operadores anteriores.
SELECT phone
FROM instructor
WHERE last_name NOT LIKE 'S%';
	
REM (Rischert, 2010, 106)
REM Despliega la descripción y costo de los cursos cuyo prerequisito sea nulo
SELECT description, prerequisite
FROM course
WHERE prerequisite IS NULL;

REM (Rischert, 2010, 107)
REM Despliega la descripción y costo de los cursos cuyo costo sea 1095 y la
REM descripción siga el patrón 'I%'
SELECT description, cost
FROM course
WHERE cost = 1095
AND description LIKE 'I%';

REM (Rischert, 2010, 107)
REM Despliega la descripción, costo y prerequisitos de los cursos cuyo
REM costo sea 1195, el prerequisito 20 o 25.
SELECT description, cost, prerequisite
FROM course
WHERE cost = 1195
AND prerequisite = 20
OR prerequisite = 25;

REM (Rischert, 2010, 108)	
REM Despliega la descripción, costo y prerequisitos de los cursos cuyo
REM costo sea 1195, el prerequisito 20 o 25.
SELECT description, cost, prerequisite
FROM course
WHERE cost = 1195
AND (prerequisite = 20
OR prerequisite = 25);

REM (Rischert, 2010, 109)
REM Despliega la descripción y prerequisitos de los cursos cuya descripción siga
REM el patrón 'Intro to%' y cuyo prerequisito sea mayor o igual al 140.
REM en SQL existe True, False y Unknown. Unknown no es mayor o menor que algo, entonces
REM no se desplegaran las columnas donde el prerequisito sea NULL. 
REM Null es Unknown
SELECT description, prerequisite
FROM course
WHERE description LIKE 'Intro to%'
AND prerequisite >= 140;
	
REM (Rischert, 2010, 109)
REM Despliega la descripción, prerequisitos y costo de los cursos cuyo prerequisito sea nulo.
SELECT description, prerequisite, cost
FROM course
WHERE prerequisite IS NULL;
	
REM (Rischert, 2010, 110)
REM Despliega la descripción y prerequisitos de los cursos cuya descripción siga
REM el patrón 'Intro to%' ó cuyo prerequisito sea mayor o igual al 140.
SELECT description, prerequisite
FROM course
WHERE description LIKE 'Intro to%'
OR prerequisite >= 140;

REM (Rischert, 2010, 110)	
REM Despliega la descripción y prerequisitos de los cursos cuyo prerequisito no sea mayor a 140.
REM Not(Unknown) = Unknown (no se desplegarán Nulls)
SELECT description, prerequisite
FROM course
WHERE NOT prerequisite >= 140;
	
REM (Rischert, 2010, 114)
REM BETWEEN también funciona con texto.
REM Selecciona los datos de los estudiantes cuyo apellido esté entre la W y Z
SELECT student_id, last_name
FROM student
WHERE last_name BETWEEN 'W' AND 'Z';

REM (Rischert, 2010, 114)	
REM Selecciona los datos de los estudiantes cuyo apellido esté entre la W y Z o entre la w y z
SELECT student_id, last_name
FROM student
WHERE last_name BETWEEN 'W' AND 'Z'
OR last_name BETWEEN 'w' AND 'z';

REM (Rischert, 2010, 114)
REM Selecciona las descripciones de los tipos de grado cuya descripción esté entre Midterm y Project.
SELECT description
FROM grade_type
WHERE description BETWEEN 'Midterm' and 'Project';
	REM Equivalente a:
	REM SELECT description
	REM FROM grade_type
	REM WHERE description >= 'Midterm'
	REM AND description <= 'Project';

REM ====================================================================================================================
REM													Ejercicios 3.1
REM EJERCICIOS 3.1 
REM a) Write a SELECT statement that lists the last names of students living in either zip code 10048, 11102, or 11209.
SELECT last_name
FROM student
WHERE zip in ('10048', '11102', '11209');

REM b) Write a SELECT statement that lists the first and last names of instructors with the letter i (either
REM uppercase or lowercase) in their last name, living in zip code 10025.
SELECT first_name, last_name
FROM instructor
WHERE (last_name LIKE '%i%' OR last_name LIKE '%I%') AND zip = '10025';

REM c) Does the following statement contain an error? Explain
SELECT last_name
FROM instructor
WHERE created_date = modified_by;
	REM Sí, porque los tipos de datos no son los mismos. 
	
REM d) What do you observe when you execute the following SQL statement?
SELECT course_no, cost
FROM course
WHERE cost BETWEEN 1500 AND 1000;
	REM No rows selected, porque aunque existe el rango, el valor más pequeño debe ir primero

REM e) Execute the following query and determine how many rows the query returns.
SELECT last_name, student_id
FROM student
WHERE ROWNUM <= 10;
	REM Retorna 10 tuplas. (Puede regresar menos. Además, no tienen orden específico).

REM f) Write a SELECT statement that lists descriptions of courses for which there are prerequisites and
REM that cost less than 1100.
SELECT description
FROM course
WHERE prerequisite is not null and cost < 1100;

REM g) Write a SELECT statement that lists the cost of courses without a known prerequisite; do not
REM repeat the cost.
SELECT distinct cost
FROM course
WHERE prerequisite is null;
	REM distinct evita la repetición.
REM ====================================================================================================================

REM |||||||||||||||||||||||||||||||||||||| 3.2 "The ORDER BY Clause" ||||||||||||||||||||||||||||||||||||||
REM Rischert, A. (2010). Oracle SQL By Example.

REM (Rischert, 2010, 118)
REM Despliega el no. de curso y la descripción de los cursos donde el prerequisito es nulo
REM y lo ordena de acuerdo a la descripción.
REM La información no está guardada en ningún orden. ORDER BY nos permite darle un orden.
REM En este caso, por orden alfabético.
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
ORDER BY description;

REM (Rischert, 2010, 119)
REM Despliega el no. de curso y la descripción de los cursos donde el prerequisito es nulo
REM y lo ordena de acuerdo a la descripción.
REM Ordena en orden descendente. El default es ascendente(ASC).
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
ORDER BY description DESC;

REM (Rischert, 2010, 119)	
REM Despliega el no. de curso y la descripción de los cursos donde el prerequisito es nulo
REM y lo ordena de acuerdo a la descripción (2da columna).
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
ORDER BY 2 DESC;
	
REM (Rischert, 2010, 119)
REM Da error porque ORDER BY requiere que la columna esté en la selección.
SELECT DISTINCT first_name, last_name
FROM student
WHERE zip = '10025'
ORDER BY student_id;

REM (Rischert, 2010, 120)
REM Despliega los costos (que sean distintos) de los cursos. Estos estarán ordenados por costo.
REM Ordena también nulls, pero los coloca al final.
SELECT DISTINCT cost
FROM course
ORDER BY cost;

REM (Rischert, 2010, 120)
REM Despliega los costos (que sean distintos) de los cursos. Estos estarán ordenados por costo.
REM Se pueden poner los NULLS al inicio.
SELECT DISTINCT cost
FROM course
ORDER BY cost NULLS FIRST;

REM (Rischert, 2010, 122)	
REM Diferentes formas de darle un Alias a las columnas consultadas.
SELECT first_name first,
first_name "First Name",
first_name AS "First"
FROM student
WHERE zip = '10025';

REM (Rischert, 2010, 122)
REM Se pueden ordenar columnas específicas con el alias.
SELECT first_name first, first_name "First Name",
first_name AS "First"
FROM student
WHERE zip = '10025'
ORDER BY "First Name";
	
REM (Rischert, 2010, 123)
REM Multiples formas de realizar COMENTARIOS
/* Multi-line comment
SELECT *
FROM student;
*/
-- This is a single-line comment!
SELECT DISTINCT state
FROM zipcode;
SELECT instructor_id, -- Comment within a SQL statement!
zip /* Another comment example */
FROM instructor;
 
REM ====================================================================================================================
REM													Ejercicios 3.2

REM a) Write a SELECT statement that lists each city and zip code in New York or Connecticut. Sort the
REM results in ascending order by zip code.
SELECT city, zip
FROM zipcode
WHERE state = 'NY' or state = 'CT'
ORDER BY zip;

REM b) Write a SELECT statement that lists course descriptions and their prerequisite course numbers,
REM sorted in ascending order by description. Do not list courses that do not have a prerequisite.
SELECT description, prerequisite
FROM course
WHERE prerequisite is not null
ORDER BY description;

REM c) Show the salutation, first name, and last name of students with the last name Grant. Order the
REM results by salutation in descending order and by first name in ascending order.
SELECT salutation, first_name, last_name
FROM student
WHERE last_name = 'Grant'
ORDER BY salutation DESC, first_name ASC;

REM d) Execute the following query. What do you observe about the last row returned by the query?
SELECT student_id, last_name
FROM student
ORDER BY last_name;
	REM Todo apareció en orden (se esperaba que 
	REM las minús fueran después de todas las mayús).

REM ====================================================================================================================

SPOOL OFF
REM Zarate Lozano Luis Axel
REM 3BM2

REM CAP 3
REM |||||||||||||||||||||||||||||||||||||| 3.1 "The WHERE Clause" ||||||||||||||||||||||||||||||||||||||
REM Rischert, A. (2010). Oracle SQL By Example.

REM (Rischert, 2010, 103)
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name = 'Schorin';

REM (Rischert, 2010, 103)
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name = 'schorin'; 
	REM No se seleccionará ninguna fila, porque se toman en cuenta mayús y minús. 

REM (Rischert, 2010, 103)
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name <> 'Schorin';
	REM Donde el instructor es diferente(<>) de 'Schorin'
	
REM (Rischert, 2010, 104)
SELECT description, cost
FROM course
WHERE cost >= 1195;

REM (Rischert, 2010, 104)
SELECT description, cost
FROM course
WHERE cost BETWEEN 1000 AND 1100;
	
REM (Rischert, 2010, 105)
SELECT description, cost
FROM course
WHERE cost IN (1095, 1595);

REM (Rischert, 2010, 105)
SELECT first_name, last_name, phone
FROM instructor
WHERE last_name LIKE 'S%';
	REM '%' denota más carácteres antes o después del patrón.
	
REM (Rischert, 2010, 105)
SELECT first_name, last_name
FROM instructor
WHERE last_name LIKE '_o%';
	REM '_' denota un carácter antes o después del patrón.
	
REM (Rischert, 2010, 106)
SELECT phone
FROM instructor
WHERE last_name NOT LIKE 'S%';
	REM Not nega los operadores anteriores.
	
REM (Rischert, 2010, 106)
SELECT description, prerequisite
FROM course
WHERE prerequisite IS NULL;

REM (Rischert, 2010, 107)
SELECT description, cost
FROM course
WHERE cost = 1095
AND description LIKE 'I%';

REM (Rischert, 2010, 107)
SELECT description, cost, prerequisite
FROM course
WHERE cost = 1195
AND prerequisite = 20
OR prerequisite = 25;

REM (Rischert, 2010, 108)	
SELECT description, cost, prerequisite
FROM course
WHERE cost = 1195
AND (prerequisite = 20
OR prerequisite = 25);

REM (Rischert, 2010, 109)
SELECT description, prerequisite
FROM course
WHERE description LIKE 'Intro to%'
AND prerequisite >= 140;
	REM en SQL existe True, False y Unknown
	
REM (Rischert, 2010, 109)
SELECT description, prerequisite, cost
FROM course
WHERE prerequisite IS NULL;
	REM Null es considerado como Unknown, por lo que en la consulta anterior no se desplegará
	REM ningúna tupla con este campo Null
	
REM (Rischert, 2010, 110)
SELECT description, prerequisite
FROM course
WHERE description LIKE 'Intro to%'
OR prerequisite >= 140;

REM (Rischert, 2010, 110)	
SELECT description, prerequisite
FROM course
WHERE NOT prerequisite >= 140;
	REM Not(Unknown) = Unknown
	
REM (Rischert, 2010, 114)
SELECT student_id, last_name
FROM student
WHERE last_name BETWEEN 'W' AND 'Z';
	REM BETWEEN también funciona con texto.

REM (Rischert, 2010, 114)	
SELECT student_id, last_name
FROM student
WHERE last_name BETWEEN 'W' AND 'Z'
OR last_name BETWEEN 'w' AND 'z';

REM (Rischert, 2010, 114)	
SELECT description
FROM grade_type
WHERE description BETWEEN 'Midterm' and 'Project';
	REM Equivalente a:
	REM SELECT description
	REM FROM grade_type
	REM WHERE description >= 'Midterm'
	REM AND description <= 'Project';

REM ====================================================================================================================
REM EJERCICIOS 3.1 
REM a) Write a SELECT statement that lists the last names of students living in either zip code 10048, 11102, or 11209.
SELECT last_name
FROM student
WHERE zip in ('10048', '11102', '11209');

REM b) Write a SELECT statement that lists the first and last names of instructors with the letter i (either
REM uppercase or lowercase) in their last name, living in zip code 10025.
SELECT first_name, last_name
FROM instructor
WHERE (last_name LIKE "%i%" OR last_name LIKE "%I%") AND zip = '10025';

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
FROM courses
WHERE prerequisite is not null and cost < 1100;

REM g) Write a SELECT statement that lists the cost of courses without a known prerequisite; do not
REM repeat the cost.
SELECT distinct cost
FROM courses
WHERE prerequisite is null;
	REM distinct evita la repetición.
REM ====================================================================================================================

REM |||||||||||||||||||||||||||||||||||||| 3.2 "The ORDER BY Clause" ||||||||||||||||||||||||||||||||||||||
REM Rischert, A. (2010). Oracle SQL By Example.

REM (Rischert, 2010, 118)
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
ORDER BY description;
	REM La información no está guardada en ningún orden. ORDER BY nos permite darle un orden.
	REM En este caso, por orden alfabético.

REM (Rischert, 2010, 119)
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
ORDER BY description DESC;
	REM Ordena en orden descendente. El default es ascendente(ASC).

REM (Rischert, 2010, 119)	
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
ORDER BY 2 DESC;
	REM 2da columna.
	
REM (Rischert, 2010, 119)	
SELECT DISTINCT first_name, last_name
FROM student
WHERE zip = '10025'
ORDER BY student_id;
	REM Da error porque ORDER BY requiere que la columna esté en la selección.

REM (Rischert, 2010, 120)
SELECT DISTINCT cost
FROM course
ORDER BY cost;
	REM Ordena también nulls, pero los coloca al final.

REM (Rischert, 2010, 120)
SELECT DISTINCT cost
FROM course
ORDER BY cost NULLS FIRST
	REM Se pueden poner los NULLS al inicio.

REM (Rischert, 2010, 122)	
SELECT first_name first,
first_name "First Name",
first_name AS "First"
FROM student
WHERE zip = '10025';
	REM Diferentes formas de darle un Alias a las columnas consultadas.

REM (Rischert, 2010, 122)
SELECT first_name first, first_name "First Name",
first_name AS "First"
FROM student
WHERE zip = '10025'
ORDER BY "First Name";
	REM Se pueden ordenar columnas específicas con el alias.
	
REM (Rischert, 2010, 123)
REM COMENTARIOS
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
 REM Comentarios
 
REM ====================================================================================================================

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
	REM Las minús van después de las mayús cuando se ordenan.

REM ====================================================================================================================
SPOOL C:\guest\schemasetup\Cap6OUT.txt
/*												CAP 6
||||||||||||||||||||||||||||||||||| 6.1 "Aggregate Functions, GROUP BY,and HAVING Clauses" |||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 264)
--Despliega el num de tuplas que hay en la tabla enrollment.
SELECT COUNT(*)
FROM enrollment;

--(Rischert, 2010, 265)
--Despliega el num de tuplas de final_grade, section_id y las tuplas en total.
--Si el dato de la columna es null, no lo cuenta.
SELECT COUNT(final_grade), COUNT(section_id), COUNT(*)
FROM enrollment;

--(Rischert, 2010, 265)
--Despliega el num de tuplas distintas de section_id y el num total de section_id.
SELECT COUNT(DISTINCT section_id), COUNT(section_id)
FROM enrollment;

--(Rischert, 2010, 265)
--Se suman los valores de capacity.
--Si alguno es null, se ignora.
SELECT SUM(capacity)
FROM section;

--(Rischert, 2010, 266)
--Despliega el promedio. Si hay un valor nulo, se sustituye por 0.
--AVG ignora los nulls.
SELECT AVG(capacity), AVG(NVL(capacity,0))
FROM section;

--(Rischert, 2010, 266)
--Despliega el min de capacity y el maximo.
SELECT MIN(capacity), MAX(capacity)
FROM section;

--(Rischert, 2010, 266)
--Min despliega la fecha mas antigua y max la mas reciente de student.
--Min y Max tambien funcionan con fechas.
SELECT MIN(registration_date) "First", 
MAX(registration_date) "Last"
FROM student;

--(Rischert, 2010, 267)
--Regresa el min y max de una cadena de acuerdo a su valor ascii.
SELECT MIN (description) AS MIN, MAX (description) AS MAX
FROM course;

--(Rischert, 2010, 267)
--Despliega el promedio del costo del curso despues de aplicarle un case.
SELECT AVG(CASE WHEN prerequisite IS NULL THEN cost*1.1
WHEN prerequisite = 20 THEN cost*1.2
ELSE cost
END) AS avg
FROM course;

--========================================================================================================================
--													Ejercicios 6.1
 
--a) Write a SELECT statement that determines how many courses do not have a prerequisite.
SELECT COUNT(*) FROM course WHERE prerequisite IS NULL;

--b) Write a SELECT statement that determines the total number of students enrolled. Count each
--student only once,no matter how many courses the student is enrolled in.
SELECT COUNT(DISTINCT student_id) FROM enrollment;

--c) Determine the average cost for all courses.If the course cost contains a null value,substitute the
--value 0.
SELECT AVG(NVL(cost, 0)) FROM course;

--d) Write a SELECT statement that determines the date of the most recent enrollment.
SELECT MAX(enroll_date) FROM enrollment;

--========================================================================================================================

/*												CAP 6
|||||||||||||||||||||||||||||||||||||| 6.2 "The GROUP BY and HAVING Clauses" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 271)
--Ambas consultas despliegan las localizaciones que son diferentes
SELECT DISTINCT location
FROM section;
SELECT location
FROM section
GROUP BY location;

--(Rischert, 2010, 272)
--Agrupa las locaciones y cuenta cuantas hay de cada una
SELECT location, COUNT(*)
FROM section
GROUP BY location;

--(Rischert, 2010, 272)
--Despliega la locacion, el numero que hay de cada una, la suma de las capacidades, la capacidad Min
--y la capacidad max de cada grupo
SELECT location, COUNT(*), SUM(capacity) AS sum,
MIN(capacity) AS min, MAX(capacity) AS max
FROM section
GROUP BY location;

--(Rischert, 2010, 273)
--Despliega la locacion, la capacidad y el ID de la seccion en donde la locacion sea L211
SELECT location, capacity, section_id
FROM section
WHERE location = 'L211';

--(Rischert, 2010, 273)
--Muestra la locacion, el ID del instructor, cuantos elementos hay por grupo,
--la suma de la capacidad, la capacidad max y min de la tabla section.
--En este caso las locaciones se van a repetir porque tienen varios instructores
SELECT location, instructor_id,
COUNT(*), SUM(capacity) AS sum,
MIN(capacity) AS min, MAX(capacity) AS max
FROM section
GROUP BY location, instructor_id
ORDER BY 1;

--(Rischert, 2010, 274)
--Despliega la locacion, el ID del instructor, la capacidad y el ID de la seccion
-- donde la seccion sea L210 y los ordena por locacion e ID de instructor.
SELECT location, instructor_id, capacity, section_id
FROM section
WHERE location = 'L210'
ORDER BY 1, 2;

--(Rischert, 2010, 274)
--Despliega un error, porque todas los atributos que se vayan a desplegar tienen que estar contenidos
--en el group by, excepto las funciones agregadas
SELECT location, instructor_id,
COUNT(*), SUM(capacity) AS sum,
MIN(capacity) AS min, MAX(capacity) AS max
FROM section
GROUP BY location;

--(Rischert, 2010, 275)
--Ordena los grupos de acuerdo a la suma de su capacidad.
SELECT location "Location", instructor_id,
COUNT(location) "Total Locations",
SUM(capacity) "Total Capacity"
FROM section
GROUP BY location, instructor_id
ORDER BY "Total Capacity" DESC;

--(Rischert, 2010, 275)
--Despliega los grupos que tienen una suma de capacidad mayor a 50
SELECT location "Location", instructor_id,
COUNT(location) "Total Locations",
SUM(capacity) "Total Capacity"
FROM section
GROUP BY location, instructor_id
HAVING SUM(capacity) > 50
ORDER BY "Total Capacity" DESC;

--(Rischert, 2010, 275)
--Filtra las secciones por tuplas, después las agrupa y les aplica las funciones agregadas.
--Posteriormente filtra las agrupaciones.
SELECT location "Location", instructor_id,
COUNT(location) "Total Locations",
SUM(capacity) "Total Capacity"
FROM section
WHERE section_no IN (2, 3)
GROUP BY location, instructor_id
HAVING SUM(capacity) > 50;

--(Rischert, 2010, 276)
--Filtra los grupos por el num de locaciones y que sigan el patron L5...
SELECT location "Location",
SUM(capacity) "Total Capacity"
FROM section
WHERE section_no = 3
GROUP BY location
HAVING (COUNT(location) > 3
AND location LIKE 'L5%');

--(Rischert, 2010, 276)
--Las constantes y funciones sin parametros (como SYSDATE) no tienen que ser puestas en el
--group by
SELECT 'Hello', 1, SYSDATE, course_no "Course #",
COUNT(*)
FROM section
GROUP BY course_no
HAVING COUNT(*) = 5;

--(Rischert, 2010, 277)
--Filtra los grupos que tengan 2 tuplas
--La clausula Having puede aparecer antes del group by.
SELECT course_no "Course #",
AVG(capacity) "Avg. Capacity",
ROUND(AVG(capacity)) "Rounded Avg. Capacity"
FROM section
HAVING COUNT(*) = 2
GROUP BY course_no;

--(Rischert, 2010, 277)
--Despliega el num max de estudiantes inscritos a un curso
SELECT MAX(COUNT(*))
FROM enrollment
GROUP BY section_id;

--(Rischert, 2010, 279)
--Muestra los nulls primero
--Group by considera los nulls iguales a los otros datos
SELECT prerequisite, COUNT(*)
FROM course
GROUP BY prerequisite
ORDER BYprerequisite NULLS FIRST;

--(Rischert, 2010, 280)
--Despliega un error porque los alias no son admitidos en la clausula group by
SELECT course_no "Course #",
AVG(capacity) "Avg. Capacity",
ROUND(AVG(capacity)) "Rounded Avg. Capacity"
FROM section
GROUP BY course_no "Course #";

--========================================================================================================================
--													Ejercicios 6.2
 
 --a) Show a list of prerequisites and count how many times each appears in the COURSE table. Order
 --the result by the PREREQUISITE column.
SELECT prerequisite, COUNT(*) FROM course GROUP BY prerequisite ORDER BY prerequisite;
 
 --b) Write a SELECT statement that shows student IDs and the number of courses each student is
 --enrolled in. Show only those enrolled in more than two classes.
 SELECT student_id, COUNT(*) FROM enrollment GROUP BY student_id HAVING COUNT(*) > 2;
 
 --c) Write a SELECT statement that displays the average room capacity for each course.Display the
 --average,expressed to the nearest whole number,in another column.Use a column alias for each
 --column selected.
SELECT course_no "Course #",
AVG(capacity) "Avg. Capacity", ROUND(AVG(capacity)) "Rounded Avg. Capacity" FROM section GROUP BY course_no;
 
 --d) Write the same SELECT statement as in Exercise c,except consider only courses with exactly two
 --sections.Hint:Think about the relationship between the COURSEand SECTIONtables—
 --specifically,how many times a course can be represented in the SECTIONtable.
SELECT course_no "Course #",
AVG(capacity) "Avg. Capacity",
ROUND(AVG(capacity)) "Rounded Avg. Capacity"
FROM section
GROUP BY course_no
HAVING COUNT(*) = 2;

--========================================================================================================================
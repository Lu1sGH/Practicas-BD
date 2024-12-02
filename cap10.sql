SPOOL C:\guest\schemasetup\Cap10OUT.txt
SET ECHO OFF;
/*												CAP 10
|||||||||||||||||||||||||||||||||||||| 10.1 "Complex Joins" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 400)
--Une la tabla course y section usando la columna course_no. Despues de la union, ordena las tuplas
--por course_no
SELECT course_no, description,
section_id
FROM course JOIN section
USING (course_no)
ORDER BY course_no;

--(Rischert, 2010, 400)
--Despliega aquellos cursos que no tienen una seccion asignada
SELECT course_no, description
FROM course c
WHERE NOT EXISTS
(SELECT 'X'
FROM section
WHERE c.course_no = course_no);

--(Rischert, 2010, 401)
--Despliega todas las tuplas de la tabla course que tienen y que no tienen una seccion asignada 
--Si no tiene una seccion asignada, entonces las columnas de la tabla seccion se muestran nulas
SELECT c.course_no, c.description,
s.section_id, s.course_no
FROM course c LEFT OUTER JOIN section s
ON c.course_no = s.course_no
ORDER BY c.course_no;

--(Rischert, 2010, 402)
--Despliega el mismo resultado que la consulta anterior. Esto se debe a que en la consulta anterior, la tabla
--izquierda era course y la derecha section, en este caso, la derecha es course y la union es hacia la derecha
SELECT c.course_no, c.description,
s.section_id, s.course_no
FROM section s RIGHT OUTER JOIN course c
ON c.course_no = s.course_no
ORDER BY c.course_no;

--(Rischert, 2010, 402)
--Despliega el course_no, description y section_id de la RIGHT OUTER JOIN de la tabla section y course en donde 
--el course_no sea igual en ambas tablas
SELECT course_no, description,
section_id
FROM section RIGHT OUTER JOIN course
USING (course_no)
ORDER BY course_no;

--(Rischert, 2010, 403)
--Esta consulta es muy similar a una inner join, si no fuera por el (+)
--Realiza una LEFT OUTER JOIN entre la tabla course y section
--(+) indica la tabla de la que se quiere que se muestren valores nulos
SELECT c.course_no, c.description,
s.section_id, s.course_no
FROM course c, section s
WHERE c.course_no = s.course_no(+)
ORDER BY c.course_no;

--(Rischert, 2010, 403)
SELECT c1.course_no, c1.description,
s.section_id, s.course_no
FROM course c1, section s
WHERE c1.course_no = s.course_no
UNION ALL
SELECT c2.course_no, c2.description,
TO_NUMBER(NULL), TO_NUMBER(NULL)
FROM course c2
WHERE NOT EXISTS
(SELECT 'X'
FROM section
WHERE c2.course_no = course_no);

--(Rischert, 2010, 403)
--Se obtiene los mismos resultados en que en las consultas anteriores, pero esta vez se usa
--UNION ALL. Esta instruccion no quita las tuplas repetidas
SELECT c1.course_no, c1.description,
s.section_id, s.course_no
FROM course c1, section s
WHERE c1.course_no = s.course_no --Hace una inner join entre course y section
UNION ALL
SELECT c2.course_no, c2.description,
TO_NUMBER(NULL), TO_NUMBER(NULL)
FROM course c2
WHERE NOT EXISTS
(SELECT 'X'
FROM section
WHERE c2.course_no = course_no); --Selecciona aquellos cursos que no tienen una seccion asignada

--(Rischert, 2010, 404)
--Despliega el contenido de la tabla t1
SELECT col1
FROM t1;

--(Rischert, 2010, 404)
--Despliega el contenido de la tabla t2
SELECT col2
FROM t2;

--(Rischert, 2010, 405)
--Hace una LEFT OUTER JOIN entre la tabla t1 y t2
LEFT OUTER JOIN entre la tabla t1 y t2
SELECT col1, col2
FROM t1 LEFT OUTER JOIN t2
ON t1.col1 = t2.col2;

--(Rischert, 2010, 405)
--Hace una RIGHT OUTER JOIN entre la tabla t1 y t2
SELECT col1, col2
FROM t1 RIGHT OUTER JOIN t2
ON t1.col1 = t2.col2;

--(Rischert, 2010, 405)
--Despliega todas las columnas de la tabla t1 y t2, incluyendo aquellas en donde la condicion no se cumple. Para 
--estos casos, se ponen null como en los LEFT/RIGHT OUTER JOINS
SELECT col1, col2
FROM t1 FULL OUTER JOIN t2
ON t1.col1 = t2.col2;

--(Rischert, 2010, 405)
--Realiza una FULL OUTER JOIN haciendo uso de UNION
--Como hay columnas que se veran duplicadas, no se puede usar ALL
SELECT col1, col2
FROM t1, t2
WHERE t1.col1 = t2.col2(+)
UNION
SELECT col1, col2
FROM t1, t2
WHERE t1.col1(+) = t2.col2;

--(Rischert, 2010, 409)
--Hace una LEFT OUTER JOIN entre course y section en donde el prerequisite es 350
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c, section s
WHERE c.course_no = s.course_no(+)
AND c.prerequisite = 350;

--(Rischert, 2010, 409)
--Hace una LEFT OUTER JOIN entre course y section en donde el prerequisite es 350 y la locacion es L507
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c, section s
WHERE c.course_no = s.course_no(+)
AND c.prerequisite = 350
AND s.location = 'L507';

--(Rischert, 2010, 410)
--La consulta anterior debio haber incluido otra mas tupla porque tambien cumple con la condicion del prerequisite
--Si no se coloca el (+) en la otra columa, es como si se estuviera haciendo una equijoin porque (+) indica que
--s.locacion puede admitir nulos.
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c, section s
WHERE c.course_no = s.course_no(+)
AND c.prerequisite = 350
AND s.location(+) = 'L507';

--(Rischert, 2010, 410)
--Despliega tuplas aunque no haya cursos con prerequisite = 350 y con locacion en L210
SELECT c.course_no cno, s.course_no sno,
SUBSTR(c.description, 1,20),
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c, section s
WHERE c.course_no = s.course_no(+)
AND c.prerequisite = 350
AND s.location(+) = 'L210';

--(Rischert, 2010, 411)
--Hace una LEFT OUTER JOIN entre course y section en donde el prerequisite es 350 y la locacion es L507
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c LEFT OUTER JOIN section s
ON c.course_no = s.course_no
WHERE c.prerequisite = 350
AND location = 'L507';

--(Rischert, 2010, 411)
--Primero selecciona el resultado entre la LEFT JOIN entre course y section en donde el course_no sea igual y 
--la locacion sea L507. Despues, filtra las tuplas en donde el prerequisite sea 350
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c LEFT OUTER JOIN section s
ON (c.course_no = s.course_no
AND location = 'L507')
WHERE c.prerequisite = 350;

--(Rischert, 2010, 412)
--Realiza lo mismo que en la consulta anterior pero usando INLINE VIEWS
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM (SELECT*
FROM course 
WHERE prerequisite = 350) c LEFT OUTER JOIN
(SELECT * FROM section
WHERE location = 'L507') s
ON (c.course_no = s.course_no);
--========================================================================================================================
--													Ejercicios 10.1

--a) Explain why Oracle returns an error message when you execute the following SELECT statement.
SELECT c.course_no, s.course_no, s.section_id,
c.description, s.start_date_time
FROM course c, section s
WHERE c.course_no(+) = s.course_no(+);
--No es posible usar (+) dos veces en un predicado

--b) Show the description of all courses with the prerequisite course number 350.Include in the result
--the location where the sections meet.Return course rows even if no corresponding row in the
--SECTION table is found.
SELECT c.course_no cno, s.course_no sno,
c.description,
c.prerequisite prereq,
s.location loc, s.section_id
FROM course c LEFT OUTER JOIN section s
ON c.course_no = s.course_no
WHERE c.prerequisite = 350;

/*c) Rewrite the following SQL statement using an outer join.
SELECT course_no, description
FROM course c
WHERE NOT EXISTS
(SELECT 'X'
FROM section
WHERE c.course_no = course_no)
COURSE_NO DESCRIPTION
--------- --------------------------------
80 		  Programming Techniques
430 	  Java Developer III

2 rows selected.
*/
SELECT course_no, description
FROM course LEFT OUTER JOIN section
USING (course_no)
WHERE section_id IS NULL;

/*d) Show all the city,state,and zip code values for Connecticut.Display a count of how many students
live in each zip code. Order the result alphabetically by city.The result should look similar to the
following output.Note that the column STUDENT_COUNT displays a zero when no student lives in
a particular zip code.
CITY                      ST ZIP   STUDENT_COUNT
------------------------- -- ----- ------------
Ansonia                   CT 06401             0
Bridgeport                CT 06605             1
...
Wilton                    CT 06897             0
Woodbury                  CT 06798             1

19 rows selected.
*/
SELECT city, state, zip,
(SELECT COUNT(*)
FROM student s
WHERE s.zip = z.zip) AS student_count
FROM zipcode z
WHERE state = 'CT';

--e) Display the course number,description,cost,class location,and instructor’s last name for all the
--courses. Also include courses where no sections or instructors have been assigned.
SELECT course_no cou, description, cost,
location, last_name
FROM course LEFT OUTER JOIN section
USING (course_no)
LEFT OUTER JOIN instructor
USING (instructor_id)
ORDER BY course_no;

--f) For students with the student ID 102 and 301,determine the sections they are enrolled in.Also
--show the numeric grades and grade types they received,regardless of whether they are enrolled
--or received any grades.
SELECT student_id, section_id, grade_type_code,
numeric_grade
FROM student LEFT OUTER JOIN enrollment
USING (student_id)
LEFT OUTER JOIN grade
USING (student_id, section_id)
WHERE student_id IN (102, 301);

--========================================================================================================================

/*														CAP 10
||||||||||||||||||||||||||||||||||||||||||||||||||| 10.2 "Self-Joins" |||||||||||||||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 418)
--Despliega el no. del curso, la descripcion y el prerequisito de la tabla course
SELECT course_no, description, prerequisite
FROM course;

--(Rischert, 2010, 419)
--Despliega el no del curso, la descripcion, el prerequisito y la descripcion del prerequisito
SELECT c1.course_no,
c1.description course_descr,
c1.prerequisite as prereq,
c2.description pre_req_descr
FROM course c1 JOIN course c2
ON (c1.prerequisite = c2.course_no)
ORDER BY 3, 1;

--(Rischert, 2010, 419)
--Hace lo mismo que la consulta anterior, sin usar notacion ANSI
SELECT c1.course_no,
c1.description course_descr,
c1.prerequisite,
c2.description pre_req_descr
FROM course c1, course c2
WHERE c1.prerequisite = c2.course_no
ORDER BY 3, 1;

--(Rischert, 2010, 420)
--Despliega el grade_type_code, numeric_grade, letter_grade de la union entre la tabla grado y grade_conversion
--de aquellos numeric_grade que estan entre la minima y maxima calificacion
--Esto funciona para ver que se pueden hacer non-equijoins
SELECT grade_type_code, numeric_grade, letter_grade
FROM grade g JOIN grade_conversion c
ON (g.numeric_grade BETWEEN c.min_grade AND c.max_grade)
WHERE g.student_id = 107
ORDER BY 1, 2 DESC;

--(Rischert, 2010, 420)
--La consulta anterior tambien se puede expresar con la notacion tradicional
SELECT grade_type_code, numeric_grade, letter_grade,
min_grade, max_grade
FROM grade g, grade_conversion c
WHERE g.numeric_grade BETWEEN c.min_grade AND c.max_grade
AND g.student_id = 107
ORDER BY 1, 2 DESC;

--========================================================================================================================
--													Ejercicios 10.2

--a) For SECTION_ID 86,determine which students received a lower grade on their final than on their
--midterm.In your result,list the STUDENT_ID and the grade for the midterm and final.
SELECT fi.student_id, mt.numeric_grade "Midterm Grade",
fi.numeric_grade "Final Grade"
FROM grade fi JOIN grade mt
ON (fi.section_id = mt.section_id
AND fi.student_id = mt.student_id)
WHERE fi.grade_type_code = 'FI'
AND fi.section_id = 86
AND mt.grade_type_code = 'MT'
AND fi.numeric_grade < mt.numeric_grade;

--b) What problem does the following query solve? 
SELECT DISTINCT a.student_id, a.first_name, a.salutation
FROM student a, student b
WHERE a.salutation <> b.salutation
AND b.first_name = a.first_name
AND a.student_id <> b.student_id
ORDER BY a.first_name;
--Determina los estudiantes que podrían tener un salutation inconsistente

--c) Display the student ID,last name,and street address of students living at the same address and
--zip code.
SELECT DISTINCT a.student_id, a.last_name,
a.street_address
FROM student a, student b
WHERE a.street_address = b.street_address
AND a.zip = b.zip
AND a.student_id <> b.student_id
ORDER BY a.street_address;

--d) Write a query that shows the course number,course description,prerequisite,and description of
--the prerequisite.Include courses without any prerequisites.(This requires a self-join and an outer join.)
SELECT c1.course_no,
SUBSTR(c1.description, 1,15) course_descr,
C1.prerequisite,
SUBSTR(c2.description,1,15) pre_req_descr
FROM course c1 LEFT OUTER JOIN course c2
ON c1.prerequisite = c2.course_no
ORDER BY 1;

--========================================================================================================================

SPOOL OFF;
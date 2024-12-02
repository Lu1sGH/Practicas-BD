SPOOL C:\guest\schemasetup\Cap7OUT.txt
SET ECHO OFF;
/*												CAP 7
|||||||||||||||||||||||||||||||||||||| 7.1 " The Two-Table Join" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 288)
--Realiza una union entre la tabla curso y seccion
--El criterio de union es donde el course_no es igual en ambas tablas
SELECT course.course_no, section_no, description,
location, instructor_id
FROM course, section
WHERE course.course_no = section.course_no;

--(Rischert, 2010, 288)
--Realiza lo mismo que arriba, pero usa alias en vez del nombre completo de
--las tablas
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c, section s
WHERE c.course_no = s.course_no;

--(Rischert, 2010, 289)
--Despliega la union de la tabla curso y seccion en donde el numero curso sea igual
--en ambas tablas y la descripcion siga el patron Intro to...
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c, section s
WHERE c.course_no = s.course_no
AND c.description LIKE 'Intro to%';

--(Rischert, 2010, 290)
--El siguiente select despliega el id del instructor, el zip, el apellido y el nombre
--de la tabla instructor donde zip es nulo
SELECT instructor_id, zip, last_name, first_name
FROM instructor
WHERE zip IS NULL;

--(Rischert, 2010, 290)
--Une la tabla instructor y zip en donde el zip es igual
--Si algun dato es nulo en la columna en comun, la tupla no aparecera
SELECT i.instructor_id, i.zip, i.last_name, i.first_name
FROM instructor i, zipcode z
WHERE i.zip = z.zip;

--(Rischert, 2010, 291)
--Une la tabla curso con la tabla seccion usando la columna en comun entre ambas tablas
--USING recibe el nombre de la tabla en comun (ambas deben de tener el mismo nombre)
SELECT course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c JOIN section s
USING (course_no);

--(Rischert, 2010, 291)
--Realiza lo mismo que la consulta anterior, pero usando la palabra INNER
--INNER es opcional
SELECT course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c INNER JOIN section s
USING (course_no);

--(Rischert, 2010, 291)
--Despliega error porque USING solo recibe nombre de columnas simples
SELECT course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c JOIN section s
USING (c.course_no);

--(Rischert, 2010, 292)
--Despliega error porque la columna usada en USING no debe de llevar qualifiers
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c JOIN section s
USING (course_no);

--(Rischert, 2010, 292)
--Despliega error porque la columna que se use para USING debe de llevar parentesis 
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c JOIN section s
USING course_no;

--(Rischert, 2010, 292)
--Une la tabla curso y seccion en donde el no. del curso es igual
--Se usa la palabra ON en vez de USIGN, ya que ON admite otras condiciones ademas de =
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c JOIN section s
ON (c.course_no = s.course_no);

--(Rischert, 2010, 292)
--Une la tabla curso y seccion en donde el no. del curso sea igual en ambas tablas. Ademas, 
--la descripcion debe seguir el patron B...
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c JOIN section s
ON (c.course_no = s.course_no)
WHERE description LIKE 'B%';

--(Rischert, 2010, 293)
--No despliega nada porque las columnas que se llaman igual y tienen el mismo tipo de dato en ambas tablas
--no son iguales
--NATURAL JOIN identifica aquellas columnas que tienen el mismo nombre y el mismo tipo de dato
SELECT course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c NATURAL JOIN section s;

--(Rischert, 2010, 293)
--Realiza el producto cartesiano entre seccion e instructor y cuenta el numero de tuplas que retorna
--Sin el criterio de union, se realiza el producto cartesiano
SELECT COUNT(*)
FROM section, instructor;

--(Rischert, 2010, 294)
--Muestra, de forma parcial, todas las combinaciones que se pueden hacer de las tablas 
--seccion e instructor al realizar el producto cartesiano
SELECT s.instructor_id s_instructor_id,
i.instructor_id i_instructor_id
FROM section s, instructor i;

--(Rischert, 2010, 294)
--Realiza el producto cartesiano usando la sintaxis ANSI
SELECT COUNT(*)
FROM section CROSS JOIN instructor;

--========================================================================================================================
--													Ejercicios 7.1

--a) For all students, display last name, city, state, and zip code. Show the result ordered by zip code.
SELECT s.last_name, s.zip, z.state, z.city FROM student s, zipcode z WHERE s.zip = z.zip ORDER BY s.zip;

--b) Select the first and last names of all enrolled students and order by last name in ascending order.
SELECT s.first_name, s.last_name, s.student_id FROM student s, enrollment e WHERE s.student_id = e.student_id
ORDER BY s.last_name;

--c) Execute the following SQL statement. Explain your observations about the WHERE clause and the
--resulting output.
SELECT c.course_no, c.description, s.section_no
FROM course c, section s
WHERE c.course_no = s.course_no
AND c.prerequisite IS NULL
ORDER BY c.course_no, s.section_no;
--Se hace la union de la tabla seccion y curso en donde el no. del curso sea igual y el prerequisito nulo

--d) Select the student ID,course number,enrollment date,and section ID for students who enrolled in
--course number 20 on January 30,2007.
SELECT e.student_id, s.course_no, TO_CHAR(e.enroll_date,'MM/DD/YYYY HH:MI PM'), e.section_id
FROM enrollment e JOIN section s ON (e.section_id = s.section_id)
WHERE s.course_no = 20
AND e.enroll_date >= TO_DATE('01/30/2007','MM/DD/YYYY')
AND e.enroll_date < TO_DATE('01/31/2007','MM/DD/YYYY');

--e) Select the students and instructors who live in the same zip code by joining on the common ZIP
--column. Order the result by the STUDENT_ID and INSTRUCTOR_ID columns.What do you observe?
SELECT s.student_id, i.instructor_id,
s.zip, i.zip
FROM student s, instructor i
WHERE s.zip = i.zip
ORDER BY s.student_id, i.instructor_id;

--========================================================================================================================

/*												CAP 7
|||||||||||||||||||||||||||||||||||||| 7.2 "Joining Three or More Tables" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 303)
--Une la tabla curso y seccion en donde el no. de curso sea igual
SELECT c.course_no, s.section_no, c.description,
s.location, s.instructor_id
FROM course c, section s
WHERE c.course_no = s.course_no;

--(Rischert, 2010, 303)
--Une las tablas curso, seccion e instructor. El criterio de union es donde los valores del no. del curso sean
--iguales en la tabla C y S y en donde los valores de ID del instructor sean iguales en la tabla S e I
SELECT c.course_no, s.section_no, c.description, s.location,
s.instructor_id, i.last_name, i.first_name
FROM course c, section s, instructor i
WHERE c.course_no = s.course_no
AND s.instructor_id = i.instructor_id;

--(Rischert, 2010, 305)
--Hace lo mismo que la consulta anterior pero en sintaxis ANSI
--Primero une la tabla curso y seccion, despues une el resultado de la union con la tabla instructor
SELECT c.course_no, s.section_no, c.description, s.location,
s.instructor_id, i.last_name, i.first_name
FROM course c JOIN section s 
ON (c.course_no = s.course_no)
JOIN instructor i
ON (s.instructor_id = i.instructor_id);

--(Rischert, 2010, 305)
--Se hace lo mismo que en la consulta anterior, pero con el uso de USING
SELECT course_no, s.section_no, c.description, s.location,
instructor_id, i.last_name, i.first_name
FROM course c JOIN section s 
USING (course_no)
JOIN instructor i
USING (instructor_id);

--(Rischert, 2010, 306)
--Despliega los datos de la tabla grade en donde el id del estudiante sea 220 y el id 
--de la seccion sea 119
SELECT student_id, section_id, grade_type_code type,
grade_code_occurrence no,
numeric_grade indiv_gr
FROM grade
WHERE student_id = 220
AND section_id = 119;

--(Rischert, 2010, 306)
--Despliega los datos de la tabla grade pero se incluye la fecha de inscripcion con un join
SELECT g.student_id, g.section_id,
g.grade_type_code type,
g.grade_code_occurrence no,
g.numeric_grade indiv_gr,
TO_CHAR(e.enroll_date, 'MM/DD/YY') enrolldt
FROM grade g, enrollment e
WHERE g.student_id = 220
AND g.section_id = 119
AND g.student_id = e.student_id
AND g.section_id = e.section_id;

--(Rischert, 2010, 307)
--Realiza lo mismo que el select anterior pero con sintaxis ANSI
SELECT g.student_id, g.section_id,
g.grade_type_code type,
g.grade_code_occurrence no,
g.numeric_grade indiv_gr,
TO_CHAR(e.enroll_date, 'MM/DD/YY') enrolldt
FROM grade g JOIN enrollment e
ON (g.student_id = e.student_id
AND g.section_id = e.section_id)
WHERE g.student_id = 220
AND g.section_id = 119;

--(Rischert, 2010, 307)
--Realiza lo mismo que los dos selects anteriores pero usando USING en vez de ON
SELECT student_id, section_id,
grade_type_code type,
grade_code_occurrence no,
numeric_grade indiv_gr,
TO_CHAR(enroll_date, 'MM/DD/YY') enrolldt
FROM grade JOIN enrollment
USING (student_id, section_id)
WHERE student_id = 220
AND section_id = 119;

--========================================================================================================================
--													Ejercicios 7.2

--a) Display the student ID,course number,and section number of enrolled students where the
--instructor of the section lives in zip code 10025. In addition, the course should not have any
--prerequisites.
SELECT c.course_no, s.section_no, e.student_id FROM course c, section s, instructor i, enrollment e 
WHERE c.prerequisite IS NULL
AND c.course_no = s.course_no AND s.instructor_id = i.instructor_id AND i.zip = '10025' AND s.section_id = e.section_id;

--b) Produce the mailing addresses for instructors who taught sections that started in June 2007.
SELECT i.first_name || ' ' ||i.last_name name,
i.street_address, z.city || ', ' || z.state
|| ' ' || i.zip "City State Zip",
TO_CHAR(s.start_date_time, 'MM/DD/YY') start_dt,
section_id sect
FROM instructor i, section s, zipcode z
WHERE i.instructor_id = s.instructor_id
AND i.zip = z.zip
AND s.start_date_time >=
TO_DATE('01-JUN-2007','DD-MON-YYYY')
AND s.start_date_time <
TO_DATE('01-JUL-2007','DD-MON-YYYY');
 
--c) List the student IDs of enrolled students living in Connecticut.
SELECT student_id FROM student JOIN enrollment USING (student_id)
JOIN zipcode USING (zip) WHERE state = 'CT';

--d) Show all the grades student Fred Crocitto received for SECTION_ID 86.
SELECT s.first_name|| ' '|| s.last_name name,
e.section_id, g.grade_type_code,
g.numeric_grade grade
FROM student s JOIN enrollment e
ON (s.student_id = e.student_id)
JOIN grade g
ON (e.student_id = g.student_id
AND e.section_id = g.section_id)
WHERE s.last_name = 'Crocitto'
AND s.first_name ='Fred'
AND e.section_id = 86;

--e) List the final examination grades for all enrolled Connecticut students of course number 420.
--(Note that final examination grade does not mean final grade.)
SELECT e.student_id, sec.course_no, g.numeric_grade
FROM student stud, zipcode z,
enrollment e, section sec, grade g
WHERE stud.zip = z.zip
AND z.state = 'CT'
AND stud.student_id = e.student_id
AND e.section_id = sec.section_id
AND e.section_id = g.section_id
AND e.student_id = g.student_id
AND sec.course_no = 420
AND g.grade_type_code = 'FI';

--f) Display the LAST_NAME,STUDENT_ID,PERCENT_OF_FINAL_GRADE,GRADE_TYPE_CODE,and
--NUMERIC_GRADE columns for students who received 80 or less for their class project
--(GRADE_TYPE_CODE = 'PJ').Order the result by student last name.
SELECT g.student_id, g.section_id,
gw.percent_of_final_grade pct, g.grade_type_code,
g.numeric_grade grade, s.last_name
FROM grade_type_weight gw, grade g,
enrollment e, student s
WHERE g.grade_type_code = 'PJ'
AND gw.grade_type_code = g.grade_type_code
AND gw.section_id = g.section_id
AND g.numeric_grade <= 80
AND g.section_id = e.section_id
AND g.student_id = e.student_id
AND e.student_id = s.student_id
ORDER BY s.last_name;

--========================================================================================================================

SPOOL OFF;
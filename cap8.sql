SPOOL C:\guest\schemasetup\Cap8OUT.txt
/*												CAP 8
|||||||||||||||||||||||||||||||||||||| 8.1 "The Two-Table Join" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 324)
--Retorna el costo min de la tabla course
--A esto se le conoce como un Scalar Subquery
SELECT MIN(cost)
FROM course;

--(Rischert, 2010, 325)
--Despliega el course_no, description y cost de la tabla course
--en donde cost sea igual a 1095
SELECT course_no, description, cost
FROM course
WHERE cost = 1095;

--(Rischert, 2010, 325)
--Realiza lo mismo que la consulta anterior, sin embargo, ahora se usa una 
--scalar subquery en la condicion
SELECT course_no, description, cost
FROM course
WHERE cost = 
(SELECT MIN(cost)
FROM course);

--(Rischert, 2010, 326)
--Despliega el course_no, description y cost de la tabla course en donde el cost 
--sea igual al costo max
SELECT course_no, description, cost
FROM course
WHERE cost =
(SELECT MAX(cost)
FROM course);

--(Rischert, 2010, 326)
--Despliega un error porque la single-row subquery regresa mas de una tupla
SELECT course_no, description, cost
FROM course
WHERE cost =
(SELECT cost
FROM course
WHERE prerequisite = 20);

--(Rischert, 2010, 326)
--Despliega el course_no, description y cost de la tabla course tal que el costo
--se encuentre en el retorno del subquery.
--El subquery regresa los costos de los cursos donde el prerequisite es 20
--Para subqueries que retorna mas de una tupla, se usa IN
SELECT course_no, description, cost
FROM course
WHERE cost IN
(SELECT cost
FROM course
WHERE prerequisite = 20);

--(Rischert, 2010, 327)
--Despliega el course_no, description y cost de la tabla course tal que el costo
--no se encuentre en el retorno de la subquery
SELECT course_no, description, cost
FROM course
WHERE cost NOT IN
(SELECT cost
FROM course
WHERE prerequisite = 20);

--(Rischert, 2010, 328)
--Despliega el last_name, first_name de la tabla student tal que student_id se encuentre
--en los student_id que retorna la tabla enrollment en donde section_id este entre los
--ID que retorna la tabla section en donde la section_no sea igual a 8 y el course_no sea 20
SELECT last_name, first_name
FROM student 
WHERE student_id IN 
(SELECT student_id 
FROM enrollment
WHERE section_id IN 
(SELECT section_id 
FROM section
WHERE section_no = 8
AND course_no = 20));

--(Rischert, 2010, 328)
--Despliega el course_no y la description de la tabla course tal que course_no se encuentre en
--los course_no que retorna la subquery de la tabla section en donde location es igual a L211
SELECT course_no, description
FROM course
WHERE course_no IN
(SELECT course_no
FROM section
WHERE location = 'L211');

--(Rischert, 2010, 328)
--Despliega lo mismo que el select anterior
--Algunos subqueries se pueden sustituir por Unions
SELECT c.course_no, c.description
FROM course c, section s
WHERE c.course_no = s.course_no
AND s.location = 'L211';

--(Rischert, 2010, 329)
--Despliega el section_id, el max de numeric_grade de la tabla grade en donde
--grade_type_code sea igual a PJ y los agrupa por section_id
SELECT section_id, MAX(numeric_grade)
FROM grade
WHERE grade_type_code = 'PJ'
GROUP BY section_id;

--(Rischert, 2010, 329)
--Despliega el student_id, section_id, numeric_grade de la tabla grade en donde
--grade_type_code sea PJ y tanto section_id y numeric_grade esten en los grupos que retorna
--section_id y el max de numeric_grade de la tabla grade en donde grade_type_code es PJ
SELECT student_id, section_id, numeric_grade
FROM grade
WHERE grade_type_code = 'PJ'
AND (section_id, numeric_grade) IN
(SELECT section_id, MAX(numeric_grade)
FROM grade
WHERE grade_type_code = 'PJ'
GROUP BY section_id);

--(Rischert, 2010, 330)
--Hace lo mismo que el select anterior pero en vez de usar subqueries se escribe de forma literal
SELECT student_id, section_id, numeric_grade
FROM grade
WHERE grade_type_code = 'PJ'
AND (section_id, numeric_grade) IN
((82, 77),
(88, 99), --...
(149, 83),
(155, 92));

--(Rischert, 2010, 330)
--Despliega el course_no y prerequisite de la tabla course en donde
--course_no sea igual a los valores 120, 220, 310
SELECT course_no, prerequisite
FROM course
WHERE course_no IN (120, 220, 310);

--(Rischert, 2010, 330)
--No retorna nada a pesar de que haya valores diferentes a 80 y NULL
--Esto ocurre por como NULL es manejado por NOT IN
SELECT course_no, prerequisite
FROM course
WHERE prerequisite NOT IN
(SELECT prerequisite
FROM course
WHERE course_no IN (310, 220));

--(Rischert, 2010, 331)
--Retorna el course_no y el prerequisite de la tabla course tal que no existe en los valores que
--retorna el subquery.
SELECT course_no, prerequisite
FROM course c
WHERE NOT EXISTS
(SELECT '*'
FROM course
WHERE course_no IN (310, 220)
AND c.prerequisite = prerequisite);

--(Rischert, 2010, 331)
--Da un error porque ORDER BY no esta permitido en los subqueries
SELECT course_no, description, cost
FROM course
WHERE cost IN
(SELECT cost
FROM course
WHERE prerequisite = 420
ORDER BY cost);

--========================================================================================================================
--													Ejercicios 8.1

--a) Write a SQL statement that displays the first and last names of the students who registered first.
SELECT first_name, last_name FROM student 
WHERE registration_date = 
(SELECT MIN(registration_date) FROM student);

--b) Show the sections with the lowest course cost and a capacity equal to or lower than the average
--capacity.Also display the course description,section number,capacity,and cost.
SELECT c.description, s.section_no, c.cost, s.capacity
FROM course c, section s
WHERE c.course_no = s.course_no
AND s.capacity <= 
(SELECT AVG(capacity) FROM section)
AND c.cost =
(SELECT MIN(cost) FROM course);

--c) Select the course number and total capacity for each course.Show only the courses with a total
--capacity less than the average capacity of all the sections.
SELECT course_no, SUM(capacity)
FROM section
GROUP BY course_no
HAVING SUM(capacity) <
(SELECT AVG(capacity) FROM section);

--d) Choose the most ambitious students:Display the STUDENT_ID for the students enrolled in the
--most sections.
SELECT student_id, COUNT(*)
FROM enrollment
GROUP BY student_id
HAVING COUNT(*) =
(SELECT MAX(COUNT(*)) FROM enrollment GROUP BY student_id);

--e) Select the STUDENT_ID and SECTION_ID of enrolled students living in zip code 06820.
SELECT student_id, section_id
FROM enrollment
WHERE student_id IN
(SELECT student_id FROM student WHERE zip = '06820');

--f) Display the course number and course description of the courses taught by instructor Fernand
--Hanks.
SELECT course_no, description
FROM course
WHERE course_no IN
(SELECT course_no FROM section WHERE instructor_id IN
(SELECT instructor_id FROM instructor WHERE last_name = 'Hanks' AND first_name = 'Fernand'));

--g) Select the last names and first names of students not enrolled in any class.
SELECT last_name, first_name
FROM student
WHERE student_id NOT IN
(SELECT student_id FROM enrollment);

--h) Determine the STUDENT_ID and last name of students with the highest FINAL_GRADE for each
--section.Also include the SECTION_ID and the FINAL_GRADE columns in the result.
SELECT s.student_id, s.last_name, e.final_grade,
e.section_id
FROM enrollment e, student s
WHERE e.student_id = s.student_id
AND (e.final_grade, e.section_id) IN
(SELECT MAX(final_grade), section_id FROM enrollment GROUP BY section_id);

--i) Select the sections and their capacity,where the capacity equals the number of students enrolled.
SELECT section_id, capacity
FROM section
WHERE (section_id, capacity) IN
(SELECT section_id, COUNT(*) FROM enrollment GROUP BY section_id);

--========================================================================================================================

/*												CAP 8
|||||||||||||||||||||||||||||||||||||| 8.2 "Correlated Subqueries" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 339)
--Despliega el student_id, section_id, numeric_grade de la tabla grade en donde
--grade_type_code sea PJ y tanto section_id y numeric_grade esten en los grupos que retorna
--section_id y el max de numeric_grade de la tabla grade en donde grade_type_code es PJ
SELECT student_id, section_id, numeric_grade
FROM grade
WHERE grade_type_code = 'PJ'
AND (section_id, numeric_grade) IN
(SELECT section_id, MAX(numeric_grade)
FROM grade
WHERE grade_type_code = 'PJ'
GROUP BY section_id);

--(Rischert, 2010, 340)
--Realiza lo mismo que el select anterior, solo que ahora hace uso de una subquery correlacionada
--Correlated subqueries son aquellas que hacen referencia a columnas exteriores
SELECT student_id, section_id, numeric_grade
FROM grade outer
WHERE grade_type_code = 'PJ'
AND numeric_grade =
(SELECT MAX(numeric_grade)
FROM grade
WHERE grade_type_code = outer.grade_type_code
AND section_id = outer.section_id);

--//PASOS QUE REALIZA UNA CORRELATED SUBQUERY
--(Rischert, 2010, 340)
-- 1. Selecciona una tupla de la consulta externa
SELECT student_id, section_id, numeric_grade
FROM grade outer
WHERE grade_type_code = 'PJ';

--(Rischert, 2010, 341)
-- 2. Determina el valor de la(s) columna(s) correlacionadas
--	En el caso anterior, el valor sera PJ
-- 3. Ejecuta la consulta interna
SELECT MAX(numeric_grade)
FROM grade
WHERE grade_type_code = 'PJ' --Valor determinado por la consulta exterior
AND section_id = 155;

--(Rischert, 2010, 341)
-- 4. Evalua la condicion
-- 5. Repite del paso 2 al 4 para cada tupla
SELECT MAX(numeric_grade)
FROM grade
WHERE grade_type_code = 'PJ'
AND section_id = 133;

--(Rischert, 2010, 342)
--Despliega el instructor_id, last_name, first_name y zip de la tabla instructor si existen
--tuplas en donde el instructor_id sea igual en la tabla section
--'X' es una convencion e indica que es irrelevante el retorno del query
SELECT instructor_id, last_name, first_name, zip
FROM instructor i
WHERE EXISTS
(SELECT 'X'
FROM section
WHERE i.instructor_id = instructor_id);

--(Rischert, 2010, 342)
--Realiza lo mismo que el select anterior pero usando IN
SELECT instructor_id, last_name, first_name, zip
FROM instructor
WHERE instructor_id IN
(SELECT instructor_id
FROM section);

--(Rischert, 2010, 343)
--Realiza lo mismo que las dos consultas anteriores pero usando EQUIJOINS
SELECT DISTINCT i.instructor_id, i.last_name,
i.first_name, i.zip
FROM instructor i JOIN section s
ON i.instructor_id = s.instructor_id;

--(Rischert, 2010, 343)
--Despliega la informacion de los instructores que no fueron asignados a ninguna seccion
--NOT EXIST evalua si no existe alguna tupla
SELECT instructor_id, last_name, first_name, zip
FROM instructor i
WHERE NOT EXISTS
(SELECT 'X'
FROM section
WHERE i.instructor_id = instructor_id);

--(Rischert, 2010, 343)
--Despliega la informacion de los instructores que no tienen ZIP
SELECT instructor_id, last_name, first_name, zip
FROM instructor i
WHERE NOT EXISTS
(SELECT 'X'
FROM zipcode
WHERE i.zip = zip);

--(Rischert, 2010, 344)
--Intenta hacer lo mismo que el select de arriba, pero zip al tener nulls, no retorna nada.
SELECT instructor_id, last_name, first_name, zip
FROM instructor
WHERE zip NOT IN
(SELECT zip
FROM zipcode);

--(Rischert, 2010, 344)
--Despliega la capacidad total para los cursos con estudiantes inscritos
--Este select muestra resultados incorrectos debido a la relacion uno a muchos
SELECT s.course_no, SUM(s.capacity)
FROM enrollment e, section s
WHERE e.section_id = s.section_id
GROUP BY s.course_no;

--(Rischert, 2010, 345)
--Demuestra que la capacidad calculada anteriormente es incorrecta
SELECT section_id, capacity
FROM section
WHERE course_no = 20;

--(Rischert, 2010, 345)
--Despliega la section_id, capacity, student_id y course_no de la union de enrollment y section
--Muestra el error de forma clara
SELECT s.section_id, s.capacity, e.student_id,
s.course_no
FROM enrollment e, section s
WHERE e.section_id = s.section_id
AND s.course_no = 20
ORDER BY section_id;

--(Rischert, 2010, 345)
--El resultado deseado se obtiene con la siguiente consulta
SELECT course_no, SUM(capacity)
FROM section s
WHERE EXISTS
(SELECT NULL
FROM enrollment e, section sect
WHERE e.section_id = sect.section_id
AND sect.course_no = s.course_no)
GROUP BY course_no;

--========================================================================================================================
--													Ejercicios 8.2

/*
a) Explain what the following correlated subquery accomplishes.
SELECT section_id, course_no
FROM section s
WHERE 2 >
(SELECT COUNT(*)
FROM enrollment
WHERE section_id = s.section_id)
SECTION_ID COURSE_NO
---------- --------
79       	350
80        	10
...
145       	100
149       	120
27 rows selected.
*/
--Despliega las secciones que tienen menos de dos estudiantes inscritos. Incluye los que no tienen estudiantes

--b) List the sections where the enrollment exceeds the capacity of a section and show the number of
--enrollments for the section using a correlated subquery.
SELECT section_id, COUNT(*) FROM enrollment e GROUP BY section_id
HAVING COUNT(*) > (SELECT capacity FROM section WHERE e.section_id = section_id);

--c) Write a SQL statement to determine the total number of students enrolled,using the EXISTS
--operator.Count students enrolled in more than one course as one.
SELECT COUNT(*) FROM student s WHERE EXISTS
(SELECT NULL FROM enrollment WHERE student_id = s.student_id);

--d) Show the STUDENT_ID,last name,and first name of each student enrolled in three or more
--classes.
SELECT first_name, last_name, s.student_id FROM enrollment e, student s
WHERE e.student_id = s.student_id GROUP BY first_name, last_name, s.student_id HAVING COUNT(*) >= 3;

--e) Which courses do not have sections assigned? Use a correlated subquery in the solution.
SELECT course_no, description FROM course c
WHERE NOT EXISTS (SELECT 'X' FROM section WHERE c.course_no = course_no);

--f) Which sections have no students enrolled? Use a correlated subquery in the solution and order
--the result by the course number,in ascending order.
SELECT course_no, section_id
FROM section s
WHERE NOT EXISTS
(SELECT NULL
FROM enrollment
WHERE s.section_id = section_id)
ORDER BY course_no;

--========================================================================================================================

/*												CAP 8
|||||||||||||||||||||||||||||||||||| 8.3 "Inline Views and Scalar Subquery Expressions" ||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 355)
--Despliega la union entre la subquery (INLINE VIEW) y la tabla student en donde el id es igual
SELECT e.student_id, e.section_id, s.last_name
FROM (SELECT student_id, section_id, enroll_date
FROM enrollment
WHERE student_id = 123) e,
student s
WHERE e.student_id = s.student_id;

--(Rischert, 2010, 356)
--Despliega los datos de la union entre las subqueries enr y cap y entre la tabla course
SELECT enr.num_enrolled "Enrollments",
enr.num_enrolled * c.cost "Actual Revenue",
cap.capacity "Total Capacity",
cap.capacity * c.cost "Potential Revenue"
FROM 
(SELECT COUNT(*) num_enrolled
FROM enrollment e, section s
WHERE s.course_no = 20
AND s.section_id = e.section_id) 
enr,
(SELECT SUM(capacity) capacity
FROM section
WHERE course_no = 20) 
cap,
course c
WHERE c.course_no = 20;

--(Rischert, 2010, 357)
--Retorna los primeros 5 apellidos y nombres de la tabla student
SELECT last_name, first_name
FROM student
WHERE ROWNUM <=5;

--(Rischert, 2010, 358)
--Muestra los 3 promedios mas altos de la seccion 101. Basicamente, el Top-3
--Esto es posible gracias al uso de la pseudocolumna ROWNUM
SELECT ROWNUM, numeric_grade
FROM (SELECT DISTINCT numeric_grade
FROM grade
WHERE section_id = 101
AND grade_type_code = 'FI'
ORDER BY numeric_grade DESC)
WHERE ROWNUM <= 3;

--(Rischert, 2010, 359)
--Despliega cuantos alumnos hay por cada ciudad del estado CT
SELECT city, state, zip,
(SELECT COUNT(*)
FROM student s
WHERE s.zip = z.zip) AS student_count
FROM zipcode z
WHERE state = 'CT';

--(Rischert, 2010, 359)
--Despliega el apellido y estado del que provienen los estudiantes cuyas ID estan entre el 100 y 120
--Es mejor usar joins, porque a veces este tipo de scalar subqueries suelen ser ineficientes
SELECT student_id, last_name,
(SELECT state
FROM zipcode z
WHERE z.zip = s.zip) AS state
FROM student s
WHERE student_id BETWEEN 100 AND 120;

--(Rischert, 2010, 359)
--Despliega el ID del estudiante y su apellido de la tabla studen de aquellos estudiantes que se inscribieron
--en mas cursos que el promedio
--Es probable que hacer esto mediante equijoins sea mas eficiente
SELECT student_id, last_name
FROM student s
WHERE (SELECT COUNT(*)
FROM enrollment e
WHERE s.student_id = e.student_id) > 
(SELECT AVG(COUNT(*))
FROM enrollment
GROUP BY student_id)
ORDER BY 1;

--(Rischert, 2010, 360)
--Los subqueries tambien se pueden usar en el order by
--Despliega el student_id y last_name de los estudiantes cuyas ID esten entre la 230 y 235 y los ordena 
--por el numero de materias en las que estan inscritos
SELECT student_id, last_name
FROM student s
WHERE student_id BETWEEN 230 AND 235
ORDER BY (SELECT COUNT(*)
FROM enrollment e
WHERE s.student_id = e.student_id) DESC;

--(Rischert, 2010, 361)
--Tambien se puede aplicar en la condicion case
--Despliega el COURSE_NO, cost y el Test Case de la tabla course de aquellos cursos cuyo no. sea o 20 o 80
--y los ordena por costo
--El case hace un calculo en funcion de si el costo es menor que el promedio del costo de la tabla course
SELECT course_no, cost, 
CASE WHEN cost <= (SELECT AVG(cost) FROM course) THEN
cost *1.5
WHEN cost =  (SELECT MAX(cost) FROM course) THEN
(SELECT cost FROM course
WHERE course_no = 20)
ELSE cost
END "Test CASE"
FROM course
WHERE course_no IN (20, 80)
ORDER BY 2;

--(Rischert, 2010, 361)
--Las subqueries tambien se pueden usar como condicion
SELECT course_no, cost,
CASE WHEN (SELECT cost*2
FROM course
WHERE course_no = 134)
<= (SELECT AVG(cost) FROM course) THEN
cost *1.5
WHEN cost = (SELECT MAX(cost) FROM course) THEN
(SELECT cost FROM course
WHERE course_no = 20)
ELSE cost
END "Test CASE"
FROM course
WHERE course_no IN (20, 80)
ORDER BY 2;

--(Rischert, 2010, 362)
--Despliega el student_id, section_id y el last_name en letras mayus de aquellos estudiantes cuya ID este entre 100
--y 110
SELECT student_id, section_id,
UPPER((SELECT last_name
FROM student 
WHERE student_id = e.student_id))
"Last Name in Caps"
FROM enrollment e
WHERE student_id BETWEEN 100 AND 110;

--========================================================================================================================
--													Ejercicios 8.3

/*a) Write a query that displays the SECTION_ID and COURSE_NO columns,along with the number of
students enrolled in sections with the IDs 93,101,and 103.Use a scalar subquery to write the
query.The result should look similar to the following output.
SECTION_ID COURSE_NO NUM_ENROLLED
---------- --------- -----------
93	        25            0
103	       310            4
101	       240           12
3 rows selected.
*/
SELECT section_id, course_no,
(SELECT COUNT(*)
FROM enrollment e
WHERE s.section_id = e.section_id)
AS num_enrolled
FROM section s
WHERE section_id IN (101, 103, 93);

/*b) What problem does the following query solve?
SELECT g.student_id, section_id, g.numeric_grade,
gr.average
FROM grade g JOIN
(SELECT section_id, AVG(numeric_grade) average
FROM grade
WHERE section_id IN (94, 106)
AND grade_type_code = 'FI'
GROUP BY section_id) gr
USING (section_id)
WHERE g.grade_type_code = 'FI'
AND g.numeric_grade > gr.average
STUDENT_ID SECTION_ID NUMERIC_GRADE   AVERAGE
---------- ---------- ------------- --------
140         94            85	      84.5
200        106            92	        89
145        106            91	        89
130        106            90	        89
4 rows selected.
*/
--Muestra los datos de aquellos estudiantes que tienene una calificacion mayor al promedio

/*c) For each course number,display the total capacity of theindividual sections.Include the number
of students enrolled and the percentage of the course that is filled.The result should look similar
to the following output.
COURSE_NO TOTAL_CAPACITY TOTAL_STUDENTS Filled Percentage
--------- -------------- -------------- ----------------
240             25             13                52
230             27             14             51.85
...
450             25              1                 4
134             65              2              3.08
25 rows selected.
*/
SELECT a.course_no, total_capacity, total_students,
ROUND(100/total_capacity*total_students, 2)
"Filled Percentage"
FROM (SELECT COUNT(*) total_students, s.course_no
FROM enrollment e, section s
WHERE e.section_id = s.section_id
GROUP BY s.course_no) a,
(SELECT SUM(capacity) total_capacity, course_no
FROM section
GROUP BY course_no) b
WHERE b.course_no = a.course_no
ORDER BY "Filled Percentage" DESC;

--d) Determine the top five courses with the largest numbers of enrollments.
SELECT ROWNUM Ranking, course_no, num_enrolled
FROM (SELECT COUNT(*) num_enrolled, s.course_no
FROM enrollment e, section s
WHERE e.section_id = s.section_id
GROUP BY s.course_no
ORDER BY 1 DESC)
WHERE ROWNUM <= 5;

--========================================================================================================================

/*												CAP 8
|||||||||||||||||||||||||||||||||||||| 8.4 "ANY,SOME,and ALL Operators in Subqueries" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 368)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84;

--(Rischert, 2010, 368)
--Despliega la section_id, numeric_grade de la tabla grade en donde la ID sea 84 YEAR
-- el numeric_grade sea o 77 o 99
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade IN (77, 99);

--(Rischert, 2010, 369)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
--y numeric_grade es menor que 80 o 90
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade < ANY (80, 90);

--(Rischert, 2010, 369)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
--y numeric_grade es mayor que 80 o 90
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade > ANY (80, 90);

--(Rischert, 2010, 370)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
--y numeric_grade es igual que 80 o 90
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade = ANY (80, 90);

--(Rischert, 2010, 370)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
--y numeric_grade es igual que 80 o 90
--Logicamente es igual que el select anterior
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade IN (80, 90);

--(Rischert, 2010, 370)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
--y numeric_grade es menor que 80 y 90
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade < ALL (80, 90);

--(Rischert, 2010, 370)
--Despliega la section y el numeric_grade de la tabla grade donde el ID de la seccion es 84
--y numeric_grade es diferente que 80 o 90
SELECT section_id, numeric_grade
FROM grade
WHERE section_id = 84
AND numeric_grade <> ALL (80, 90);

--========================================================================================================================
--													Ejercicios 8.3

--a) Write a SELECT statement to display the STUDENT_ID,SECTION_ID,and grade for every student
--who received a final examination grade better than allof his or her individual homework grades.
SELECT student_id, section_id, numeric_grade
FROM grade g
WHERE grade_type_code = 'FI'
AND numeric_grade > ALL
(SELECT numeric_grade
FROM grade
WHERE grade_type_code = 'HM'
AND g.section_id = section_id
AND g.student_id = student_id);

--b) Based on the result of exercise a,what do you observe about the row with STUDENT_ID 102 and
--SECTION_ID 89?
SELECT student_id, section_id, grade_type_code,
MAX(numeric_grade) max, MIN(numeric_grade) min
FROM grade
WHERE student_id = 102
AND section_id = 89
AND grade_type_code IN ('HM', 'FI')
GROUP BY student_id, section_id, grade_type_code;

--c) Select the STUDENT_ID,SECTION_ID,and grade of every student who received a final examination
--grade better than anyof his or her individual homework grades.
SELECT student_id, section_id, numeric_grade
FROM grade g
WHERE grade_type_code = 'FI'
AND numeric_grade > ANY
(SELECT numeric_grade
FROM grade
WHERE grade_type_code = 'HM'
AND g.section_id = section_id
AND g.student_id = student_id);

--d) Based on the result of exercise c,explain the result of the row with STUDENT_ID 102 and
--SECTION_ID 89.
SELECT student_id, section_id, grade_type_code,
numeric_grade
FROM grade
WHERE student_id = 102
AND section_id = 89
AND grade_type_code IN ('HM', 'FI');

--========================================================================================================================
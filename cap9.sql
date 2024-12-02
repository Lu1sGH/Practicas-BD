SPOOL C:\guest\schemasetup\Cap9OUT.txt
SET ECHO OFF;
/*												CAP 9
|||||||||||||||||||||||||||||||||||||| 9.1 "The Power of UNION and UNION ALL" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 379)
--Une las tuplas resultantes de ambos selects
--Los resultados se ordenan conforme vayan apareciendo 
--Student tiene 268 tuplas e instructor tiene 10, pero solo se seleccionan 
--276 porque union quita las tuplas duplicadas en ambos selects
SELECT first_name, last_name, phone
FROM instructor
UNION
SELECT first_name, last_name, phone
FROM student;

--(Rischert, 2010, 379)
--Muestra los estudiantes que aparecen dos veces en la tabla
--Union solo muestra las tuplas que son DISTINCT
SELECT first_name, last_name, phone, COUNT(*)
FROM student
GROUP BY first_name, last_name, phone
HAVING COUNT(*) > 1;

--(Rischert, 2010, 379)
--Une los dos selects sin quitar las tuplas repetidas
SELECT first_name, last_name, phone
FROM instructor
UNION ALL
SELECT first_name, last_name, phone
FROM student;

--(Rischert, 2010, 380)
--Ordena la union de acuerdo a los apellidos
--Se recomienda hacer el ORDER BY por la posicion de la columna con respecto
--a la que se quiere ordenar
--Tambien se puede ordenar por el alias de la columna
SELECT instructor_id id, first_name, last_name, phone
FROM instructor
UNION
SELECT student_id, first_name, last_name, phone
FROM student
ORDER BY 3;

--(Rischert, 2010, 384)
--Ordena el resultado de acuerdo a una prioridad dada en la columna 3
SELECT created_by, 'GRADE' AS SOURCE, 1 AS SORT_ORDER
FROM grade
UNION
SELECT created_by, 'GRADE_TYPE', 2
FROM grade_type
UNION
SELECT created_by, 'GRADE_CONVERSION', 3
FROM grade_conversion
UNION
SELECT created_by, 'ENROLLMENT', 4
FROM enrollment
ORDER BY 3;

--(Rischert, 2010, 385)
--A falta de columnas, se usan NULLs casteados al respectivo tipo de dato faltante, esto para
--evitar conversiones implicitas
SELECT DISTINCT salutation, CAST(NULL AS NUMBER),
state, z.created_date
FROM instructor i, zipcode z
WHERE i.zip = z.zip
UNION ALL
SELECT salutation, COUNT(*),
state, TO_DATE(NULL)
FROM student s, zipcode z
WHERE s.zip = z.zip
GROUP BY salutation, state;

--========================================================================================================================
--													Ejercicios 9.1

/*a) Explain the result of the following set operation and explain why it works.
SELECT first_name, last_name,
'Instructor' "Type"
FROM instructor
UNION ALL
SELECT first_name, last_name,
'Student'
FROM student
*/
--Une todos los elementos de la tabla instructor y student e indica quien es que

--b) Write a set operation,using the UNION set operator,to list all the zip codes in the INSTRUCTOR
--and STUDENT tables.
SELECT zip FROM instructor
UNION
SELECT zip FROM student;

/*c) What problem does the following set operation solve?
SELECT created_by
FROM enrollment
UNION
SELECT created_by
FROM grade
UNION
SELECT created_by
FROM grade_type
UNION
SELECT created_by
FROM grade_conversion
CREATED_BY
---------
ARISCHER
BMOTIVAL
BROSENZW
CBRENNAN
DSCHERER
JAYCAF
MCAFFREY
7 rows selected.
*/
--Despliega los usuarios que crearon un registro en las tablas a las que se les hacen los selects

/*d) Explain why the result of the following set operation returns an error.
SELECT course_no, description
FROM course
WHERE prerequisite IS NOT NULL
ORDER BY 1
UNION
SELECT course_no, description
FROM course
WHERE prerequisite IS NULL
*/
--El ORDER BY debe ser usado al final

/*e) What is wrong with the following set operation,and what do you have to change to make it work
correctly?
SELECT instructor_id, last_name
FROM instructor
UNION
SELECT last_name, student_id
FROM student
*/
--Las columnas no tienen el mismo tipo de dato

--========================================================================================================================

/*												CAP 9
|||||||||||||||||||||||||||||||||||||| 9.2 "The MINUS and INTERSECT Set Operators" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 388)
--Despliega los instructores que no estan dando ninguna clase
--A las tuplas de instructor se les quita aquellas que estan en section
SELECT instructor_id
FROM instructor
MINUS
SELECT instructor_id
FROM section;

--(Rischert, 2010, 388)
--Despliega todos los instructores
SELECT instructor_id
FROM instructor;

--(Rischert, 2010, 388)
--Despliega los instructores que estan enseñando
SELECT DISTINCT instructor_id
FROM section;

--(Rischert, 2010, 389)
--Despliega los usuarios que no crearon una inscripcion y un curso
SELECT created_by
FROM enrollment
MINUS
SELECT created_by
FROM course;

--(Rischert, 2010, 389)
--Despliega los usuarios que crearon una inscripcion
SELECT DISTINCT created_by
FROM enrollment;

--(Rischert, 2010, 389)
--Despliega los usuarios que crearon un curso
SELECT DISTINCT created_by
FROM course;

--(Rischert, 2010, 390)
--Despliega los usuarios que crearon una inscripcion y un curso
SELECT created_by
FROM enrollment
INTERSECT
SELECT created_by
FROM course;

--(Rischert, 2010, 390)
--Un equijoin que despliega los cursos que estan tanto en la tabla course como en section
SELECT DISTINCT c.course_no
FROM course c, section s
WHERE c.course_no = s.course_no;

--(Rischert, 2010, 391)
--Realiza lo mismo que la consulta anterior
--La desventaja de usar INTERSECT es que no se pueden poner columnas que no existen en ambas tablas
SELECT course_no
FROM course
INTERSECT
SELECT course_no
FROM section;

--(Rischert, 2010, 391)
--El orden de ejecucion es de arriba hacia abajo.
--La siguientes operaciones despliegan 1, 4
SELECT col1
FROM t1
UNION ALL
SELECT col2
FROM t2
MINUS
SELECT col3
FROM t3;

--(Rischert, 2010, 392)
--Despliega 1, 2, 3, 4 porque antes de hacer la union, se hace la diferencia entre el segundo select y el tercero
SELECT col1
FROM t1
UNION ALL
(SELECT col2
FROM t2
MINUS
SELECT col3
FROM t3);

--(Rischert, 2010, 392)
--Muestra los cambios que ha habido entre una vieja version y una nueva de una tabla
(SELECT *
FROM old_table
MINUS
SELECT *
FROM new_table)
UNION ALL
(SELECT *
FROM new_table
MINUS
SELECT *
FROM old_table);

--========================================================================================================================
--													Ejercicios 9.1

/*a) Explain the result of the following set operation.
SELECT course_no, description
FROM course
MINUS
SELECT s.course_no, c.description
FROM section s, course c
WHERE s.course_no = c.course_no
*/
--Despliega los cursos que no tienen ninguna seccion

--b) Use the MINUS set operator to create a list of courses and sections with no students enrolled.Add
--to the result set a column with the title Status and display the text No Enrollments in each row.
--Order the results by the COURSE_NO and SECTION_NO columns.
SELECT course_no, section_no, 'No Enrollments' "Status"
FROM section
MINUS
SELECT course_no, section_no, 'No Enrollments'
FROM section s
WHERE EXISTS (SELECT section_id
FROM enrollment e
WHERE e.section_id = s.section_id)
ORDER BY 1, 2;

--c) Use the appropriate set operator to list all zip codes that are in both the STUDENT and
--INSTRUCTOR tables.
SELECT zip
FROM instructor
INTERSECT
SELECT zip
FROM student;

--d) Use the INTERSECT set operator to list student IDs for students who are enrolled.
SELECT student_id
FROMstudent
INTERSECT
SELECT student_id
FROM enrollment;

--========================================================================================================================

SPOOL OFF;
SPOOL C:\guest\schemasetup\Cap4OUT.txt
/*												CAP 4
|||||||||||||||||||||||||||||||||||||| 4.1 "Character Functions" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Rischert, 2010, 135)
--Despliega los estados de la tabla zipcode
SELECT state, --Despliega los estados tal y como están guardados
LOWER(state), --Despliega los estados en minúsculas
LOWER('State') --Despliega la palabra 'State' en minúsculas
FROM zipcode;

--(Rischert, 2010, 136)
--Despliega las ciudades y estados de la tabla zipcode donde zip sea igual a '10035'
SELECT UPPER(city) as "Upper Case City", --Despliega city en mayús y le da alias "Upper Case City"
state, --Despliega los estados tal y como están guardados
INITCAP(state) --Despliega los estados en mayús
FROM zipcode
WHERE zip = '10035';

--(Rischert, 2010, 136)
--Despliega las ciudades y estados de la tabla zipcode
--El num indica la cantidad de chars que medira la columna.
--El resto de chars que queden libres después de la consulta se llenaran con lo que esté entre ''
SELECT 
RPAD(city, 20, '*') "City Name", --Right Pad. A la derecha de la consulta
LPAD(state, 10, '-') "State Name" --Left Pad. A la izquierda de la consulta
FROM zipcode;

--(Rischert, 2010, 137)
--Despliega las ciudades de la tabla zipcode
--El tercer parámetro es opcional y lo llena con espacios en blanco
SELECT LPAD(city, 20) AS "City Name"
FROM zipcode;

--(Rischert, 2010, 138)
--Despliega los sig valores, que no existen en ninguna tabla, a través de dual.
SELECT LTRIM('0001234500', '0') 'Left', --Quita los valores no queridos a la izquierda
RTRIM('0001234500', '0') 'Right', --Quita los valores no queridos a la derecha
LTRIM(RTRIM('0001234500', '0'), '0') 'Both' --Quita los valores no queridos en ambos lados.
FROM dual;
-- Ej. 1234500 00012345 12345

--(Rischert, 2010, 139)
--Despliega los sig valores, que no existen en ninguna tabla, a través de dual.
--STX: TRIM([LEADING|TRAILING|BOTH] char1 FROM char2) [Both es opcional]
SELECT TRIM(LEADING '0' FROM '0001234500') 'leading', --Quita los valores no queridos a la izquierda (cabeza)
TRIM(TRAILING '0' FROM '0001234500') 'trailing', --Quita los valores no queridos a la derecha (cola)
TRIM('0' FROM '0001234500') 'both' --Quita los valores no queridos en ambos lados.
FROM dual;
--Ej. 1234500 00012345 12345

--(Rischert, 2010, 139)
--Despliega el sig valor, que no existe en ninguna tabla, a través de dual.
--Si no recibe parámetros, quita los espacios en blanco.
SELECT TRIM(' 00012345 00 ') AS "Blank Trim" 
FROM dual
--Ej. [00012345 00] 

--(Rischert, 2010, 139)
--Selecciona 3 veces el apellido de los estudiantes y a 2 de estas les aplica la fun SUBSTR
SELECT last_name, --Despliega todo el apellido
SUBSTR(last_name, 1, 5), --Despliega el apellido desde la posición 1 con una longitud de 5 chars
SUBSTR(last_name, 6) --Despliega el apellido desde la posición 6 sin long determinada
FROM student;

--(Rischert, 2010, 140)
--Despliega la descripción y la descripción con la fun INSTR
SELECT description, INSTR(description, 'er') --Regresa la posición en donde aparece el string buscado
FROM course;

--(Rischert, 2010, 140)
--Despliega la longitud de la cadena 'Hello there'
SELECT LENGTH('Hello there')
FROM dual;

--(Rischert, 2010, 141)
--Despliega el nombre y apellido de los estudiantes cuyos apellidos inicien con 'Mo'
SELECT first_name, last_name
FROM student
WHERE SUBSTR(last_name, 1, 2) = 'Mo'; --WHERE last_name LIKE 'Mo%' despliega lo mismo

--(Rischert, 2010, 141)
--Despliega el nombre y apellido de los estudiantes cuyo nombre tenga un punto y 
--los ordena de acuerdo a la longitud de sus apellidos
SELECT first_name, last_name
FROM student
WHERE INSTR(first_name, '.') > 0
ORDER BY LENGTH(last_name);

--(Rischert, 2010, 142)
--NESTED FUNCTIONS (Funciones Anidadas)
--Selecciona la ciudad de la tabla zipcode donde el estado sea CT, y le aplica dos operaciones anidadas.
SELECT RPAD(UPPER(city), 20,'.') --Coloca la ciudad en mayús y rellena el resto de la long de chars con '.'
FROM zipcode
WHERE state = 'CT';

--(Rischert, 2010, 142)
--Selecciona los apellidos de la tabla estudiantes donde el punto esté en la pos 3 o más adelante.
--A 2 de estas selecciones les aplica funciones anidadas.
SELECT first_name,
SUBSTR(first_name, INSTR(first_name, '.')-1) mi, --Extrae la subcadena que hay una pos antes del punto
SUBSTR(first_name, 1, INSTR(first_name, '.')-2) first --Extrae la substr desde las pos 1 hasta dos pos antes del punto
FROM student
WHERE INSTR(first_name, '.') >= 3;

--(Rischert, 2010, 143)
--Despliega la ciudad y el estado de la tabla zipcode, pero concatenados.
SELECT CONCAT(city, state)
FROM zipcode;

--(Rischert, 2010, 143)
--Despliega la ciudad, el estado y zip de la tabla zipcode, pero concatenados.
--CONCAT solo acepta dos parámetros, pero || permite concatenar más
SELECT city||state||zip
FROM zipcode;

--(Rischert, 2010, 143)
--Despliega la ciudad, el estado y zip de la tabla zipcode. Los concatena con un ', ' y un ' '
SELECT city||', '||state||' '||zip
FROM zipcode;

--(Rischert, 2010, 144)
--Despliega la cadena 'My hand is asleep' pero con la cadena 'hand' reemplazada por 'foot'
SELECT REPLACE('My hand is asleep', 'hand', 'foot')
FROM dual;
--My foot is asleep

--(Rischert, 2010, 144)
--Despliega la cadena 'My hand is asleep' pero con la cadena 'x' reemplazada por 'foot'
--Si no encuentra la cadena del segundo parámetro, despliega la cadena original.
SELECT REPLACE('My hand is asleep', 'x', 'foot')
FROM dual;

--(Rischert, 2010, 144-145)
--Despliega los números de la tabla estudiantes que cumplan con la condición.
--A diferencia de REPLACE, TRANSLATE provee de una sustitución de chars de uno en uno.
SELECT phone
FROM student
WHERE TRANSLATE(phone, '0123456789', --La condición es aquellos números de que sean diferentes
'##########') <> '###-###-####'; --al formato '###-###-####'. # sustituye a cada num del 0-9 en este caso.

--(Rischert, 2010, 145)
--Despliega la id y el apellido de los estudiantes cuyos apellidos suenan fonéticamente como 'Martin';
--SOUNDEX permite comparar diferentes palabras que suenen parecido, fonéticamente hablando.
SELECT student_id, last_name
FROM student
WHERE SOUNDEX(last_name) = SOUNDEX('MARTIN');

--(Rischert, 2010, 152)
--Despliega los estudiantes y empleadores de la tabla estudiante cuyo empleador tenga el patrón '%B_B%'
--Recordemos que _ es una wildcard para LIKE, lo que se hace entonces es remplazar _ por +.
SELECT student_id, employer
FROM student
WHERE TRANSLATE(employer, '_', '+') LIKE '%B+B%';

--(Rischert, 2010, 152)
--Despliega los estudiantes y empleadores de la tabla estudiante cuyo empleador tenga un 'B_B'
SELECT student_id, employer
FROM student
WHERE INSTR(employer, 'B_B') > 0;

--(Rischert, 2010, 152)
--Despliega los estudiantes y empleadores de la tabla estudiante cuyo empleador tenga el patrón '%B_B%'
--El \ indíca que el _ debe ser considerado como un caracter literal y no una wildcard.
SELECT student_id, employer
FROM student
WHERE employer LIKE '%B\_B%' ESCAPE '\' ';

--========================================================================================================================
--													Ejercicios 4.1

--a) Execute the following SQL statement. Based on the result, what is the purpose of the INITCAP function?
SELECT description "Description",
INITCAP(description) "Initcap Description"
FROM course
WHERE description LIKE '%SQL%';
--La función pone en mayús la primera letra de cada palabra y forza al resto a permanecer minús.

--b) What question does the following SQL statement answer?
SELECT last_name
FROM instructor
WHERE LENGTH(last_name) >= 6;
--¿Qué instructores tienen un nombre que tenga 6 o más carácteres?

--c) Describe the result of the following SQL statement. Pay particular attention to the negative number parameter.
SELECT SUBSTR('12345', 3), --Extrae la subcadena 345
SUBSTR('12345', 3, 2), --Extrae la subcadena 34
SUBSTR('12345', -4, 3) --Extrae la subcadena 234, el negativo hace que cuente desde el final del string
FROM dual;


--d) Based on the result of the following SQL statement, describe the purpose of the LTRIM and RTRIM functions.
SELECT zip, LTRIM(zip, '0'), RTRIM(ZIP, '4')
FROM zipcode
ORDER BY zip;
--Trim recorta el caracter señalado de acuerdo a la posición.

--e) What do you observe when you execute the next statement? How should the statement be
-- changed to achieve the desired result?
SELECT TRIM('01' FROM '01230145601')
FROM dual;
--Trim solo debe contener un caracter. Para obtener el resultado deseado se debe anidar LTRIM y RTRIM.

--f) What is the result of the following statement?
SELECT TRANSLATE('555-1212', '0123456789',
'##########')
FROM dual;
--###-####, porque pasa los números del 0 al 9 a #

--g) Write a SQL statement to retrieve students who have a last name with the lowercase letter o
-- occurring three or more times.
SELECT student_id, last_name
FROM student
WHERE INSTR(last_name, 'o', 1, 3) > 0;
/*Regresa la posición de la tercera ocurrencia. El número de ocurrencias se indica en el 4to parámetro.
En el 3ro se indica desde donde se inicia a buscar las ocurrencias.
Si encuentra menos de 3 ocurrencias, regresa 0. */

--h) The following statement determines how many times the string 'ed' occurs in the phrase 'Fred fed
-- Ted bread, and Ted fed Fred bread'. Explain how this is accomplished.
SELECT (
LENGTH('Fred fed Ted bread, and Ted fed Fred bread.') -
LENGTH(REPLACE('Fred fed Ted bread, and Ted fed Fred bread.', 'ed', NULL))) /2 
AS occurr
FROM dual;
--Calcula la longitud de la cadena. Después, quita todos los 'ed' que hay y 
-- calcula la longitud de la cadena resultante. Resta dicha longitud a la long original y divide entre
-- el número de letras del string 'ed'.

--i) Write a SELECT statement that returns each instructor’s last name, followed by a comma and a
-- space, followed by the instructor’s first name, all in a single column in the result set.
SELECT last_name||', '||first_name
FROM instructor;

--j) Using functions in the SELECT list and WHERE and ORDER BY clauses, write a SELECT statement
--that returns course numbers and course descriptions from the COURSE table and looks like the
--following result set. Use the SQL Developer Run Script icon to display the result in fixed-width
--format.
/*
Description
--------------------------------------
204.......Intro to SQL
130.......Intro to Unix
25........Intro to Programming
230.......Intro to the Internet
120.......Intro to Java Programming
240.......Intro to the BASIC Language
20........Intro to Information Systems
*/
SELECT RPAD(course_no, 10, '.')||description as Description
FROM course
WHERE INSTR(description, 'Intro') = 1 --Similar a LIKE 'Intro%'
ORDER BY LENGTH(description);
--========================================================================================================================

/*												CAP 4
|||||||||||||||||||||||||||||||||||||| 4.2 "Number Functions" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 158)
--Despliega la cadena 'The absolute value of -29 is ' concatenada con el valor absoluto de -29
-- obtenido con la fun ABS.
SELECT 'The absolute value of -29 is '||ABS(-29)
FROM dual;

--(Rischert, 2010, 158)
--Despliega el num -14; el signo de -14, 14 y 0; y el valor absoluto de -14.
--SIGN regresa 1 si es positivo, -1 si es negativo.
SELECT -14, SIGN(-14), SIGN(14), SIGN(0), ABS(-14)
FROM dual;

--(Rischert, 2010, 159)
--Despliega el num 222.34501, 222.35 y 222.34.
--Round redondea al num de decimales que le indiques. Trunc solo despliega los decimales indicados.
SELECT 222.34501,
ROUND(222.34501, 2),
TRUNC(222.34501, 2)
FROM dual;

--(Rischert, 2010, 159)
--Despliega el num 222.34501, 200 y 200.
--Round y Trunc también pueden afectar el lado izquierdo del punto dándole parámetros negativos.
SELECT 222.34501,
ROUND(222.34501, -2),
TRUNC(222.34501, -2)
FROM dual;
/*SINTAXIS:
ROUND(value [, precision])
TRUNC(value [, precision])
*/

--(Rischert, 2010, 160)
--Despliega el num 2.617, 3 y 2.
--Si no se le da precisión, redondea al entero más próximo o trunca en el número actual.
SELECT 2.617, ROUND(2.617), TRUNC(2.617)
FROM dual;

--(Rischert, 2010, 160)
--Despliega 22, 23, 22 y 23.
--FLOOR() retorna el mayor entero menor o igual que un valor. 
--CEIL() retorna el menor entero mayor o igual que un valor.
SELECT FLOOR(22.5), CEIL(22.5), TRUNC(22.5), ROUND(22.5)
FROM dual;

--(Rischert, 2010, 160)
--Retorna el residuo de 23/8.
SELECT MOD(23, 8)
FROM dual;

--(Rischert, 2010, 161)
--Despliega 4, 4.0E+000, 5 y 4.0E+000
--En Oracle se puede trabajar de acuerdo al estandar IEEE para aritmética de punto flotante.
--El redondeo se hará al par más cercano si se trabaja con BINARY_FLOAT o BINARY_DOUBLE.
--El resultado se expresará en notación científica.
--Hacer operaciones con punto flotante es más rápido que con números por cuestiones de hardware.
SELECT ROUND(3.5), ROUND(3.5f), ROUND(4.5), ROUND(4.5f)
FROM dual;

--(Rischert, 2010, 162)
--Despliega el residuo de 23/8 y el resto de 23/8. Es decir, 7 y -1.
--MOD:  (23-(8*FLOOR(23/8))). REMAINDER: (23-(8*ROUND(23/8))).
--Remainder calcula de acuerdo a la especificación del IEEE.
SELECT MOD(23,8), REMAINDER(23,8)
FROM DUAL;

--(Rischert, 2010, 162)
--Despliega el residuo de 23/8 y el resto de 23/8. Es decir, 7 y -1.
SELECT (23-(8*FLOOR(23/8))) AS mod,
(23-(8*ROUND(23/8))) AS remainder
FROM DUAL;

--(Rischert, 2010, 163)
--Despliega el costo de los cursos, que tengan distinto precio, con las operaciones indicadas aplicadas.
SELECT DISTINCT cost, cost + 10,
cost - 10, cost * 10, cost / 10
FROM course;

--(Rischert, 2010, 163)
--Despliega el costo de los cursos, que tengan distinto precio, con las operaciones indicadas aplicadas.
SELECT DISTINCT cost + (cost * .10)
FROM course;

--========================================================================================================================
--													Ejercicios 4.2

--a) Describe the effect of the negative precision as a parameter of the ROUND function in the
--following SQL statement.
SELECT 10.245, ROUND(10.245, 1), ROUND(10.245, -1)
FROM dual;
--Redondea una posición antes del punto.

--b) Write a SELECT statement that displays distinct course costs. In a separate column, show the COST
--increased by 75% and round the decimals to the nearest dollar.
SELECT DISTINCT cost, cost*1.75, ROUND(cost*1.75)
from course;

--c) Write a SELECT statement that displays distinct numeric grades from the GRADE table and half
--those values expressed as a whole number in a separate column.
SELECT DISTINCT numeric_grade, ROUND(numeric_grade/2)
FROM grade;
--========================================================================================================================

/*												CAP 4
|||||||||||||||||||||||||||||||||||||| 4.3 "Miscellaneous Single-Row Functions" ||||||||||||||||||||||||||||||||||||||
Rischert, A. (2010). Oracle SQL By Example.
*/

--(Rischert, 2010, 167)
--Retorna Unknown al operar con un Unknown value (Null)
SELECT 60+60+NULL
FROM dual;

--(Rischert, 2010, 167)
--Retorna 1120.
--Si NVL tiene como parametro de entrada NULL, retorna la sustitución.
--Si NVL tiene algo distinto como parametro de entrada de Null, retorna el parametro de entrada.
SELECT 60+60+NVL(NULL, 1000)
FROM dual;

--(Rischert, 2010, 168)
--Retorna error porque prerequisite es numérico.
SELECT course_no, description,
NVL(prerequisite, 'Not Applicable') prereq
FROM course
WHERE course_no IN (20, 100);

--(Rischert, 2010, 168)
--Despliega el num de curso, la descripción y el prerequisito de los cursos.
--Si el prerequisito es nulo, entonces muestra 'No aplicable'
SELECT course_no, description,
NVL(TO_CHAR(prerequisite), 'Not Applicable') prereq
FROM course
WHERE course_no IN (20, 100);

--(Rischert, 2010, 169)
--Despliega las columnas y su tipo. Además, muestran si tienen restricción de nulos.
DESCRIBE grade_summary;

--(Rischert, 2010, 169)
--Despliega el id del estudiante, su calf midterm, el calf de su examen final y el calf quiz.
--COALESCE es como NVL, pero permite evaluar multiple sustituciones para un valor nulo.
--SINTAXIS: COALESCE(input_expression, substitution_expression_1, [, substitution_expression_n])
SELECT student_id, midterm_grade, finalexam_grade, quiz_grade,
COALESCE(midterm_grade, finalexam_grade, quiz_grade) "Coalesce"
FROM grade_summary;
/*
STUDENT_ID MIDTERM_GRADE FINALEXAM_GRADE QUIZ_GRADE Coalesce
---------- ------------- --------------- ----------- --------
123 		90 				50 				100 		90
456 		80 				95 							80
678 		98 											98
789 						78 				85 			78
999																--Si todo es nulo, entonces regresa nulo.
*/

--(Rischert, 2010, 170)
--Despliega el no. de curso, la descripción y el prerequisito de los cursos cuyos números de curso sean 20 o 100.
--Si el prerequisito es nulo, despliega 'No Aplicable'
SELECT course_no, description,
COALESCE(TO_CHAR(prerequisite), 'Not Applicable') prereq
FROM course
WHERE course_no IN (20, 100);

--(Rischert, 2010, 170)
--Despliega los costos que sean distintos de la tabla course.
--Si el valor no es nulo, despliega 'existe'. Si lo es, despliega 'nada'.
--NVL2 SINTAXIS: NVL2(input_expr, not_null_substitution_expr, null_substitution_expr)
SELECT DISTINCT cost,
NVL2(cost, 'exists', 'none') "NVL2"
FROM course;

--(Rischert, 2010, 171)
--Despliega el no. de curso y el costo de los cursos que no cumplan con la condición.
--LNNVL regresa True si recibe False o Unknown.
--LNNVL solo puede aplicarse en el WHERE.
SELECT course_no, cost
FROM course
WHERE LNNVL(cost < 1500);

--(Rischert, 2010, 171)
--Despliega el no. de estudiante, la fecha de creación y modificación cuyo no. de estudiante sea 150 o 340.
--NULLIF retorna nulo si los dos parámetros son iguales. Si son distintos regresa el primer parámetro.
SELECT student_id,
TO_CHAR(created_date, 'DD-MON-YY HH24:MI:SS') "Created",
TO_CHAR(modified_date, 'DD-MON-YY HH24:MI:SS') "Modified",
NULLIF(created_date, modified_date) "Null if equal"
FROM student
WHERE student_id IN (150, 340);

--(Rischert, 2010, 172)
--Despliega test_col y test_col con la fun NANVL aplicada, esto de la tabla float_test.
--NANVL solo funciona con BINARY_FLOAT or DOUBLE. Retorna un valor de sustitución en caso de que no sea un num (NaN).
SELECT test_col, NANVL(test_col, 0)
FROM float_test;
/*
TEST_COL 	NANVL(TEST_COL,0)
---------- -----------------
2.5 		2.5
NaN 		0
*/

--(Rischert, 2010, 173)
--Despliega los estados que sean distintos en donde el estado sea NY o NJ o CT
--SINTAXIS: DECODE (if_expr, equals_search, then_result [,else_default])
SELECT DISTINCT state,
DECODE(state, 'NY', 'New York',
'NJ', 'New Jersey') no_default, --Si el estado es NY despliega New... Si el estado es NJ despliega New... Si no, retorna null
DECODE(state, 'NY', 'New York',
'NJ', 'New Jersey',
'OTHER') with_default --Mismo caso que arriba, pero si no concuerda con alguno de los dos, retorna OTHER
FROM zipcode
WHERE state IN ('NY','NJ','CT');
/*
ST NO_DEFAULT WITH_DEFAULT
-- ---------- ------------
CT 				OTHER
NJ New Jersey 	New Jersey
NY New York 	New York
*/

--(Rischert, 2010, 173)
--Despliega el no. de instructor y su zip donde el no. de instructor sea 102 o 110.
SELECT instructor_id, zip,
DECODE(zip, NULL, 'NO zipcode!', zip) "Decode Use" --Si zip es nulo, despliega 'No Zipcode!'. En otro caso, despliega el
-- valor de zip.
FROM instructor
WHERE instructor_id IN (102, 110);

--(Rischert, 2010, 174)
--Despliega el no. de curso, el costo y un nuevo costo de los cursos cuyo no. de curso sea 80 o 20 o 135 o 450.
--Los ordena de acuerdo al costo.
--DECODE no permite comparaciones de mayor que o menor que.
SELECT course_no, cost,
DECODE(SIGN(cost-1195),-1, 500, cost) newcost --Si el signo es negativo, entonces el nuevo precio es 500, si no,
-- el precio se mantiene.
FROM course
WHERE course_no IN (80, 20, 135, 450)
ORDER BY 2;

--(Rischert, 2010, 174)
--Tiene el mismo efecto que la consulta anterior.
--CASE es menos restrictivo
SELECT course_no, cost,
CASE WHEN cost <1195 THEN 500
ELSE cost
END "Test CASE"
FROM course
WHERE course_no IN (80, 20, 135, 450)
ORDER BY 2;
/*
SINTAXIS:
CASE {WHEN condition THEN return_expr
	[WHEN condition THEN return_expr]... }
	[ELSE else_expr]
END
*/

--(Rischert, 2010, 175)
--Despliega el no. de curso, el costo y un 'Test CASE' de los cursos cuyo no. de curso sea 80 o 20 o 135 o 450.
--Los ordena de acuerdo al costo.
SELECT course_no, cost,
CASE WHEN cost <1100 THEN 1000 --Cuando el costo es menor a 1100, entonces regresa 1000
WHEN cost >=1100 AND cost <1500 THEN cost*1.1 --Cuando es mayor o igual que 1100 y menor que 1500, el costo se multiplica
WHEN cost IS NULL THEN 0 --Cuando el costo es nulo, entonces es 0
ELSE cost	--En otro caso, el costo es el mismo.
END "Test CASE"
FROM course
WHERE course_no IN (80, 20, 135, 450)
ORDER BY 2;

--(Rischert, 2010, 175)
--Despliega el no. de curso, el costo, el prerequisito y un 'Test Case' de los 
-- cursos cuyo no. de curso sea 80 o 20 o 135 o 450 o 230.
--CASEs anidados (nested).
SELECT course_no, cost, prerequisite,
CASE WHEN cost <1100 THEN	--Cuando el costo es menor a 1100, entonces:
CASE WHEN prerequisite IN (10, 50) THEN cost/2 --cuando el prerequisito es 10 o 50, el costo se divide entre 2
ELSE cost	--de otro modo, el costo se mantiene.
END
WHEN cost >=1100 AND cost <1500 THEN cost*1.1
WHEN cost IS NULL THEN 0
ELSE cost
END "Test CASE"
FROM course
WHERE course_no IN (80, 20, 135, 450, 230)
ORDER BY 2;

--(Rischert, 2010, 176)
--Despliega la capacidad y locación de la tabla section 
SELECT DISTINCT capacity, location
FROM section
WHERE capacity*CASE
WHEN SUBSTR(location, 1,1)='L' THEN 2 --Multiplica la capacidad por 2 si la locación inicia con L
WHEN SUBSTR(location, 1,1)='M' THEN 1.5 --Multiplica la capacidad por 1.5 si la locación inicia con M
ELSE NULL
END > 30 --Solo si el resultado de la multipliación es mayor que 30 se despliega.

--(Rischert, 2010, 176)
--Regresa error porque los tipos de datos no concuerdan con el de la primera condición.
--Se intenta desplegar el no. de la sección y su capacidad. Cuando la capacidad sea mayor o igual que 15
-- despliega la capacidad. Cuando sea menor que 15 despliega el mensaje 'Room too small'.
--Esto en donde el no. de sección sea 101 o 146 o 147.
SELECT section_id, capacity,
CASE WHEN capacity >=15 THEN capacity
WHEN capacity < 15 THEN 'Room too small'
END AS "Capacity"
FROM section
WHERE section_id IN (101, 146, 147);

--(Rischert, 2010, 177)
--Despliega el no. de la sección y su capacidad. Cuando la capacidad sea mayor o igual que 15
-- despliega la capacidad. Cuando sea menor que 15 despliega el mensaje 'Room too small'.
--Esto en donde el no. de sección sea 101 o 146 o 147.
SELECT section_id, capacity,
CASE WHEN capacity >=15 THEN TO_CHAR(capacity)
WHEN capacity < 15 THEN 'Room too small'
END AS "Capacity"
FROM section
WHERE section_id IN (101, 146, 147);

--(Rischert, 2010, 178)
--Despliega el no. de curso, el costo y 'Simple case' cuyo no. de costo sea 80 o 20 o 135 o 450, ordenados por costo.
--Simple case
SELECT course_no, cost,
CASE cost WHEN 1095 THEN cost/2 --cuando el costo sea 1095, se divide entre 2
WHEN 1195 THEN cost*1.1 --cuando sea 1195 se multiplica por 1.1
WHEN 1595 THEN cost --cuando sea 1595, el costo se mantiene
ELSE cost*0.5 --en otro caso, se multiplica por 0.5
END "Simple CASE"
FROM course
WHERE course_no IN (80, 20, 135, 450)
ORDER BY 2;

--========================================================================================================================
--													Ejercicios 4.3

--a) List the last names, first names, and phone numbers of students who do not have phone
--numbers. Display 212-555-1212 for the phone number.
SELECT first_name name, last_name Last_name,
phone oldphone,
NVL(phone, '212-555-1212') newphone
FROM student
WHERE phone IS NUL;

--b) For course numbers 430 and greater, show the course cost. Add another column, reflecting a
--discount of 10% off the cost, and substitute any NULL values in the COST column with the
--number 1000. The result should look similar to the output shown in Figure 4.7 (pp. 179).
SELECT course_no, cost,
NVL(cost,1000)*0.9 new
FROM course
WHERE course_no >= 430;

/*c) Write the query to accomplish the following output, using the NVL2 function in the column Get
this result.

ID 	NAME 			PHONE 		Get this result
--- -------------- ------------ -----------------
112 Thomas Thomas  201-555-5555 Phone# exists.
111 Peggy Noviello 				No phone# exists.

2 rows selected
*/
SELECT student_id id, first_name||' '|| last_name name,
phone,
NVL2(phone, 'Phone# exists.', 'No phone# exists.')
"Get this result"
FROM student
WHERE student_id IN (111, 112)
ORDER BY 1 DESC;

--d) Rewrite the query from Exercise c, using the DECODE function instead.
SELECT student_id, first_name, last_name,
phone,
DECODE(phone, NULL, 'No phone# exists.', 'Phone# exists.')
"Get this result"
FROM student
WHERE student_id IN (111, 112)
ORDER BY 1 DESC;

/*e) For course numbers 20, 120, 122, and 132, display the description, course number, and prerequisite
course number. If the prerequisite is course number 120, display 200; if the prerequisite is 130,
display N/A. For courses with no prerequisites, display None. Otherwise, list the current
prerequisite. The result should look as follows.

COURSE_NO DESCRIPTION 					ORIGINAL NEW
--------- ----------------------------- -------- ----
132		  Basics of Unix Admin 			130 	 N/A
122 	  Intermediate Java Programming 120 	 200
120 	  Intro to Java Programming		80 		 80
20 		  Intro to Information Systems 			 None

4 rows selected.
*/

SELECT course_no, description, prerequisite "Original",
CASE WHEN prerequisite = 120 THEN '200'
WHEN prerequisite = 130 THEN 'N/A'
WHEN prerequisite IS NULL THEN 'None'
ELSE TO_CHAR(prerequisite)
END "NEW"
FROM course
WHERE course_no IN (20, 120, 122, 132)
ORDER BY course_no DESC;

/*f) Display the student IDs, zip codes, and phone numbers for students with student IDs 145, 150, or
325. For students living in the 212 area code and in zip code 10048, display North Campus. List
students living in the 212 area code but in a different zip code as West Campus. Display students
outside the 212 area code as Off Campus. The result should look like the following output. Hint:
The solution to this query requires nested DECODE functions or nested CASE expressions.

STUDENT_ID ZIP 	 PHONE 			 LOC
---------- ----- --------------- ------------
145 	   10048 212-555-5555 	 North Campus
150 	   11787 718-555-5555 	 Off Campus
325 	   10954 212-555-5555 	 West Campus

3 rows selected.
*/
SELECT student_id, zip, phone,
CASE WHEN SUBSTR(phone, 1, 3) = '212' THEN
CASE WHEN zip = '10048' THEN 'North Campus'
ELSE 'West Campus'
END
ELSE 'Off Campus'
END loc
FROM student
WHERE student_id IN (150, 145, 325);

--g) Display all the distinct salutations used in the INSTRUCTOR table. Order them alphabetically,
--except for female salutations, which should be listed first. Hint: Use the DECODE function or CASE
--expression in the ORDER BY clause.
SELECT DISTINCT salutation
FROM instructor
ORDER BY DECODE(salutation, 'Ms', '1',
'Mrs', '1',
'Miss', '1',
salutation);
--========================================================================================================================

SPOOL OFF
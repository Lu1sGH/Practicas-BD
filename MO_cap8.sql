SPOOL C:\guest\schemasetup\MO8OUT.txt
SET ECHO OFF;
/*														CAP 8
|||||||||||||||||||||||||||||||||||||||||||||||||| 8 "Hierarchical Queries" ||||||||||||||||||||||||||||||||||||||||||||||||||
Mishra, S. & Beaulie, A. (2002). Mastering Oracle.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Mishra, 2002, 158)
--Despliega todas las tuplas de la base EMPLOYEE
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE;

--(Mishra, 2002, 160)
--Despliega todas las tuplas que tengan en MANAGER_EMP_ID null
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE MANAGER_EMP_ID IS NULL;

--(Mishra, 2002, 160)
--Despliega el nodo padre inmediato, en este caso, el jefe de cada empleado.
SELECT E.LNAME "Employee", M.LNAME "Manager"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_EMP_ID = M.EMP_ID;
--Retorna 13 tuplas

--(Mishra, 2002, 161)
--Cuenta el numero de tuplas en EMPLOYEE
SELECT COUNT(*) FROM EMPLOYEE;
--Retorna 14

--(Mishra, 2002, 161)
--Despliega el nodo padre inmediato, en este caso, el jefe de cada empleado.
--Esta consulta inclute a King, porque se hace un outer join
SELECT E.LNAME "Employee", M.LNAME "Manager"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_EMP_ID = M.EMP_ID (+);
--Retorna 14

--(Mishra, 2002, 162)
--Despliega el mensaje "No rows selected". Deberia de mostrar aquellos
--empleados que no son jefes de otros (las hojas del arbol).
--Esto se debe a que hay un null y estos no pueden ser comparados.
SELECT * FROM EMPLOYEE
WHERE EMP_ID NOT IN (SELECT MANAGER_EMP_ID FROM EMPLOYEE);

--(Mishra, 2002, 162)
--Despliega los empleados que no son jefes de ningun otro.
--Primero se quitan los nulls y despues se hace la consulta
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE E
WHERE EMP_ID NOT IN
(SELECT MANAGER_EMP_ID FROM EMPLOYEE
WHERE MANAGER_EMP_ID IS NOT NULL);

--(Mishra, 2002, 162)
--Despliega lo mismo que la consulta anterior. En este caso se usa
--EXIST en vez de IN
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE E
WHERE NOT EXISTS
(SELECT EMP_ID FROM EMPLOYEE E1 WHERE E.EMP_ID = E1.MANAGER_EMP_ID);

--(Mishra, 2002, 163)
--Enlista cada empleado con su jefe.
--Usa outer joins por la existencia de NULL en los datos.
SELECT E_TOP.LNAME, E_2.LNAME, E_3.LNAME, E_4.LNAME
FROM EMPLOYEE E_TOP, EMPLOYEE E_2, EMPLOYEE E_3, EMPLOYEE E_4
WHERE E_TOP.MANAGER_EMP_ID IS NULL
AND E_TOP.EMP_ID = E_2.MANAGER_EMP_ID (+)
AND E_2.EMP_ID = E_3.MANAGER_EMP_ID (+)
AND E_3.EMP_ID = E_4.MANAGER_EMP_ID (+);
--No es la mejor forma porque tenemos que conocer todos cuantos
--niveles hay en el arbol.

--(Mishra, 2002, 164)
--Despliega los datos de los empleados en orden jerarquico.
--START WITH indica la raiz. Si no se coloca, se consideraran a todos los nodos como raiz.
--CONNECT BY indica la relacion entre los nodos hijos y los nodos padre.
--PRIOR se utiliza para evaluar la condicion de la tupla actual con la tupla padre. Prior solo
--se utiliza en consultas jerarquicas.
SELECT LNAME, EMP_ID, MANAGER_EMP_ID
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY PRIOR EMP_ID = MANAGER_EMP_ID;

--(Mishra, 2002, 165)
--Realiza lo mismo que la consulta anterior.
--Prior no requiere aparecer primero en la condicion.
SELECT LNAME, EMP_ID, MANAGER_EMP_ID
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 166)
--Despliega en orden jerarquico las tuplas de la tabla ASSEMBLY.
--Cuando una relacion padre-hijo es de dos o mas columnas, se tiene que usar PRIOR antes de cada una de las columnas padre.
SELECT * FROM ASSEMBLY
START WITH PARENT_ASSEMBLY_TYPE IS NULL --Nodos
AND PARENT_ASSEMBLY_ID IS NULL --padre
CONNECT BY PARENT_ASSEMBLY_TYPE = PRIOR ASSEMBLY_TYPE
AND PARENT_ASSEMBLY_ID = PRIOR ASSEMBLY_ID;

--(Mishra, 2002, 166)
--LEVEL es una pseudocolumna que muestra el nivel en el que se encuentra cada tupla
SELECT LEVEL, LNAME, EMP_ID, MANAGER_EMP_ID
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 167)
--Determina el numero de niveles que tiene el arbol.
SELECT COUNT(DISTINCT LEVEL)
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY PRIOR EMP_ID = MANAGER_EMP_ID;

--(Mishra, 2002, 167)
--Determina el numero de empleados por cada nivel.
SELECT LEVEL, COUNT(EMP_ID)
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY PRIOR EMP_ID = MANAGER_EMP_ID
GROUP BY LEVEL;

--(Mishra, 2002, 168)
--Enlista el nombre de los empleados de acuerdo a su prioridad jerarquica
SELECT LEVEL, LPAD(' ',2*(LEVEL - 1)) || LNAME "EMPLOYEE",
EMP_ID, MANAGER_EMP_ID
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY PRIOR EMP_ID = MANAGER_EMP_ID;

--(Mishra, 2002, 168)
--Esto tambien se puede hacer colocando un condicion.
--Despliega aquellos empleados que tienen un salario mayor a 2000.
SELECT LEVEL, LPAD(' ',2*(LEVEL - 1)) || LNAME "EMPLOYEE",
 EMP_ID, MANAGER_EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY > 2000
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 169)
--Despliega el subarbol que se genera del empleado JONES.
--Se indica a JONES como la raiz del (sub)arbol.
SELECT LEVEL, LPAD('    ',2*(LEVEL - 1)) || LNAME "EMPLOYEE",
EMP_ID, MANAGER_EMP_ID, SALARY
FROM EMPLOYEE
START WITH LNAME = 'JONES'
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 169)
--Despliega a los empleados que estan bajo el empleado mas antiguo de la compañia.
--En este caso la condicion cambia y se usa una scalar subquery.
SELECT LEVEL, LPAD('    ',2*(LEVEL - 1)) || LNAME "EMPLOYEE",
EMP_ID, MANAGER_EMP_ID, SALARY
FROM EMPLOYEE
START WITH HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE)
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 170)
--Responde a la pregunta ¿Jones tiene autoridad sobre Blake? R. No, por lo tanto, el select retorna nada.
SELECT *
FROM EMPLOYEE
WHERE LNAME = 'BLAKE'
START WITH LNAME = 'JONES'
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 170)
--Responde a la pregunta ¿Jones tiene autoridad sobre Smith? R. Si, por lo que regresa una tupla con los datos
--de Smith.
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE LNAME = 'SMITH'
START WITH LNAME = 'JONES'
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 171)
--Borra el subarbol que se genera a partir de JONES
/*DELETE FROM EMPLOYEE
WHERE EMP_ID IN
(SELECT EMP_ID FROM EMPLOYEE
START WITH LNAME = 'JONES'
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID);*/

--(Mishra, 2002, 171)
--Despliega al empleado más alto (en la jerarquia) de cada departamento y cuyos jefes pertenecen a otros departamentos
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID
AND DEPT_ID != PRIOR DEPT_ID; --Esta condicion indica que sus jefes deben de ser de otro departamento

--(Mishra, 2002, 172)
--Enlista el top de niveles de un arbol jerarquico. En este caso solo se enlistan hasta el nivel 2.
SELECT EMP_ID, LNAME, DEPT_ID, MANAGER_EMP_ID, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE LEVEL <= 2
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 172)
--Suma los sueldos de los empleados que dependen de JONES.
SELECT SUM(SALARY)
FROM EMPLOYEE
START WITH LNAME = 'JONES'
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID;

--(Mishra, 2002, 173)
--Hace la suma de los salarios de cada uno de los posibles subarboles que se pueden formar. Para esto se usa una
--inline view.
SELECT LNAME, SALARY,
(SELECT SUM(SALARY) FROM EMPLOYEE T1
START WITH LNAME = T2.LNAME
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID) SUM_SALARY
FROM EMPLOYEE T2;

--(Mishra, 2002, 174)
/*1. A hierarchical query can’t use a join.
2. A hierarchical query cannot select data from a view that involves a join.
3. We can use an ORDER BY clause within a hierarchical query; however, the
ORDER BY clause takes precedence over the hierarchical ordering performed by
the START WITH...CONNECT BY clause. Therefore, unless all we care about is
the level number, it doesn’t make sense to use ORDER BY in a hierarchical query.*/

--(Mishra, 2002, 174)
--ORDER BY tiene precedencia a START WITH, por lo que el listado jerarquico no tendrá sentido.
SELECT LEVEL, LPAD('    ',2*(LEVEL - 1)) || LNAME "EMPLOYEE",
EMP_ID, MANAGER_EMP_ID, SALARY
FROM EMPLOYEE
START WITH MANAGER_EMP_ID IS NULL
CONNECT BY MANAGER_EMP_ID = PRIOR EMP_ID
ORDER BY SALARY;

SPOOL OFF;
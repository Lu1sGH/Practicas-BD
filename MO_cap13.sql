SPOOL C:\guest\schemasetup\MO13OUT.txt
SET ECHO OFF;
/*															CAP 13
||||||||||||||||||||||||||||||||||||||||||||||||| 13 "Advanced Analytic SQL" |||||||||||||||||||||||||||||||||||||||||||||||||
Mishra, S. & Beaulie, A. (2002). Mastering Oracle.
*/

set pagesize 300;
set linesize 250;
set colsep '|||';
set null Nulo;

--(Mishra, 2002, 268)
--Agrupa las ventas totales por region de aquellas ventas pertenecientes al 2001.
SELECT o.region_id region_id, SUM(o.tot_sales) tot_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.region_id;

--(Mishra, 2002, 268)
--Agrupa las ventas del 2001 por cliente y region
SELECT o.cust_nbr cust_nbr, o.region_id region_id,
SUM(o.tot_sales) tot_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.cust_nbr, o.region_id;

--(Mishra, 2002, 269)
--Muestra aquellos clientes cuyas ventas superaron el 20%
SELECT cust_sales.cust_nbr cust_nbr, cust_sales.region_id region_id,
cust_sales.tot_sales cust_sales, region_sales.tot_sales region_sales
FROM
(SELECT o.region_id region_id, SUM(o.tot_sales) tot_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.region_id) region_sales,
(SELECT o.cust_nbr cust_nbr, o.region_id region_id,
SUM(o.tot_sales) tot_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.cust_nbr, o.region_id) cust_sales
WHERE cust_sales.region_id = region_sales.region_id
AND cust_sales.tot_sales > (region_sales.tot_sales * .2);

--(Mishra, 2002, 270)
--Despliega el nombre completo, las ventas, el nombre de la region y el porcentaje que representa de la region de aquellos
--clientes que tuvieron ventas mayores al 20% de su region en el 2001.
SELECT c.name cust_name,
big_custs.cust_sales cust_sales, r.name region_name,
100 * ROUND(big_custs.cust_sales /
big_custs.region_sales, 2)  percent_of_region
FROM region r, customer c,
(SELECT cust_sales.cust_nbr cust_nbr, cust_sales.region_id region_id,
cust_sales.tot_sales cust_sales,
region_sales.tot_sales region_sales
FROM
(SELECT o.region_id region_id, SUM(o.tot_sales) tot_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.region_id) region_sales,
(SELECT o.cust_nbr cust_nbr, o.region_id region_id,
SUM(o.tot_sales) tot_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.cust_nbr, o.region_id) cust_sales
WHERE cust_sales.region_id = region_sales.region_id
AND cust_sales.tot_sales > (region_sales.tot_sales * .2)) big_custs
WHERE big_custs.cust_nbr = c.cust_nbr
AND big_custs.region_id = r.region_id;

--(Mishra, 2002, 270)
SELECT o.region_id region_id, o.cust_nbr cust_nbr,
SUM(o.tot_sales) tot_sales, --Se calcula la venta total de cada cliente en una determinada region
SUM(SUM(o.tot_sales)) OVER (PARTITION BY o.region_id) region_sales --Suma las ventas totales de todos los clientes que pertenecen a la misma region
FROM orders o
WHERE o.year = 2001
GROUP BY o.region_id, o.cust_nbr;
--En la columna de region_sales, todos los clientes que pertenezcan a la misma region tendran el mismo valor en esta columna.
--Esto permite conocer el numero de ventas totales por region sin colapsar la informacion.

--(Mishra, 2002, 271)
--Conociendo lo anterior, se puede reducir la consulta anterior a la anterior.
SELECT c.name cust_name,
cust_sales.tot_sales cust_sales, r.name region_name,
100 * ROUND(cust_sales.tot_sales /
cust_sales.region_sales, 2)  percent_of_region
FROM region r, customer c,
(SELECT o.region_id region_id, o.cust_nbr cust_nbr,
SUM(o.tot_sales) tot_sales,
SUM(SUM(o.tot_sales)) OVER (PARTITION BY o.region_id) region_sales
FROM orders o
WHERE o.year = 2001
GROUP BY o.region_id, o.cust_nbr) cust_sales
WHERE cust_sales.tot_sales > (cust_sales.region_sales * .2)
AND cust_sales.region_id = r.region_id
AND cust_sales.cust_nbr = c.cust_nbr;

--(Mishra, 2002, 273)
--Despliega las ventas totales que tuvo cada cliente por region.
SELECT region_id, cust_nbr, SUM(tot_sales) cust_sales
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY region_id, cust_nbr;

--(Mishra, 2002, 274)
--Hace un ranking de ventas de cada cliente del año 2001.
SELECT region_id, cust_nbr,
SUM(tot_sales) cust_sales,
RANK() OVER (ORDER BY SUM(tot_sales) DESC) sales_rank, --RANK retorna valores unicos. Si hay valores duplicados en las tuplas, retorna el mismo rank para esto y hay una brecha en los valores cuando se terminan los duplicados. Ej, 12, 12, 14.
DENSE_RANK() OVER (ORDER BY SUM(tot_sales) DESC) sales_dense_rank, --DENSE_RANK retorna valores unicos. Si hay valores duplicados en las tuplas, entonces les asigna el mismo rank.
ROW_NUMBER() OVER (ORDER BY SUM(tot_sales) DESC) sales_number --ROW_NUMBER retorna valores unicos. Si hay valores duplicados en las tuplas, es arbitrario lo que retorna.
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY 6;

--(Mishra, 2002, 275)
--Tambien se pueden hacer particiones.
--En este caso el ranking se hace por region.
SELECT region_id, cust_nbr, SUM(tot_sales) cust_sales,
RANK() OVER (PARTITION BY region_id
ORDER BY SUM(tot_sales) DESC) sales_rank,
DENSE_RANK() OVER (PARTITION BY region_id
ORDER BY SUM(tot_sales) DESC) sales_dense_rank,
ROW_NUMBER() OVER (PARTITION BY region_id
ORDER BY SUM(tot_sales) DESC) sales_number
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY 1,6;

--(Mishra, 2002, 277)
--Si existiera valores nulos, se puede especificar en que lugar van a aparecer.
SELECT region_id, cust_nbr, SUM(tot_sales) cust_sales,
RANK( ) OVER (ORDER BY SUM(tot_sales) DESC NULLS LAST) sales_rank
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr;

--(Mishra, 2002, 277)
--Se despliega el Top 5 vendedores del 2001.
SELECT s.name, sp.sp_sales total_sales
FROM salesperson s,
(SELECT salesperson_id, SUM(tot_sales) sp_sales,
RANK( ) OVER (ORDER BY SUM(tot_sales) DESC) sales_rank
FROM orders
WHERE year = 2001
GROUP BY salesperson_id) sp
WHERE sp.sales_rank <= 5
AND sp.salesperson_id = s.salesperson_id
ORDER BY sp.sales_rank;

--(Mishra, 2002, 278)
--Despliega la mejor y peor region en total de ventas del 2001.
SELECT
MIN(region_id)
KEEP (DENSE_RANK FIRST ORDER BY SUM(tot_sales) DESC) best_region, --FIRST selecciona el primer elemento del rank.
MIN(region_id)
KEEP (DENSE_RANK LAST ORDER BY SUM(tot_sales) DESC) worst_region --LAST selecciona el ultimo elemento del rank.
FROM orders
WHERE year = 2001
GROUP BY region_id;
--Se usa min en caso de que haya empates.

--(Mishra, 2002, 278)
--En este caso, el uso de min y max es indiferente porque no existe empates en los ranks. 
SELECT
MIN(region_id)
KEEP (DENSE_RANK FIRST ORDER BY SUM(tot_sales) DESC) min_best_region,
MAX(region_id)
KEEP (DENSE_RANK FIRST ORDER BY SUM(tot_sales) DESC) max_best_region,
MIN(region_id)
KEEP (DENSE_RANK LAST ORDER BY SUM(tot_sales) DESC) min_worst_region,
MAX(region_id)
KEEP (DENSE_RANK LAST ORDER BY SUM(tot_sales) DESC) max_worst_region
FROM orders
WHERE year = 2001
GROUP BY region_id;

--(Mishra, 2002, 279)
--Agrupa a los clientes en cuartiles.
SELECT region_id, cust_nbr, SUM(tot_sales) cust_sales,
NTILE(4) OVER (ORDER BY SUM(tot_sales) DESC) sales_quartile
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY 4,3 DESC;

--(Mishra, 2002, 280)
--Filtra a aquellos clientes que no representaron el 25% porciento de las ventas, es decir, solo muestra el primer cuartil.
SELECT r.name region, c.name customer, cs.cust_sales
FROM customer c, region r,
(SELECT region_id, cust_nbr, SUM(tot_sales) cust_sales,
NTILE(4) OVER (ORDER BY SUM(tot_sales) DESC) sales_quartile
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr) cs
WHERE cs.sales_quartile = 1
AND cs.cust_nbr = c.cust_nbr
AND cs.region_id = r.region_id
ORDER BY cs.cust_sales DESC;

--(Mishra, 2002, 281)
--A diferencia de NTILE, con WIDTH_BUCKET se pueden especificar los rangos
SELECT region_id, cust_nbr,
SUM(tot_sales) cust_sales,
WIDTH_BUCKET(SUM(tot_sales), 1, 3000000, 3) sales_buckets --El primer par es la exp que genera las cubetas, el 2do el inicio del rango, el 3ro el fin del rango y el 4to el num de cubetas a crear.
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY 3;
--La primera cubeta va del rango 1-1000000, la segunda del 1000001-2000000 y el tercero del 2000001-3000000

--(Mishra, 2002, 282)
--En este caso el rango se limita entre 1000000-2000000. Si hay ventas totales que se salgan de este rango se asignaran
--a la cubeta 0 si es menor al rango y a la 4 si es mayor.
SELECT region_id, cust_nbr,
SUM(tot_sales) cust_sales,
WIDTH_BUCKET(SUM(tot_sales), 1000000, 2000000, 3) sales_buckets
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY 3;

--(Mishra, 2002, 283)
--CUME_DIST y PERCENT_RANK calculan la relacion entre las tuplas que tienen un menor o igual rank con respecto
--a las otras filas de la particion.
SELECT region_id, cust_nbr,
SUM(tot_sales) cust_sales,
CUME_DIST() OVER (ORDER BY SUM(tot_sales) DESC) sales_cume_dist,
PERCENT_RANK() OVER (ORDER BY SUM(tot_sales) DESC) sales_percent_rank
FROM orders
WHERE year = 2001
GROUP BY region_id, cust_nbr
ORDER BY 3 DESC;

--(Mishra, 2002, 285)
--Se genera un ranking y datos de distribucion de las ventas del 2001 ordenadas por clientes.
SELECT cust_nbr, SUM(tot_sales) cust_sales,
RANK() OVER (ORDER BY SUM(tot_sales) DESC) rank,
DENSE_RANK() OVER (ORDER BY SUM(tot_sales) DESC) dense_rank,
CUME_DIST() OVER (ORDER BY SUM(tot_sales) DESC) cume_dist,
PERCENT_RANK() OVER (ORDER BY SUM(tot_sales) DESC) percent_rank
FROM orders
WHERE year = 2001
GROUP BY cust_nbr
ORDER BY 3;

--(Mishra, 2002, 285)
--Suponemos que hubo un cliente con ventas de 1000000, con la siguiente consulta podria saberse en que posicion pudo
--haber rankeado de haber sido el caso.
SELECT
RANK(1000000) WITHIN GROUP
(ORDER BY SUM(tot_sales) DESC) hyp_rank,
DENSE_RANK(1000000) WITHIN GROUP
(ORDER BY SUM(tot_sales) DESC) hyp_dense_rank,
CUME_DIST(1000000) WITHIN GROUP
(ORDER BY SUM(tot_sales) DESC) hyp_cume_dist,
PERCENT_RANK(1000000) WITHIN GROUP
(ORDER BY SUM(tot_sales) DESC) hyp_percent_rank
FROM orders
WHERE year = 2001
GROUP BY cust_nbr;

--(Mishra, 2002, 286)
--Calcula las ventas totales mensuales para la region 6.
SELECT month, SUM(tot_sales) monthly_sales
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY 1;

--(Mishra, 2002, 287)
--Muestra las ventas totales mensuales y el num de ventas totales en el año.
--Esta consulta es ineficiente porque calcula la suma total anual 12 veces.
SELECT month, SUM(tot_sales) monthly_sales,
SUM(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) total_sales
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 288)
--Con esta modificacion, se identifica el mes con mayor ventas y se acarrea hasta que se encuentre otro.
SELECT month, SUM(tot_sales) monthly_sales,
MAX(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) max_preceeding
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 288)
--Calcula el promedio de ventas entre el mes anterior, el actual y el siguiente.
SELECT month, SUM(tot_sales) monthly_sales,
AVG(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) rolling_avg
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 289)
--Hace lo mismo que la ventana anterior, pero en este caso se muestra los datos del mes anterior, el actual y el siguiente.
--Esto es util para responder preguntas como ¿como cada venta mensual se compara a la del primer mes?
SELECT month,
FIRST_VALUE(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) prev_month,
SUM(tot_sales) monthly_sales,
LAST_VALUE(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) next_month,
AVG(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) rolling_avg
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 290)
--Muestra el mes, las ventas mensuales y las ventas del mes anterior.
--Si se quisieran ver las del siguiente mes, se tendria que usar LEAD.
SELECT month, SUM(tot_sales) monthly_sales,
LAG(SUM(tot_sales), 1) OVER (ORDER BY month) prev_month_sales
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 291)
--Muestra la diferencia porcentual de ventas entre mes y mes.
SELECT months.month month, months.monthly_sales monthly_sales,
ROUND((months.monthly_sales — NVL(months.prev_month_sales,
months.monthly_sales)) /
NVL(months.prev_month_sales, months.monthly_sales),
3) * 100 percent_change
FROM
(SELECT month, SUM(tot_sales) monthly_sales,
LAG(SUM(tot_sales), 1) OVER (ORDER BY month) prev_month_sales
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month) months
ORDER BY month;

--(Mishra, 2002, 291)
--Muestra las ventas por mes y las ventas totales de la ventana (de un año).
SELECT month,
SUM(tot_sales) monthly_sales,
SUM(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) total_sales
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 292)
--Lo mismo se puede lograr usando Reporting Functions.
SELECT month,
SUM(tot_sales) monthly_sales,
SUM(SUM(tot_sales)) OVER (ORDER BY month
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) window_sales,
SUM(SUM(tot_sales)) OVER () reporting_sales --El () indica que el conjunto de resultados entero debe ir incluido en la suma, es decir, no hay particiones.
FROM orders
WHERE year = 2001
AND region_id = 6
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 293)
--Despliega el mes, las ventas totales mensuales y las ventas anuales del año 2001.
SELECT month,
SUM(tot_sales) monthly_sales,
SUM(SUM(tot_sales)) OVER () yearly_sales
FROM orders
WHERE year = 2001
GROUP BY month
ORDER BY month;

--(Mishra, 2002, 293)
--Despliega el total de ventas hecho por cada vendedor en cada region comparandolo con la venta total por region.
SELECT region_id, salesperson_id,
SUM(tot_sales) sp_sales,
SUM(SUM(tot_sales)) OVER (PARTITION BY region_id) region_sales
FROM orders
WHERE year = 2001
GROUP BY region_id, salesperson_id
ORDER BY region_id, salesperson_id;

--(Mishra, 2002, 294)
--Despliega el total de ventas hecho por cada vendedor en cada region y el porcentaje que representa de las ventas
--totales de la region.
SELECT region_id, salesperson_id,
SUM(tot_sales) sp_sales,
ROUND(SUM(tot_sales) /
SUM(SUM(tot_sales)) OVER (PARTITION BY region_id),
2) percent_of_region
FROM orders
WHERE year = 2001
GROUP BY region_id, salesperson_id
ORDER BY 1,2;

--(Mishra, 2002, 295)
--Esta consulta muestra lo mismo que la anterior, pero se hace uso de la funcion RATIO_TO_REPORT.
--Esta funcion permite calcular la contribucion de cada tupla con respecto al conjunto total.
SELECT region_id, salesperson_id,
SUM(tot_sales) sp_sales,
ROUND(RATIO_TO_REPORT(SUM(tot_sales))
OVER (PARTITION BY region_id), 2) sp_ratio
FROM orders
WHERE year = 2001
GROUP BY region_id, salesperson_id
ORDER BY 1,2;

SPOOL OFF;
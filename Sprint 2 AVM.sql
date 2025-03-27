# Nivel1
# Ejercicio 2

# º Listado de los países que están realizando compras.

select distinct country
from company 
;
--

# º Desde cuántos países se realizan las compras.

select count(distinct c.country) as paisesQueRealizanCompras
from company c
;



select t.amount, count(c.country) as paises
from company c
join transaction t
on c.id = t.company_id
where t.declined = 0
group by t.amount
order by 2 desc
;
--

# º Identifica a la compañía con la mayor media de ventas.
select c.company_name, round(avg(amount),2) as Media_Ventas
from company c
join transaction t
on c.id = t.company_id
where t.declined = 0
group by c.company_name
order by avg(amount) DESC
limit 1
;
--

# Ejercicio 3
# º Muestra todas las transacciones realizadas por empresas de Alemania. SIN USAR JOIN, solo SQ

select t.*
from transaction t
where t.company_id in (select id
					from company c
                    where c.country = 'Germany')
;

--
select *
from transaction t, company c
where c.country = 'Germany'
and c.id = t.company_id
;
-- 

# º Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
select company_name
from company
where id in (select t.company_id 
			from transaction t
			where t.amount > (select avg(t2.amount) from transaction t2)
)
;
--

# Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
select *
from company c
where c.id in (select t.company_id
				from transaction t
				where t.company_id is null)
;
--

select *
from transaction t
where t.company_id not in (select c.id
							from company c)
                            ;


--
# Nivel 2
# Ejercicio 1
# Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
# Muestra la fecha de cada transacción junto con el total de las ventas.

select date(t.timestamp) as date, sum(t.amount) as totalVentas
from transaction t
where t.declined = 0
group by 1
order by totalVentas DESC
limit 5
;
--

# Ejercicio 2
# ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

select country, round(avg(amount),2) as mediaVentas
from company c
join transaction t
on c.id = t.company_id
where t.declined = 0
group by country
order by 2 desc
;
--

# Ejercicio 3
# En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”. 
# Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.

# Muestra el listado aplicando JOIN y subconsultas.

select t.id as transactionID, t.company_id, user_id, t.timestamp, t.amount, t.declined, c.country, c.company_name
from company c
join transaction t
on t.company_id = c.id
where c.country=(select c2.country
				from company c2
				where c2.company_name = 'Non Institute'
                and c.company_name <> 'Non Institute')
;
--
select t.*
from company c
join transaction t
on t.company_id = c.id
where c.country=(select c2.country
				from company c2
				where c2.company_name = 'Non Institute'
                and c.company_name <> 'Non Institute')
;

select id
from company c2
where c2.company_name = 'Non Institute'
;

select *
from company
;
--

# Muestra el listado aplicando solo subconsultas.

select *
from transaction t
where t.company_id in (select c.id
				from company c
				where c.country = (select c3.country
							from company c3
							where c3.company_name = 'Non Institute')
				and c.company_name <> 'Non Institute')
				;
--

select t.id as transactionID, t.company_id, user_id, t.timestamp, t.amount, t.declined, c.country, c.company_name
from company c, transaction t
where c.id = t.company_id
and c.country =(select c2.country
				from company c2
				where c2.company_name = 'Non Institute')
and c.company_name <> 'Non Institute'
;
--
--
# Nivel 3
# Ejercicio 1
#Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 
#100 y 200 euros y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. 
# Ordena los resultados de mayor a menor cantidad.

select t.id as transactionID, c.company_name, c.country, date(t.timestamp) as date, t.amount
from company c
join transaction t
on c.id = t.company_id
where date(t.timestamp) in ( '2021-04-29', '2021-07-20', '2022-03-13')
and t.amount between 100 and 200
order by t.amount desc
;
--

# Ejercicio 2
#Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
#por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
#pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques 
#si tienen más de 4 transacciones o menos.

select c.company_name, count(t.amount) as transactionsAmount,
case 
	when count(t.id) > 4 then 'Más de cuatro transacciones'
    else 'Menos de cuatro transacciones'
    end as listadoTransacciones
from company c
join transaction t
on c.id = t.company_id
group by c.company_name
order by 2 desc
;
--

select c.company_name,
case 
	when count(t.id) > 4 then 'Más de cuatro transacciones'
    else 'Menos de cuatro transacciones'
    end as listadoTransacciones

from transaction t, company c
where c.id = t.company_id
group by c.company_name
order by listadoTransacciones asc
;
--

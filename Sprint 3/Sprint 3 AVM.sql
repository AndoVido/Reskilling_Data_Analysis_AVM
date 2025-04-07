# Nivel 1
# Ejercicio 1

create table transactions.credit_card (
id VARCHAR(15),
iban VARCHAR(50),
pan VARCHAR(20),
pin VARCHAR(4),
cvv INT,
expiring_date VARCHAR(20),
PRIMARY KEY (id)
);

alter table transaction
add foreign key (credit_card_id) references credit_card (id);

select * 
from credit_card;

--
# Ejercicio 2
# El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario con ID CcU-2938. 
# La información que debe mostrarse para este registro es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.

#identificar al usuario
select *
from credit_card cc
where cc.id = 'CcU-2938'
;

# actualizar la información del numero de cuenta del usuario con ID CcU-2938
update credit_card cc
set cc.iban = 'R323456312213576817699999' where (cc.id = 'CcU-2938');

# verificar que la actualización se ha hecho correctamente
select *
from credit_card cc
where cc.id = 'CcU-2938'
;
--






# Ejercicio 3
# En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:
#Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
#credit_card_id	CcU-9999
#company_id	b-9999
#user_id	9999
#lato	829.999
#longitud	-117.999
#amunt	111.11
#declined	0
--

# actualizar tabla company con los datos del nuevo usuario
insert into company (id)
values ('b-9999');

# actualizar tabla credit card con los datos del nuevo usuario
insert into credit_card (id)
values ('CcU-9999');

# actualizar tabla transaction con los datos del nuevo usuario
insert into transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
values 	('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

# verificar que el cambio se ha hecho correctamente
select *
from transaction t
where t.company_id = 'b-9999'
;
--


# Ejercicio 4
# Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el cambio realizado.

# eliminar columna
alter table credit_card
drop column pan;

# verificar que la columna se eliminado correctamnte
select *
from credit_card;
--

--
# Nivel 2
--
# Ejercicio 1
#Elimina de la tabla transacción el registro con ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de datos.

# identificar la transacción con el ID 02C6201E-D90A-1859-B4EE-88D2986D3B02
select *
from transaction t
where t.id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

# eliminar la transacción con el ID 02C6201E-D90A-1859-B4EE-88D2986D3B02
delete from transaction t
where t.id = '02C6201E-D90A-1859-B4EE-88D2986D3B02'
;

# verificar que se ha borrado el registro de la tabla transaction
select *
from transaction t
where t.id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';
--

# Ejercicio 2
# La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
# Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
# Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información:
# Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía.
# Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.

# query para crear la vista
select c.company_name, c.phone, c.country,round(avg(t.amount),2) as media_compra
from company c
join transaction t
on t.company_id = c.id
group by c.company_name, c.phone, c.country
order by media_compra DESC
;
--

# se crea una vista de la query anterior
create view `vista_marketing` as
			select c.company_name, c.phone, c.country, round(avg(t.amount),2) as media_compra
			from company c
				join transaction t
				on t.company_id = c.id
			group by c.company_name, c.phone, c.country
			order by media_compra DESC
;
--

# Ejercicio 3
# Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"

select *
from vista_marketing vm
where vm.country = 'Germany'
;
--

# Nivel 3

# Ejercicio 1
# La próxima semana tendrás una nueva reunión con los gerentes de marketing.
# Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó. 
# Te pide que le ayudes a dejar los comandos ejecutados para obtener el siguiente diagrama:


select *
from transaction;

select *
from user;


--
# Ejercicio 2
# La empresa también te solicita crear una vista llamada "InformeTecnico" que contenga la siguiente información:

#ID de la transacción
#Nombre del usuario/a
#Apellido del usuario/a
#IBAN de la tarjeta de crédito usada.
#Nombre de la compañía de la transacción realizada.
#Asegúrate de incluir información relevante de ambas tablas y utiliza alias para cambiar de nombre columnas según sea necesario.
#Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.

create view Informe_Tecnico as
			select t.id as ID_Transacción, u.name as Nombre, u.surname as Apellido, cc.iban, c.company_name as Nombre_Compañía, 
            c.website as Página_Web, t.amount as Gasto_Total
			from transaction t
					join user u
					on t.user_id = u.id
					join credit_card cc
					on t.credit_card_id = cc.id
					join company c
					on t.company_id = c.id
			order by t.id desc
;

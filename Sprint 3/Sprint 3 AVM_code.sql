# Sprint 3 Andrés Vidal Monge

-- # primero se borran las tablas y el modelo creado con el ratón previamente

alter table transaction
drop foreign key credit_company_id;
alter table transaction
drop foreign key user_id;

drop table credit_card;
drop table user;

delete from transaction t
where t.id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD'
;

delete from company c
where c.id = 'b-9999'
;
-- -- -- -- -- 
-- -- -- -- --
# Descripción
#En este sprint, se simula una situación empresarial en la que debes realizar diversas manipulaciones en las tablas de la base de datos.
#A su vez, tendrás que trabajar con índices y vistas. En esta actividad, continuarás trabajando con la base de datos que contiene información
# de una empresa dedicada a la venta de productos online.
# En esta tarea, empezarás a trabajar con información relacionada con tarjetas de crédito.
--
--
# Nivel 1
# Ejercicio 1
# Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas de crédito.
# La nueva tabla debe ser capaz de identificar de forma única cada tarjeta y establecer una relación adecuada con las otras dos tablas
#("transaction" y "company"). Después de crear la tabla será necesario que ingreses la información del documento denominado 
#"datos_introducir_credit".
# Recuerda mostrar el diagrama y realizar una breve descripción del mismo.
--

create table if not exists transactions.credit_card (
id varchar(20) not null,
iban varchar(50),
pan varchar(20),
pin varchar(4),
cvv int,
expiring_date varchar(20),
primary key (id), index (id)
)
;

# crear indices
create index `transaction_index` on `transaction`(`id`);

create index `credit_card_index` on `transaction`(`credit_card_id`);


# Añadimos foreign key en la tabla para conectarla con las tablas

alter table transaction
add constraint fk_transaction_credit_card
foreign key (credit_card_id)
references credit_card (id);




--
# Ejercicio 2
# El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario con ID CcU-2938. 
# La información que debe mostrarse para este registro es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.

# identificar al usuario con ID CcU-2938
select *
from credit_card cc
where cc.id = 'CcU-2938'
;

# actualizar numero de la cuenta del usaurio
update credit_card cc
set cc.iban = 'R323456312213576817699999' where (cc.id ='CcU-2938')
;

# comprobar el cambio
select *
from credit_card cc
where cc.id = 'CcU-2938'
;

--
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

# añadir el nuevo usuario a company
insert into company 
values ('b-9999', 'Ando_Vido','08 14 47 56 74', 'avidalmonge@protonmail.earth', 'Spain', 'avidalmonge.com')
;


# añadir el nuevo usuario a credit card
insert into credit_card
values ('CcU-9999', 'CY49087426654774581266832110', '7411', '565', '02/25/27')
;

# actualizar tabla transaction con los datos del nuevo usuario
insert into transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
values 	('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

# verificar que el cambio se ha hecho correctamente
select *
from transaction t
where t.id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD'
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
where t.declined = 0
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
                where t.declined = 0
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

# eliminar columna website de la tabla company
alter table company
drop column website;


alter table credit_card 
add column fecha_actual date after expiring_date;


alter table transaction
add constraint fk_company
foreign key (company_id)
references company (id);

--
# creamos la tabla user
CREATE INDEX idx_user_id ON transaction(user_id);
 

CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );
    
# creamos la Foreign key de user

alter table transaction
add constraint fk_user
foreign key (user_id)
references user (id);

# cambiamos nombre de la tabla user a data_user
rename table `user` to `data_user`;

# cambiamos nombre de columna email a personal_email
alter table data_user change email
personal_email varchar(150);







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
			select t.id as ID_Transacción, u.name as Nombre, u.surname as Apellido, cc.iban as 'número de cuenta IBAN', c.company_name as 'Nombre de la Compañía', 
             t.amount as Gasto_Total
			from transaction t
					join user u
					on t.user_id = u.id
					join credit_card cc
					on t.credit_card_id = cc.id
					join company c
					on t.company_id = c.id
                    where t.declined = 0
			order by t.id desc
;



--
select t.id as ID_Transacción, u.name as Nombre, u.surname as Apellido, cc.iban as 'número de cuenta IBAN', c.company_name as 'Nombre de la Compañía', 
             t.amount as Gasto_Total
			from transaction t
					join user u
					on t.user_id = u.id
					join credit_card cc
					on t.credit_card_id = cc.id
					join company c
					on t.company_id = c.id
                    where t.declined = 0
			order by t.id desc;
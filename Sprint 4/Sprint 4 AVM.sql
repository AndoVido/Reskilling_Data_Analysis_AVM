# Sprint 4 Andrés Vidal Monge

#Nivel 1
# Partiendo de algunos archivos CSV diseñarás y crearás tu base de datos.

# creamos la nueva base de datos de transactions
create database new_transactions;

# creamos la tabla companies
create table if not exists new_transactions.companies (
	company_id varchar (20) null,
    company_name varchar (200) null,
    phone varchar (15) null,
    email varchar (100) null,
    country varchar (100) null,
    website varchar (255) null    
)
;
# load csv companies
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\companies.csv'
into table new_transactions.companies 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines (company_id, company_name, phone, email, country, website)
;

-- 

# creamos la siguiente tabla credit_cards
create table if not exists new_transactions.credit_cards (
	id varchar (50) null,
    user_id varchar (100) null,
    iban varchar (150) null,
    pan varchar (40) null,
    pin varchar (4) null,
    cvv varchar (3) null,
    track1 varchar (50) null,
    track2 varchar (50) null,
    expiring_date varchar(20) null
)
;
# load csv credit_cards
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\credit_cards.csv'
into table new_transactions.credit_cards
fields terminated by ','
enclosed by '"'
ignore 1 lines (id, user_id, iban, pan, pin, cvv, track1, track2, expiring_date)
;

--

# creamos la siguiente tabla products
create table if not exists new_transactions.products (
	id varchar (255) null,
    product_name varchar (255) null,
    price varchar(255) null,
    colour varchar(255) null,
	weight varchar(255) null,
    warehouse_id varchar(255) null
)
;
# load csv products
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv'
into table new_transactions.products
fields terminated by ','
enclosed by '"'
ignore 1 lines (id, product_name, price, colour, weight, warehouse_id)
;

--

# creamos la tabla transactions
create table if not exists new_transactions.transactions (
	id varchar(255) null,
    card_id varchar(255) null,
    business_id varchar(255) null,
    timestamp varchar(255) null,
    amount varchar(255) null,
    declined varchar (255) null,
    product_ids varchar(255) null,
    user_id varchar(255) null,
    lat varchar(255) null,
    longitude varchar(255) null
)
;
# load csv transactions
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv'
into table new_transactions.transactions
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines (id, card_id, business_id, timestamp, amount, declined, product_ids, user_id, lat, longitude)
;

--

# creamos tabla users_ca
create table if not exists new_transactions.users_ca (
	id varchar(255) null,
    name varchar(255) null,
    surname varchar(255) null,
    phone varchar(255) null,
    email varchar(255) null,
    birth_date varchar(255) null,
    country varchar(255) null,
    city varchar(255) null,
    postal_code varchar(255) null,
    address varchar(255) null
)
;
# load csv users_ca
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users_ca.csv'
into table new_transactions.users_ca 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines (id, name, surname, phone, email, birth_date,country,city,postal_code,address)
;

--

# creamos tabla users_uk
create table if not exists new_transactions.users_uk (
	id varchar(255) null,
    name varchar(255) null,
    surname varchar(255) null,
    phone varchar(255) null,
    email varchar(255) null,
    birth_date varchar(255) null,
    country varchar(255) null,
    city varchar(255) null,
    postal_code varchar(255) null,
    address varchar(255) null
)
;
# load csv users_uk
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users_uk.csv'
into table new_transactions.users_uk 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines (id, name, surname, phone, email, birth_date,country,city,postal_code,address)
;

--

# creamos tabla users_usa
create table if not exists users_usa (
	id varchar(255) null,
    name varchar(255) null,
    surname varchar(255) null,
    phone varchar(255) null,
    email varchar(255) null,
    birth_date varchar(255) null,
    country varchar(255) null,
    city varchar(255) null,
    postal_code varchar(255) null,
    address varchar(255) null
)
;
# load csv users_usa
load data infile 
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users_usa.csv'
into table new_transactions.users_usa 
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines (id, name, surname, phone, email, birth_date,country,city,postal_code,address)
;

--

describe companies;

create table new_transactions.companies_backup as select * from new_transactions.companies;

create table new_transactions.credit_cards_bk as select * from new_transactions.credit_cards;

create table new_transactions.products_bk as select * from new_transactions.products;

create table new_transactions.transactions_bk as select * from new_transactions.transactions;


# modify columnas
alter table new_transactions.credit_cards
modify column cvv int
;

# descubrir los caracteres
select * from products p
where p.price not regexp '^[0-9]+(\.[0-9]+)?$'
or p.weight not regexp '^[0-9]+(\.[0-9]+)?$';

# update session
set session sql_safe_updates = 0;


# quitar el simbolo $ de price para poder cambiar a decimal el data type
update products
set price = replace(price, '$', '')
where price like '$%'
;


# cambiamos data type de price y weight en la tabla products
alter table new_transactions.products
modify column price decimal(10,2),
modify column weight decimal(10,2)
;

# cambiamos los data type de la tabla transactions
alter table new_transactions.transactions
modify column timestamp timestamp,
modify column amount decimal(10,2),
modify column declined tinyint(1),
modify column lat decimal(10,2),
modify column longitude decimal(10,2)
;

--

# unir las tablas de user a una sola tabla
create table if not exists new_transactions.users (
	id varchar(255) null,
    name varchar(255) null,
    surname varchar(255) null,
    phone varchar(255) null,
    email varchar(255) null,
    birth_date varchar(255) null,
    country varchar(255) null,
    city varchar(255) null,
    postal_code varchar(255) null,
    address varchar(255) null
)
;

# insertamos los datos a la tabla users cambiando y poniendo en comillas los valores que son distintos.
insert into users (id, name, surname, phone, email, birth_date,country,city,postal_code,address)
select id, name, surname, phone, email, birth_date, 'Canada' ,city,postal_code,address
from users_ca
;

insert into users (id, name, surname, phone, email, birth_date,country,city,postal_code,address)
select id, name, surname, phone, email, birth_date, 'United Kingdom' ,city,postal_code,address
from users_uk
;

insert into users (id, name, surname, phone, email, birth_date,country,city,postal_code,address)
select id, name, surname, phone, email, birth_date, 'United States' ,city,postal_code,address
from users_usa
;

# borramos las tablas de usuarios que ya no necesitamos y aprovecho en borrar los bk
drop table users_ca;
drop table users_uk;
drop table users_usa;
drop table companies_backup;
drop table credit_cards_bk;
drop table products_bk;
drop table transactions_bk;

--

# arreglamos la columna expiring_date para que mysql pueda leer el formato date 
update credit_cards
set expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%Y')
where STR_TO_DATE(expiring_date, '%m/%d/%Y') IS NOT NULL
;

alter table credit_cards
modify column expiring_date date
;


# creamos una nueva tabla usando los datos de la columna products_ids de la tabla transactions
create table if not exists new_transactions.products_in_transactions (
	transaction_id varchar(255) not null,
	product_id varchar(255) not null
    
)
;

# backup de tabla transactions
create table if not exists transactions_bk as select * from transactions;


# probamos que la query creada con recursive nos enseñe los productos de cada transaccion
with recursive numbers as (
    select 1 as n
    union all
    select n + 1 from numbers where n < 20
),
split_products as (
    select
        t.id as transaction_id,
        trim(substring_index(substring_index(t.product_ids, ',', n), ',', -1)) as product_id
    from
        transactions t
    join numbers on n <= 1 + length(t.product_ids) - length(replace(t.product_ids, ',', ''))
)
select * from split_products;


# insertamos los datos a la nueva tabla
insert into products_in_transactions (transaction_id, product_id)
with recursive numbers as (
    select 1 as n
    union all
    select n + 1 from numbers where n < 10
),
split_products as (
    select
        t.id as transaction_id,
        trim(substring_index(substring_index(t.product_ids, ',', n), ',', -1)) as product_id
    from
        transactions t
    join numbers on n <= 1 + length(t.product_ids) - length(replace(t.product_ids, ',', ''))
)
select * from split_products
where product_id <> '';

--

# agregamos pk en products
alter table new_transactions.products
add constraint PK_id_products primary key (id)
;




# agregamos la pk en transactions
alter table new_transactions.transactions
add constraint PK_id primary key (id)
;

# agregamos las fk en products_in_transactions
alter table products_in_transactions
add constraint fk_pt_transaction
foreign key (transaction_id)
references transactions (id)
;

alter table products_in_transactions
add constraint fk_pt_product
foreign key (product_id)
references products (id)
;


--

# agregar pk a las tablas que faltan
alter table companies
add constraint PK_companies primary key (company_id)
;
alter table credit_cards
add constraint PK_credit_card primary key (id)
;
alter table products_in_transactions
add primary key (transaction_id, product_id)
;
alter table users
add constraint PK_users primary key (id)
;

# crear claves fk en la tabla transactions
alter table transactions
add constraint fk_card_id
foreign key (card_id)
references credit_cards (id)
;

alter table transactions
add constraint fk_business_id
foreign key (business_id)
references companies (company_id)
;

alter table transactions
add constraint fk_users
foreign key (user_id)
references users (id)
;

alter table transactions
add constraint fk_product
foreign key (id)
references products_in_transactions (transaction_id)
;

--

# Descarga los archivos CSV, estudiales y diseña una base de datos con un esquema de estrella que contenga,
# al menos 4 tablas de las que puedas realizar las siguientes consultas:
# Ejercicio 1
# Realiza una subconsulta que muestre a todos los usuarios con más de 30 transacciones utilizando al menos 2 tablas.

select *
from users u
where u.id in (select t.user_id
				from transactions t
                group by t.user_id
                having count(*) > 30)
order by u.id desc
;


# Ejercicio 2
# Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.

select cc.iban, round(avg(t.amount),2) as media_amount
from credit_cards cc
	join transactions t
	on cc.id = t.card_id
	join companies c
	on c.company_id = t.business_id
where c.company_name = 'Donec Ltd'
group by cc.iban
;

# Nivel 2
# Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en si las últimas tres transacciones fueron declinadas
# y genera la siguiente consulta:
#Ejercicio 1
#¿Cuántas tarjetas están activas?

# ordenamos en una vista los datos de credit card
create view credit_Card_reorder as
select 
	t.id,
    t.card_id,
    t.timestamp,
    t.declined,
    row_number () over (partition by t.card_id order by t.timestamp desc) as id_rows_CreditCard
from transactions t
;

# creamos una tabla con la nueva vista que tiene las transactions ordenadas por fecha como base

create table if not exists estado_tarjetas (
select cr.card_id,cc.iban,
case
	when cr.declined = 1 then 'Inactiva'
    else 'Activa'
end as estado
from credit_card_reorder cr
join credit_cards cc
on cc.id = cr.card_id
group by cr.card_id, cc.iban, estado)
;

# hacemos la query para saber cuantas tarjetas quedan activas despues de los filtros previos
select count(*) as 'tarjetas Activas'
from estado_tarjetas et
where et.estado = 'Activa'
;
create table salesman
(
salesman_id varchar(5),
name varchar(10),
city varchar(10),
commission int,
primary key(salesman_id),
);

create table customer
(
customer_id varchar(5),
cust_name varchar(10),
city varchar(10),
grade int,
primary key(customer_id),
);

create table orders
(
ord_no varchar(5),
purchase_amt int,
ord_date date,
customer_id varchar(5),
salesman_id varchar(5),
primary key(ord_no),
foreign key(customer_id) references customer(customer_id),
foreign key(salesman_id) references salesman(salesman_id),
);

insert into salesman values
('s1','ravi','udupi',5),
('s2','ram','belman',4),
('s3','dev','mangaluru',3);
select * from salesman;

insert into customer values
('c5','aksha','padubidri',1),
('c1','manya','udupi',2),
('c2','prathama','udupi',3),
('c3','apeksha','belman',2),
('c4','manvi','karkala',5);
select * from customer;

insert into orders values
('o5',3900,'2023-06-30','c5','s3'),
('o1',2500,'2023-07-01','c1','s1'),
('o2',3000,'2023-06-29','c2','s1'),
('o3',500,'2023-07-10','c3','s2'),
('o4',1500,'2023-07-06','c4','s2');
select * from orders;

--1.count the customers with grades above udupi's average
select count(*) as count
from customer
where grade > (select avg(grade) from customer where city='udupi');

--2.find the name and numbers of all salesman who had more than one customer
select s.salesman_id,s.name, count(*) as no_of_cust
from salesman s, orders o
where s.salesman_id=o.salesman_id
group by s.salesman_id,s.name having count(o.customer_id)>1;

--3.list all salesman & indicate those who have & dont have customers in their cities
select s.name, 'exists' as same_city 
from salesman s 
where city in (select city from customer c)
union
select s.name, 'not exists' as same_city 
from salesman s 
where city not in (select city from customer c);

--4.create a view that finds the salesman who has customer with highest order of the day
create view highest_order as
(
select s.salesman_id, s.name, o.purchase_amt,o.ord_date
from salesman s, orders o 
where s.salesman_id=o.salesman_id
);
select * from highest_order;
select name, ord_date from highest_order
where purchase_amt=(select max(purchase_amt) from highest_order h);

--5.demonstrate the delete operation by removing salesman with id 1000, all his orders must also be deleted
delete from orders where salesman_id='s1';
delete from salesman where salesman_id='s1';

--6.retrieve salesman details along with count of orders, total purchase amt, commission earned
select s.salesman_id, s.name, count(*) as no_of_orders, sum(purchase_amt) as purchase_amt,sum(commission) as total_commission
from salesman s, orders o
where s.salesman_id=o.salesman_id
group by s.salesman_id,s.name;



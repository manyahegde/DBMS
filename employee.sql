create table employee
(
ssn varchar(5),
name varchar(10),
address varchar(20),
sex varchar(6),
salary int,
superssn varchar(5),
dno varchar(5),
primary key(ssn),
);

create table department
(
dno varchar(5),
dname varchar(10),
mgrssn varchar(5),
mgr_start_date date,
primary key(dno),
);

alter table employee add constraint fk1 foreign key(dno) references department (dno) on delete cascade;
alter table employee add constraint fk2 foreign key (superssn) references employee(ssn);
alter table department add constraint fk3 foreign key(mgrssn) references employee(ssn);

--alter table employee drop fk1

create table dlocation
(
dno varchar(5),
dloc varchar(10),
primary key(dno,dloc),
foreign key (dno) references department(dno) on delete cascade,
);

create table project
(
pno varchar(5),
pname varchar(10),
plocation varchar(10),
dno varchar(5),
primary key(pno),
foreign key (dno) references department(dno) on delete cascade,
);

create table works_on
(
ssn varchar(5),
pno varchar(5),
hours int,
primary key(ssn,pno),
foreign key(ssn) references employee(ssn),
foreign key (pno) references project(pno) on delete cascade,
);

insert into employee values
('111','manyahegde','karkala','female',150000,NULL,NULL),
('112','mary','kerala','male',80000,NULL,NULL),
('113','preethi','assam','female',95000,NULL,NULL),
('114','kavya','chennai','female',100000,NULL,NULL);
select * from employee;

insert into department values
('13','psychology','112','2020-01-30'),
('11','aiml','111','2023-04-19'),
('12','ise','113','2023-05-26');
select * from department;

update employee set superssn='112', dno='13' where ssn='111';
update employee set superssn='111', dno='11' where ssn='114';
update employee set superssn='114', dno='12' where ssn='112';
update employee set superssn='113', dno='11' where ssn='113';

insert into dlocation values
('11','NC5'),
('12','APJ'),
('13','sdm');
select * from dlocation;

insert into project values
('p1','aml','NC5','11'),
('p2','android','APJ','12'),
('p3','clinical','sdm','13'),
('p4','iot','NC5','11');
select * from project;

insert into works_on values
('114','p4',48),
('111','p1',18),
('113','p4',48),
('112','p2',15);
select * from works_on;

--1.Make a list of all project numbers for projects that involve an employee whose last name is ‘hegde’, either as a worker or as a manager of the department that controls the project.
select p.pno 
from project p, department d, employee e
where p.dno=d.dno and d.mgrssn=e.ssn and e.name like '%hegde'
union
select w.pno 
from works_on w, employee e
where w.ssn=e.ssn and e.name like '%hegde';

--2.Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.
select e.name, e.salary*1.1 as new_salary
from employee e,works_on w, project p
where e.ssn=w.ssn and w.pno=p.pno and p.pname='iot';

--3.Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department
select sum(salary) as total_salary,max(salary) as max_salary,min(salary) as min_salary, avg(salary) as avg_salary
from employee
where dno in (select dno from department where dname='aiml');

--4.Retrieve the name of each employee who works on all the projects controlled by department number 11
SELECT e.name
FROM employee e
WHERE NOT EXISTS (SELECT p.pno FROM project p WHERE p.dno = 2 AND p.pno NOT IN (SELECT w.pno FROM works_on w WHERE w.ssn = e.ssn));

--5.For each department that has more than two employees, retrieve the department number and the number of its employees who are making more THAN RS. 6,00,000.
select d.dno,count(*) as no_of_emp
from department d,employee e
where d.dno=e.dno and e.salary>60000
group by (d.dno) having count(*)>1;



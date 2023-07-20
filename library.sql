create table publisher
(
name varchar(10),
address varchar(20),
phone bigint,
primary key(name)
);

create table Book
(
book_id varchar(5),
title varchar(20),
publisher_name varchar(10),
pub_year int,
primary key(book_id),
foreign key(publisher_name) references publisher(name) on delete cascade,
);

create table book_authors
(
book_id varchar(5),
author_name varchar(10),
primary key(author_name),
foreign key(book_id) references Book on delete cascade,
);

create table library_branch
(
branch_id varchar(5),
branch_name varchar(10),
address varchar(20),
primary key(branch_id),
);

create table book_copies
(
book_id varchar(5),
branch_id varchar(5),
no_of_copies int,
primary key(book_id,branch_id),
foreign key(book_id) references Book on delete cascade,
foreign key(branch_id) references library_branch on delete cascade,
);

create table book_lending
(
book_id varchar(5),
branch_id varchar(5),
card_no int,
date_out date,
due_date date,
primary key(book_id,branch_id),
foreign key(book_id) references Book on delete cascade,
foreign key(branch_id) references library_branch on delete cascade,
);

insert into publisher values
('harry','bangalore',9845711362),
('max','france',7655930123),
('ben','tokyo',9854066312),
('manny','egypt',9535951663);
select * from publisher;

insert into Book values
('b1','me and you','ben',2003),
('b2','wonderland','ben',2005),
('b3','frostland','max',1999),
('b4','ali','harry',2011),
('b5','snowwhite','harry',2004);
select * from Book;

insert into book_authors values
('b1','george'),
('b2','mark'),
('b3','james'),
('b4','francine'),
('b5','sarojini');
select * from book_authors;

insert into library_branch values
('111','mg road','bangalore'),
('112','campus','hyderabad'),
('113','rt nagar','bangalore');
select * from library_branch;

insert into book_copies values
('b1','112',6),
('b2','111',5),
('b3','113',0),
('b4','111',6),
('b5','113',7);
select * from book_copies;

insert into book_lending values
('b1','112',10,'2023-07-10','2023-07-23'),
('b2','111',11,'2023-07-02','2023-07-18'),
('b4','111',12,'2023-07-13','2023-07-22'),
('b3','113',15,'2023-06-29','2023-07-06');
('b5','113',10,'2023-07-04','2023-07-16');
select * from book_lending;

--1.Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each branch, etc.
select b.book_id, b.title, b.publisher_name, ba.author_name, bc.branch_id, bc.no_of_copies
from book b,book_authors ba, book_copies bc
where b.book_id = bc.book_id and b.book_id= ba.book_id;

--2. Get the particulars of borrowers who have borrowed more than 1 book, but from 2 July 2023 to 13 july 2023.
select distinct card_no from book_lending
where date_out between '2023-07-02' and '2023-07-13'
group by card_no
having count(*)>1

--3.Delete a book in BOOK table. Update the contents of other tables to reflect this data manipulation operation.
delete from Book
where book_id='b1';
select * from Book;

--4.Create a view of all books and its number of copies that are currently available in the Library.
create view available as
select c.book_id, sum(c.no_of_copies)-(select count(card_no) from book_lending) as currently_avail
from book_copies c
group by c.book_id

select  * from available;

--5.Retrieve the details of publisher who published more than 1 book.
select p.name 
from publisher p,Book b
where (p.name=b.publisher_name)
group by (p.name) having count(*)>1;

--6.Retrieve the details of publisher who has not published any books.
select *
from publisher p
where not exists (select publisher_name from Book where p.name=publisher_name);

--7.Get the particulars of book with more than 3 authors.
select b.title, a.author_name
from Book b, book_authors a
where b.book_id=a.book_id 
group by b.title,a.author_name having count(*)>1;

--8.Get the particulars of Library branch which has zero copies of book with id 112.
select * from library_branch
where branch_id not in (select distinct branch_id from book_copies where book_id='112');

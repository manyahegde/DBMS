create table actor
(
act_id varchar(5),
act_name varchar(10),
act_gender varchar(6),
primary key(act_id),
);

create table director
(
dir_id varchar(5),
dir_name varchar(10),
dir_phone bigint,
primary key(dir_id),
);

create table movie
(
mov_id varchar(5),
mov_title varchar(10),
mov_year int,
mov_lang varchar(10),
dir_id varchar(5),
primary key(mov_id),
foreign key (dir_id) references director(dir_id) on delete cascade,
);

create table movie_cast
(
act_id varchar(5),
mov_id varchar(5),
role varchar(10),
primary key(act_id,mov_id),
foreign key(act_id) references actor(act_id) on delete cascade,
foreign key(mov_id) references movie(mov_id) on delete cascade,
);

create table rating
(
rat_id varchar(5),
mov_id varchar(5),
rev_stars int,
primary key(rat_id),
foreign key(mov_id) references movie(mov_id) on delete cascade,
);

insert into actor values
('a1','srk','male'),
('a2','vijay','male'),
('a3','alia','female'),
('a4','tiger','male'),
('a5','shraddha','female');
select * from actor;

insert into director values
('d1','karan',9876456788),
('d2','yash',956770897),
('d3','martin',7411006376);
select * from director;

insert into movie values
('m5','abcd2',2018,'telugu','d2'),
('m6','pathaan',2023,'hindi','d1'),
('m1','kkkg',1999,'hindi','d1'),
('m2','gangubai',2022,'hindi','d1'),
('m3','home again',2019,'english','d3'),
('m4','taxi',2018,'hindi','d2');

select * from movie;

insert into movie_cast values
('a1','m6','hero'),
('a2','m1','brother'),
('a1','m1','father'),
('a3','m2','lead'),
('a2','m3','doctor'),
('a4','m3','villain'),
('a5','m5','dancer'),
('a2','m4','hero');
select * from movie_cast;

insert into rating values
('r6','m2',5),
('r1','m1',5),
('r2','m2',4),
('r3','m3',2),
('r4','m4',4),
('r5','m5',3);
select * from rating;

--1.list the titles of all movies directed by karan
select m.mov_title
from movie m
where dir_id in (select dir_id from director where dir_name='karan');

--2.find the movie names where one or more actors acted in 1 or more movies
select m.mov_title 
from movie m, movie_cast c
where m.mov_id=c.mov_id
group by m.mov_title having count(c.act_id)>1;

--3.list all actors who acted in a movie before 2000 and also in a movie after 2015
select distinct a.act_name 
from actor a, movie_cast c, movie m
where a.act_id=c.act_id and c.mov_id=m.mov_id and m.mov_year<2000 
intersect
select distinct a.act_name 
from actor a, movie_cast c, movie m
where a.act_id=c.act_id and c.mov_id=m.mov_id and m.mov_year>2015;

--4.find the title of movies and number of stars for each movie that has atleast one rating and find the highest number of stars that movie recieved. sort the result by movie title.
select m.mov_title, sum(r.rev_stars) as total_stars, max(r.rev_stars) as max_stars
from movie m, rating r
where m.mov_id=r.mov_id
group by(m.mov_title)
order by m.mov_title;

--5.update the rating of all movies directed by karan to 5
update rating set rev_stars=5
where mov_id in (select mov_id from movie where dir_id in (select dir_id from director where dir_name='karan'));
select * from rating;

--6.find the count of movies released in each year in each language
select mov_year,mov_lang,count(mov_id) as no_of_movies
from movie 
group by mov_year,mov_lang 
order by mov_year;

--7.find the total number of movies directed by each director
select d.dir_id, count (m.mov_id) as no_of_movies
from movie m, director d
where m.dir_id=d.dir_id
group by d.dir_id;
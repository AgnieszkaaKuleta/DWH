use kinder
go

CREATE TABLE additional_lesson(
	lessonID int PRIMARY KEY,
	start_year int,
	price int,
	name varchar(35)
);

CREATE TABLE parent(
	parentID int PRIMARY KEY,
	name varchar(25),
	surname varchar(25),
	PESEL varchar(11),
	email varchar(40),
	phone varchar(9)
);

CREATE TABLE address(
	addressID int PRIMARY KEY,
	city varchar(30),
	post_code varchar(6),
	street varchar(35),
	building int,
	apartment int,
	district varchar(35)
);

CREATE TABLE groups(
	groupID int PRIMARY KEY,
	age int,
	name varchar(25),
	year_no int
);

CREATE TABLE facility(
	facilityID int PRIMARY KEY,
	names varchar(75),
	capacity int,
	opening_date date,
	closing_date date,
	FK_addressID int REFERENCES address,
);

CREATE TABLE child(
	childID int PRIMARY KEY,
	name varchar(25),
	surname varchar(25),
	birthday date,
	PESEL varchar(11),
	FK_mother int REFERENCES parent,
	FK_father int REFERENCES parent,
	FK_address int REFERENCES address,
	FK_groups int REFERENCES groups
	--medicines
);

CREATE TABLE application(
	applicationID int PRIMARY KEY,
	issue_date date,
	status bit,
	confirmation_date date,
	FK_facility int REFERENCES facility,
	FK_child int REFERENCES child
);

CREATE TABLE contract(
	contractID int PRIMARY KEY,
	issue_date date,
	ending_date date,
	signing_date date,
	FK_application int REFERENCES application
);

CREATE TABLE chooses(
	choosesID int PRIMARY KEY,
	IDapplication int REFERENCES application,
	IDLesson int REFERENCES additional_lesson
);
go
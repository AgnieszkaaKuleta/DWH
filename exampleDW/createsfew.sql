use example
go

CREATE TABLE DIM_additional_lesson (
  lessonID int PRIMARY KEY,
  start_year int,
  name varchar(35)
);


CREATE TABLE DIM_groups (
  groupID int PRIMARY KEY,
  age varchar(8),
  name varchar(25),
  year_no varchar(10),
  size varchar(6)
);


CREATE TABLE DIM_facility (
  facilityID int PRIMARY KEY IDENTITY(1,1) ,
  names varchar(75),
  city varchar(30),
  post_code varchar(6),
  street varchar(35),
  district varchar(35),
  SCDdate_start date,
  SCDcurrent varchar(3),
  SCDdate_end date
);

CREATE TABLE DIM_contract (
  contractID int PRIMARY KEY,
  active varchar(25)
);


CREATE TABLE DIM_Date (
  dateID int PRIMARY KEY,
  year int,
  month int,
  day int
);


CREATE TABLE DIM_JUNK (
  JUNKID int PRIMARY KEY IDENTITY(1,1),
  two_parents varchar(35),
  meeting_cancelled varchar(35),
  contract_durringmeeting varchar(35),
  status_of_application varchar(35)
);

CREATE TABLE FACT_NEWapplication (
  applicationID int PRIMARY KEY,
  Additionals_selected int,
  FK_facility int NOT NULL,
  FK_JUNK int NOT NULL,
  FK_contract int NOT NULL,
  FK_confirmationdate int NOT NULL,
  FK_issuedate int NOT NULL,
  FK_groups int NOT NULL,
  UNIQUE(FK_facility, FK_JUNK, FK_contract,FK_confirmationdate,FK_issuedate, FK_groups)
);

CREATE TABLE FACT_additional (
  FK_NEWapplication int NOT NULL,
  FK_additional_lesson int NOT NULL,
  PRIMARY KEY(FK_NEWapplication,FK_additional_lesson)
);

ALTER TABLE FACT_additional ADD FOREIGN KEY (FK_additional_lesson) REFERENCES DIM_additional_lesson (lessonID);

ALTER TABLE FACT_NEWapplication ADD FOREIGN KEY (FK_contract) REFERENCES DIM_contract (contractID);

ALTER TABLE FACT_NEWapplication ADD FOREIGN KEY (FK_facility) REFERENCES DIM_facility (facilityID);

ALTER TABLE FACT_NEWapplication ADD FOREIGN KEY (FK_issuedate) REFERENCES DIM_Date (dateID);

ALTER TABLE FACT_NEWapplication ADD FOREIGN KEY (FK_confirmationdate) REFERENCES DIM_Date (dateID);

ALTER TABLE FACT_additional ADD FOREIGN KEY (FK_NEWapplication) REFERENCES FACT_NEWapplication (applicationID);

ALTER TABLE FACT_NEWapplication ADD FOREIGN KEY (FK_JUNK) REFERENCES DIM_JUNK (JUNKID);

ALTER TABLE FACT_NEWapplication ADD FOREIGN KEY (FK_groups) REFERENCES DIM_groups (groupID);

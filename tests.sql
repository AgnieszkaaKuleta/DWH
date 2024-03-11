use example
go
--TEST CASE 2
use kinder
go
update [kinder].dbo.address
set street = 'test13'
where addressID=13;

update [kinder].dbo.address
set city = 'test1'
where addressID=1;

update [kinder].dbo.address
set district = 'test25'
where addressID=25;
go

SELECT COUNT(*) FROM [example].dbo.FACT_NEWapplication;
SELECT COUNT(*) FROM [kinder].dbo.application;


--TEST CASE 3
use kinder
go
update [kinder].dbo.address
set district = 'test105'
where addressID=105;

--update [kinder].dbo.address
--set city = 'test1'
--where addressID=1;

--update [kinder].dbo.address
--set district = 'test25'
--where addressID=25;
go

--TEST CASE 4
use kinder
go
update [kinder].dbo.address
set street = 'testkrzys'
where addressID=157;	

select top 100 * from [kinder].dbo.facility

INSERT INTO [kinder].dbo.application VALUES(1500010,'2020-01-01', 0, '2020-01-01', 8, 1);

SELECT TOP 100 * FROM [example].dbo.FACT_NEWapplication order by 1 desc;

SELECT TOP 100 * from [example].dbo.DIM_facility order by 1 desc;


--TEST CASE 6
use kinder
go
INSERT INTO [kinder].dbo.application VALUES(1500002,NULL, NULL, NULL, NULL, NULL);
SELECT * FROM [example].dbo.FACT_NEWapplication WHERE applicationID=1500002;
USE example
GO

If (object_id('[example].dbo.TEMPexcel') is not null) DROP TABLE [example].dbo.TEMPexcel;
CREATE TABLE [example].dbo.TEMPexcel(
applicationID int,
childID int, 
motherID int,
fatherID int,
date_meeting date,
hour time,
facilityID int
);
go

BULK INSERT [example].dbo.TEMPexcel
    FROM 'C:\Users\dedza\OneDrive\Dokumenty\Desktop\kamlek\4 SEM\DATA WARHOUSES\excel.csv'
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    TABLOCK
    ) 


If (object_id('view_junkNeed') is not null) Drop View view_junkNeed;
go
CREATE VIEW view_junkNeed
AS
SELECT DISTINCT
[kinder].dbo.application.applicationID as [id],
CASE
		WHEN ([example].dbo.TEMPexcel.fatherID IS NULL OR
			[example].dbo.TEMPexcel.motherID IS NULL  )THEN 'NOT_BOTH'
		ELSE 'BOTH'
	END as [parent],
CASE
		WHEN [example].dbo.TEMPexcel.fatherID IS NULL AND
			[example].dbo.TEMPexcel.motherID IS NULL  THEN 'CANCELLED'
		ELSE 'NOT_CANCELLED'
	END as [meeting],
CASE
		WHEN [kinder].dbo.application.issue_date =  [example].dbo.TEMPexcel.date_meeting
		THEN 'SIGNEN'
		ELSE 'NOT'
	END as [during],
CASE
		WHEN [kinder].dbo.application.status = 0	
		THEN 'REJECTED'
		ELSE 'ACCEPTED'
	END as [status]
FROM [kinder].dbo.application
LEFT JOIN [example].dbo.TEMPexcel ON [example].dbo.TEMPexcel.applicationID = [kinder].dbo.application.applicationID
go


If (object_id('view_auxilary') is not null) Drop View view_auxilary;
go
CREATE VIEW view_auxilary
AS
SELECT DISTINCT 
[example].dbo.DIM_JUNK.JUNKID as [junkID],
[example].dbo.view_junkNeed.id as [appID]
FROM [example].dbo.DIM_JUNK
LEFT JOIN [example].dbo.view_junkNeed ON 
[example].dbo.view_junkNeed.during = [example].dbo.DIM_JUNK.contract_durringmeeting AND
[example].dbo.view_junkNeed.meeting = [example].dbo.DIM_JUNK.meeting_cancelled AND
[example].dbo.view_junkNeed.parent = [example].dbo.DIM_JUNK.two_parents AND
[example].dbo.view_junkNeed.status = [example].dbo.DIM_JUNK.status_of_application
go


If (object_id('view_count') is not null) Drop View view_count;
go
CREATE VIEW view_count
AS
SELECT DISTINCT
applicationID as [id],
COUNT(*) as [counter]
FROM [kinder].dbo.application
LEFT JOIN [kinder].dbo.chooses ON [kinder].dbo.chooses.IDapplication = [kinder].dbo.application.applicationID
GROUP BY [kinder].dbo.application.applicationID
go


If (object_id('view_application') is not null) Drop View view_application;
go
CREATE VIEW view_application
AS
SELECT DISTINCT
[kinder].dbo.application.applicationID as [c1],
CASE WHEN [example].dbo.view_count.counter IS NOT NULL THEN [example].dbo.view_count.counter ELSE - 1 END as [c2],
CASE WHEN [example].dbo.DIM_facility.facilityID IS NOT NULL THEN [example].dbo.DIM_facility.facilityID ELSE -1 END as [c3],
CASE WHEN [example].dbo.view_auxilary.junkID IS NOT NULL THEN [example].dbo.view_auxilary.junkID ELSE -1 END as [c4],
CASE WHEN [kinder].dbo.contract.contractID IS NOT NULL THEN [kinder].dbo.contract.contractID ELSE -1 END as [c5],
CASE WHEN CD.dateID IS NOT NULL THEN CD.dateID ELSE -1 END as [c6],
CASE WHEN ID.dateID IS NOT NULL THEN ID.dateID ELSE -1 END as [c7],
CASE WHEN [kinder].dbo.groups.groupID IS NOT NULL THEN [kinder].dbo.groups.groupID ELSE -1 END as [c8]
FROM [kinder].dbo.application 
LEFT JOIN [kinder].dbo.contract ON [kinder].dbo.contract.FK_application = [kinder].dbo.application.applicationID
LEFT JOIN [kinder].dbo.child ON  [kinder].dbo.child.childID =  [kinder].dbo.application.FK_child
LEFT JOIN [kinder].dbo.groups ON [kinder].dbo.groups.groupID = [kinder].dbo.child.FK_groups
LEFT JOIN [example].dbo.view_count ON [example].dbo.view_count.id = [kinder].dbo.application.applicationID
LEFT JOIN [example].dbo.view_auxilary ON [example].dbo.view_auxilary.appID = kinder.dbo.application.applicationID
LEFT JOIN [kinder].dbo.facility ON [kinder].dbo.facility.facilityID = [kinder].dbo.application.FK_facility
LEFT JOIN [example].dbo.DIM_facility ON [example].dbo.DIM_facility.names = [kinder].dbo.facility.names AND [example].dbo.DIM_facility.SCDcurrent = 'YES'
LEFT JOIN [example].dbo.DIM_Date as CD ON (CD.day = DAY([kinder].dbo.application.confirmation_date) AND 
CD.month = MONTH([kinder].dbo.application.confirmation_date) AND
CD.year = YEAR([kinder].dbo.application.confirmation_date))
LEFT JOIN [example].dbo.DIM_Date as ID ON (ID.day = DAY([kinder].dbo.application.issue_date) AND 
ID.month = MONTH([kinder].dbo.application.issue_date) AND
ID.year = YEAR([kinder].dbo.application.issue_date))
go  
	
	
	MERGE INTO [example].dbo.FACT_NEWapplication as TT
		USING view_application as ST
			ON TT.applicationID = ST.c1
				WHEN Not Matched and c1 <> -1
					THEN
						INSERT
						Values (
						c1,c2,c3,c4,c5,c6,c7,c8
						)

				--WHEN Not Matched By Source
					--Then
						--DELETE
						;
		
DROP VIEW view_application;
DROP VIEW view_auxilary;
DROP VIEW view_count;
DROP VIEW view_junkNeed;
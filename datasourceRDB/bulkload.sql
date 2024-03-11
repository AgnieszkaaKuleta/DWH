use kinder
GO


/* the path must be updated, remeber FIELDTERMINATOR defines how data in dane.bulk are separated*/
BULK INSERT dbo.additional_lesson FROM 'C:\Users\dedza\PycharmProjects\faker\lessondata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.parent FROM 'C:\Users\dedza\PycharmProjects\faker\parentdata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.address FROM 'C:\Users\dedza\PycharmProjects\faker\addressdata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.groups FROM 'C:\Users\dedza\PycharmProjects\faker\groupsdata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.facility FROM 'C:\Users\dedza\PycharmProjects\faker\facilitydata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.child FROM 'C:\Users\dedza\PycharmProjects\faker\childdata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.application FROM 'C:\Users\dedza\PycharmProjects\faker\applicationdata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.contract FROM 'C:\Users\dedza\PycharmProjects\faker\contractdata.csv' WITH (FIELDTERMINATOR=',');
BULK INSERT dbo.chooses FROM 'C:\Users\dedza\PycharmProjects\faker\choosesdata.csv' WITH (FIELDTERMINATOR=',');
go
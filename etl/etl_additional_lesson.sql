--CREATE TABLE DIM_additional_lesson (
--  lessonID int PRIMARY KEY,
--  start_year date,
--  name varchar(35)
--);

USE example
GO

If (object_id('view_additional_lesson') is not null) Drop View view_additional_lesson;
go
CREATE VIEW view_additional_lesson
AS
SELECT DISTINCT
	[lessonID] as [c1],
	[start_year] as [c2],
	[name] as  [c3]
FROM kinder.dbo.additional_lesson;
go


MERGE INTO DIM_additional_lesson as TT
	USING view_additional_lesson as ST
		ON TT.lessonID = ST.c1
			WHEN Not Matched
				THEN
					INSERT
					Values (
					c1,c2,c3 
					)
			--WHEN Not Matched By Source
			--	Then
			--		DELETE
			;
Drop View view_additional_lesson;
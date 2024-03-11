use example
go
If (object_id('view_lesson') is not null) Drop View view_lesson;
go
CREATE VIEW view_lesson
AS
SELECT DISTINCT 
IDapplication as c1,
IDLesson as c2
FROM [kinder].dbo.chooses 
go



MERGE INTO [example].dbo.FACT_additional as TT
	USING view_lesson as ST
		ON TT.FK_NEWapplication = ST.c1
			WHEN Not Matched
				THEN
					INSERT
					Values (
					c1,c2
					)
			--WHEN Not Matched By Source
				--Then
					--DELETE
					;
			
DROP VIEW view_lesson;
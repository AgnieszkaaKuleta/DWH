USE example
GO

If (object_id('view_auxiliary') is not null) Drop View view_auxiliary;
go
CREATE VIEW view_auxiliary
AS
SELECT groupID, count(*) AS SIZE FROM [kinder].dbo.groups 
JOIN [kinder].dbo.child ON groupID = [kinder].dbo.child.FK_groups
GROUP BY groupID
go


If (object_id('view_groups') is not null) Drop View view_groups;
go
CREATE VIEW view_groups
AS
SELECT DISTINCT
	[kinder].dbo.groups.[groupID] as [c1],
	CASE
		WHEN [age] = 2 THEN 'TINY'
		WHEN [age] = 3 THEN 'LITTLE'
		WHEN [age] = 4 THEN 'MIDDLE'
		ELSE 'BIG'
	END as [c2],
	[name] as  [c3],
	[year_no] as [c4],
	CASE
		WHEN [SIZE] < 20 THEN 'SMALL'
		WHEN [SIZE] BETWEEN 21 AND 25 THEN 'MEDIUM'
		ELSE 'LARGE'
	END AS [c5]
FROM [kinder].dbo.groups INNER JOIN view_auxiliary ON [kinder].dbo.groups.groupID = view_auxiliary.groupID;
go


MERGE INTO DIM_groups as TT
	USING view_groups as ST
		ON TT.groupID = ST.c1
			WHEN Not Matched
				THEN
					INSERT
					Values (
					c1,c2,c3,c4,c5
					);
			--WHEN Not Matched By Source
			--	Then
			--		DELETE;
Drop View view_auxiliary;
Drop View view_groups;


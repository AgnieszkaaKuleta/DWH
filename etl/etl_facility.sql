USE example
GO

If (object_id('view_facility') is not null) Drop View view_facility;
go
CREATE VIEW view_facility
AS
SELECT DISTINCT
	names  as [c1],
	[city] as  [c2],
	[post_code] as [c3],
	[street] as [c4],
	[district] as [c5],
	CAST([opening_date] as DATE) as [c6],
	'YES' as [c7],
	 cast(null as date) as [c8],
	 [kinder].dbo.address.addressID as [c9],
	 [kinder].dbo.facility.facilityID as [c10]
FROM [kinder].dbo.facility INNER JOIN [kinder].dbo.address ON 
 [kinder].dbo.address.addressID = [kinder].dbo.facility.FK_addressID 
go 


--update [kinder].dbo.address
--set city = 'test44'
--where addressID=44;

MERGE INTO DIM_facility as TT
	USING view_facility as ST
		ON TT.names = ST.c1
			WHEN Not Matched
				THEN
					INSERT Values (
					c1,c2,c3,c4,c5,c6,c7,c8)
			WHEN MATCHED AND  TT.SCDcurrent != 'NO'
				AND (ST.c2 <> TT.city or
				ST.c3 <> TT.post_code or
				ST.c4 <> TT.street or 
				ST.c5 <> TT.district)
				THEN
				UPDATE
					SET TT.SCDcurrent = 'NO',
					TT.SCDdate_end = CAST(GETDATE() AS DATE);
go

DECLARE @today DATE = CAST(GETDATE() AS DATE);


INSERT INTO DIM_facility(
	names,
    city,
    post_code,
    street,
    district,
    SCDdate_start,
    SCDcurrent,
    SCDdate_end
	)
		SELECT 
		c1,
		c2,
		c3,
		c4,
		c5,
		@today,
		'YES',
		c8
		FROM view_facility
				EXCEPT
				SELECT 
				names,
				city,
				post_code,
				street,
				district,
				@today,
				'YES',
				SCDdate_end
					FROM DIM_facility;

		
			
DROP VIEW view_facility;





use example
go
IF ((SELECT COUNT(*) FROM DIM_JUNK) < 2) 

INSERT INTO [dbo].[DIM_JUNK] 
SELECT t, m, c, s 
FROM 
	  (
		VALUES 
			  ('BOTH')
			, ('NOT_BOTH')
		
	  ) 
	AS two_parents(t)
	, (
		VALUES 
			  ('CANCELLED')
			, ('NOT_CANCELLED')
	  ) 
	AS meeting_cancelled(m)
	, (
		VALUES 
			  ('SIGNED')
			, ('NOT')
		
	  ) 
	AS contract_durringmeeting(c)
	, (
		VALUES 
			  ('REJECTED')
			, ('ACCEPTED')
	 ) AS status_of_application(s);


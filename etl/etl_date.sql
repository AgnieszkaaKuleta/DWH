use example
go
Declare @StartDate date; 
Declare @EndDate date;

SELECT @StartDate = '2015-01-01', @EndDate = '2035-12-31';

Declare @DateInProcess date = @StartDate;
Declare @counter int = 1;

While @DateInProcess <= @EndDate
	Begin
	--Add a row into the date dimension table for this date
		Insert Into [dbo].[DIM_Date] 
		( [dateID]
		, [Year]
		, [Month]
		, [Day]
		)
		Values ( 
		  @counter -- [Date]
		  , Cast( Year(@DateInProcess) as int) -- [Year]
		  , Cast( Month(@DateInProcess) as int) -- [MonthNo]
		  , Cast( Day(@DateInProcess) as int) -- [DayOfWeek]
		);  
		-- Add a day and loop again
		Set @counter = @counter + 1;
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
go

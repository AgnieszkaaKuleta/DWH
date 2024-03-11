use example
go

--SET IDENTITY_INSERT dbo.DIM_additional_lesson ON;
--GO
INSERT INTO dbo.DIM_additional_lesson(
	lessonID,
	start_year,
	name)
Values(-1, 0, 'UNKNOWN');
--GO
--SET IDENTITY_INSERT dbo.DIM_additional_lesson OFF;

--SET IDENTITY_INSERT dbo.DIM_contract ON;
--GO
INSERT INTO dbo.DIM_contract(
	contractID,
	active)
Values(-1,'UNKNOWN');
--GO
--SET IDENTITY_INSERT dbo.DIM_contract OFF;

--SET IDENTITY_INSERT dbo.DIM_Date ON;
--GO
INSERT INTO dbo.DIM_Date(
	dateID,
  year,
  month,
  day)
Values(-1, -1, -1, -1);
--GO
--SET IDENTITY_INSERT dbo.DIM_Date OFF;



SET IDENTITY_INSERT dbo.DIM_facility ON;
GO
INSERT INTO dbo.DIM_facility(
facilityID,
  names,
  city,
  post_code,
  street,
  district,
  SCDdate_start,
  SCDcurrent,
  SCDdate_end)
Values(-1, 'UNKNOWN', 'UNKNOWN','00-000','UNKNOWN','UNKNOWN',null , 'UNK',null);
GO
SET IDENTITY_INSERT dbo.DIM_facility OFF;


--SET IDENTITY_INSERT dbo.groups ON;
--GO
INSERT INTO dbo.DIM_groups(
	groupID,
  age,
  name,
  year_no,
  size)
Values(-1, -1, 'UNKNOWN','0001-01-01','UNKNOW');
--GO
--SET IDENTITY_INSERT dbo.groups OFF;

SET IDENTITY_INSERT dbo.DIM_JUNK ON;
GO
INSERT INTO dbo.DIM_JUNK(
	JUNKID,
  two_parents,
  meeting_cancelled,
  contract_durringmeeting,
  status_of_application)
Values(-1, 'UNKNOWN','UNKNOWN', 'UNKNOWN', 'UNKNOWN');
GO
SET IDENTITY_INSERT dbo.DIM_JUNK OFF;

--SET IDENTITY_INSERT dbo.FACT_NEWapplication ON;
--GO

--INSERT INTO dbo.FACT_NEWapplication(
--	applicationID,
--  Additionals_selected,
--  FK_facility,
--  FK_JUNK,
--  FK_contract,
--  FK_confirmationdate,
--  FK_issuedate,
--  FK_groups)
--Values(-1, -1,-1,-1,-1,-1,-1,-1);
--GO
--SET IDENTITY_INSERT dbo.FACT_NEWapplication OFF;


--SET IDENTITY_INSERT dbo.FACT_additional ON;	
--GO
--INSERT INTO dbo.FACT_additional(
--	FK_NEWapplication,
--	FK_additional_lesson)
--Values(-1, -1);
--GO
--SET IDENTITY_INSERT dbo.FACT_additional OFF;

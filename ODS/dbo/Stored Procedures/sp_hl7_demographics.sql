CREATE procedure sp_hl7_demographics
@memberID varchar(20)
as

SELECT concat( [MEMBER_ID],'|'
      ,[MEMBER_FIRST_NAME],'|'
     
      ,[MEMBER_LAST_NAME],'|'
    
      ,[AGE],'|'
      ,[DATE_OF_BIRTH],'|'
      ,[GENDER]) as Statement
  FROM [dbo].[vw_UHC_ActiveMembers]
  where member_id = @memberID

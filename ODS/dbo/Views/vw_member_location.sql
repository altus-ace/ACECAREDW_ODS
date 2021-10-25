
CREATE view vw_member_location
as 
SELECT  [MEMBER_ID]
     
      ,concat([MEMBER_HOME_ADDRESS],
      ' ',[MEMBER_HOME_ADDRESS2],
      ' ',[MEMBER_HOME_CITY],
      ' ',[MEMBER_HOME_STATE],
      ' ',[MEMBER_HOME_ZIP_C]) as Address
   
  FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers]
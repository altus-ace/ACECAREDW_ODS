-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportIB_API_Provider]  
   -- @LoadDate date NOT ,
	@DataDate varchar(10) ,
	@SrcFileName varchar(100)  ,
	--@CreatedDate datetime  ,
	@CreatedBy varchar(50),
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) ,
	@FirstName varchar(50) ,
	@Specialty varchar(50) ,
	@Specialtyid varchar(10) ,
	@Schedulingname varchar(50) ,
	@Providergrouplist varchar(50) ,
	@Providertypeid varchar(50) ,
	@Billable bit ,
	@Displayname varchar(50) ,
	@Scheduleresourcetype varchar(50) ,
	@Lastname varchar(50) ,
	@Createencounterprovideridlist varchar(50) ,
	@Providerid varchar(50) ,
	@Providerusername varchar(50) ,
	@Hideinportal bit ,
	@Entitytype varchar(50) ,
	@Providertype varchar(50) ,
	@Createencounteroncheckin bit ,
	@AceProviderID varchar(50) 
          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC  [DEV_ACECAREDW].[adi].[ImportIB_API_Provider]
	 -- @LoadDate date NOT ,
	@DataDate  ,
	@SrcFileName   ,
	--@CreatedDate datetime  ,
	@CreatedBy ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy  ,
	@FirstName  ,
	@Specialty  ,
	@Specialtyid  ,
	@Schedulingname  ,
	@Providergrouplist  ,
	@Providertypeid  ,
	@Billable  ,
	@Displayname  ,
	@Scheduleresourcetype  ,
	@Lastname  ,
	@Createencounterprovideridlist  ,
	@Providerid  ,
	@Providerusername  ,
	@Hideinportal  ,
	@Entitytype  ,
	@Providertype  ,
	@Createencounteroncheckin  ,
	@AceProviderID  
	
END


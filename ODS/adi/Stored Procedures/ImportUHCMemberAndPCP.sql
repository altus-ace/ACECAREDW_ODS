
-- =============================================
-- Author:		Bing Yu
-- Create date: 11/21/2019
-- Description:	Insert UHC Member file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUHCMemberAndPCP]
    @DataDate varchar(10),
	@OriginalFileName varchar(100),
	@SrcFileName varchar(100),
	--[CreatedDate datetime2(7),
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50),
	@SubscriberId  varchar(50) ,
	@MemberFirstName  varchar(50) ,
	@MemberLastName  varchar(50) ,
	@MemberAge  varchar(10) ,
	@Gender  char (1) ,
	@ProspectiveRisk  decimal(10, 2) ,
	@CityName  varchar(100) ,
	@CMSState  varchar(10) ,
	@NPI  varchar(20) ,
	@PCPId  varchar(50) ,
	@PCPName  varchar(50) ,
	@LastPCPVisit  varchar(10) ,
	@LastSpecVisit  varchar(10) ,
	@Product  varchar(50) ,
	@Status  char(1) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_UHC].[adi].[ImportUHCMemberAndPCP]
	 @DataDate ,
	@OriginalFileName ,
	@SrcFileName ,
	--[CreatedDate datetime2(7),
	@CreatedBy ,
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy ,
	@SubscriberId  ,
	@MemberFirstName  ,
	@MemberLastName   ,
	@MemberAge   ,
	@Gender   ,
	@ProspectiveRisk  ,
	@CityName   ,
	@CMSState   ,
	@NPI  ,
	@PCPId  ,
	@PCPName   ,
	@LastPCPVisit   ,
	@LastSpecVisit   ,
	@Product   ,
	@Status  
END

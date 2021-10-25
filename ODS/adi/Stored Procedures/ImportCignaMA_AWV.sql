-- =============================================
-- Author:		Bing Yu
-- Create date: 04/08/2020
-- Description:	Insert Membership to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportCignaMA_AWV]
	@memberid [varchar](50) NULL,
	@effectivedate varchar(20) NULL,
	@medicareid [varchar](50) NULL,
	@lastname [varchar](50) NULL,
	@firstname [varchar](50) NULL,
	@middlename [varchar](50) NULL,
	@gender [varchar](50) NULL,
	@DOB varchar(20),
	@Age [varchar](50) NULL,
	@AddressLine1 [varchar](50) NULL,
	@addressline2 [varchar](50) NULL,
	@city [varchar](50) NULL,
	@state [varchar](50) NULL,
	@zip [varchar](50) NULL,
	@homephone [varchar](50) NULL,
	@lastpcpvisit [varchar](50) NULL,
	@pcpid [varchar](50) NULL,
	@PCPName [varchar](50) NULL,
	@NPID [varchar](50) NULL,
	@PCPCounty [varchar](50) NULL,
	@hpcode [varchar](50) NULL,
	@pod_name [varchar](50) NULL,
	@pod_abbrev [varchar](50) NULL,
	@region [varchar](50) NULL,
	@County [varchar](50) NULL,
	@program [varchar](50) NULL,
	@diseasestate [varchar](50) NULL,
	@dualeligibility [varchar](50) NULL,
	@Risk_Score [varchar](10) NULL,
	@PCPCopay [varchar](50) NULL,
	@groupid [varchar](50) NULL,
	@plan_name [varchar](50) NULL,
	@regioncode [varchar](50) NULL,
	@Hcode [varchar](50) NULL,
	@LanguageDesc [varchar](50) NULL,
	@SrcFileName [varchar](50) NULL,
	--[CreatedDate] [datetime] NULL,
	@DataDate varchar(10) NULL,
	@CreateBy [varchar](50),
	--@LastUpdatedDate [datetime] ,
	@LastUpdatedBy [varchar](50)
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC  [ACDW_CLMS_CIGNA_MA].[adi].[ImportCignaMA_AWV]
	@memberid ,
	@effectivedate ,
	@medicareid ,
	@lastname ,
	@firstname ,
	@middlename ,
	@gender ,
	@DOB ,
	@Age ,
	@AddressLine1 ,
	@addressline2 ,
	@city ,
	@state ,
	@zip ,
	@homephone ,
	@lastpcpvisit ,
	@pcpid ,
	@PCPName ,
	@NPID ,
	@PCPCounty ,
	@hpcode ,
	@pod_name ,
	@pod_abbrev ,
	@region ,
	@County ,
	@program ,
	@diseasestate ,
	@dualeligibility ,
	@Risk_Score ,
	@PCPCopay ,
	@groupid ,
	@plan_name ,
	@regioncode ,
	@Hcode ,
	@LanguageDesc ,
	@SrcFileName ,
	--[CreatedDate] [datetime] NULL,
	@DataDate ,
	@CreateBy,
    --@LastUpdatedDate [datetime] ,
	@LastUpdatedBy  
    
END



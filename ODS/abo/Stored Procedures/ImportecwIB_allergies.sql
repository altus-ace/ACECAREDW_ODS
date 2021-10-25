-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [abo].[ImportecwIB_allergies](
	-- Add the parameters for the stored procedure here
	@APUID varchar(5),
	@RecordID [varchar](80) ,
	@PatientID [varchar](20)  ,
	@PatientAccountNo [varchar](20)  ,
	@EncounterID [varchar](20)  ,
	@EncounterDate [varchar](50)  ,
	@ProviderNPI [varchar](50)  ,
	@ItemID [varchar](15)  ,
	@AllergiesVerified [varchar](4)  ,
	@AllergenType [varchar](60)  ,
	@AllergyDescription [varchar](60)  ,
	@AllergyReactionText [varchar](255)  ,
	@AllergyStatus [varchar](20)  ,
	@AllergyID [varchar](255)  ,
	@ModifiedDate [varchar](25)  ,
	@FileName [varchar](50)
--	[CreatedDateTime] [datetime] 
)

 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 

    -- Insert statements for procedure here
AS
BEGIN
  EXEC [DEV_ACECAREDW].[ecwIB].[ImportecwIB_allergies]
  	@APUID ,
	@RecordID ,
	@PatientID  ,
	@PatientAccountNo  ,
	@EncounterID  ,
	@EncounterDate  ,
	@ProviderNPI  ,
	@ItemID   ,
	@AllergiesVerified   ,
	@AllergenType   ,
	@AllergyDescription  ,
	@AllergyReactionText  ,
	@AllergyStatus  ,
	@AllergyID  ,
	@ModifiedDate   ,
	@FileName

END


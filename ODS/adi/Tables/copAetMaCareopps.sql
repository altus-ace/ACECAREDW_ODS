CREATE TABLE [adi].[copAetMaCareopps] (
    [copAetMaCareoppsKey]                   INT            IDENTITY (1, 1) NOT NULL,
    [loadDate]                              DATE           NOT NULL,
    [DataDate]                              DATE           NOT NULL,
    [SrcFileName]                           VARCHAR (100)  NOT NULL,
    [CreatedDate]                           DATETIME2 (7)  CONSTRAINT [DF_CopAetMaCareopps_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                             VARCHAR (50)   CONSTRAINT [DF_CopAetMaCareopps_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]                       DATETIME2 (7)  CONSTRAINT [DF_CopAetMaCareopps_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                         VARCHAR (50)   CONSTRAINT [DF_CopAetMaCareopps_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [Legacy]                                VARCHAR (50)   NULL,
    [ProviderGroupNumber]                   VARCHAR (50)   NULL,
    [ProviderGroupName]                     VARCHAR (50)   NULL,
    [SubgroupNumber]                        VARCHAR (50)   NULL,
    [SubgroupName]                          VARCHAR (50)   NULL,
    [TIN]                                   VARCHAR (50)   NULL,
    [TINName]                               VARCHAR (150)  NOT NULL,
    [PIN]                                   VARCHAR (50)   NULL,
    [ProviderName]                          VARCHAR (150)  NULL,
    [NPI]                                   VARCHAR (50)   NULL,
    [PBGInd]                                VARCHAR (50)   NULL,
    [GroupInd]                              VARCHAR (50)   NULL,
    [MemberID]                              VARCHAR (50)   NULL,
    [CVTYMemberID]                          VARCHAR (50)   NULL,
    [MemberLastName]                        VARCHAR (150)  NULL,
    [MemberFirstName]                       VARCHAR (150)  NULL,
    [MemberDOB]                             VARCHAR (50)   NULL,
    [Address1]                              VARCHAR (150)  NULL,
    [Address2]                              VARCHAR (150)  NULL,
    [City]                                  VARCHAR (50)   NULL,
    [State]                                 VARCHAR (50)   NULL,
    [ZipCode]                               VARCHAR (50)   NULL,
    [MemberPhone]                           VARCHAR (50)   NULL,
    [MemberGender]                          VARCHAR (50)   NULL,
    [BaselineIndicator]                     VARCHAR (50)   NULL,
    [MemberStatus]                          VARCHAR (50)   NULL,
    [ContractNumber]                        VARCHAR (50)   NULL,
    [Product]                               VARCHAR (50)   NULL,
    [ProviderAssignmentType]                VARCHAR (50)   NULL,
    [Readmissions-AllCause]                 VARCHAR (50)   NULL,
    [MedicationReconciliationPostDischarge] VARCHAR (50)   NULL,
    [Breast ScreeningCompliance]            VARCHAR (50)   NULL,
    [ColorectalScreeningCompliance]         VARCHAR (50)   NULL,
    [AceiArbAdherence]                      VARCHAR (50)   NULL,
    [Acei ArbPDCYTD]                        VARCHAR (50)   NULL,
    [DiabetesEyeExam]                       VARCHAR (50)   NULL,
    [DiabetesNephropathyScreening]          VARCHAR (50)   NULL,
    [DiabetesLdlControl]                    VARCHAR (50)   NULL,
    [DiabetesLdlLevel]                      VARCHAR (50)   NULL,
    [DiabetesMedicationAdherence]           VARCHAR (50)   NULL,
    [DiabetesMedicationPDCYTD]              VARCHAR (50)   NULL,
    [DiabetesControlledHbA1c]               VARCHAR (50)   NULL,
    [DiabetesHba1C Level]                   VARCHAR (50)   NULL,
    [Hba1cBillingProviderName]              VARCHAR (50)   NULL,
    [Hba1cBillingProviderPhoneNumber]       VARCHAR (50)   NULL,
    [StatinUseInDiabetics]                  VARCHAR (50)   NULL,
    [DiabetesTreatment]                     VARCHAR (50)   NULL,
    [StatinMedicationAdherence]             VARCHAR (50)   NULL,
    [StatinMedicationPDCYTD]                VARCHAR (50)   NULL,
    [HighRiskMedication]                    VARCHAR (50)   NULL,
    [OsteoporosisManagement]                VARCHAR (50)   NULL,
    [RheumatoidArthritisManagement]         VARCHAR (50)   NULL,
    [AdultBMIAssessment]                    VARCHAR (50)   NULL,
    [HCC-ChronicConditionRevalidation]      VARCHAR (50)   NULL,
    [PafSubmission]                         VARCHAR (50)   NULL,
    [OfficeVisits]                          VARCHAR (50)   NULL,
    [LastOfficeVisit]                       VARCHAR (50)   NULL,
    [OfficeVisits-Chronic1stHalf]           VARCHAR (50)   NULL,
    [Office Visits-Chronic2ndHalf]          VARCHAR (50)   NULL,
    [Last OfficeVisit-Chronic]              VARCHAR (50)   NULL,
    [ChronicDisease]                        VARCHAR (50)   NULL,
    [AnnualFluVaccine]                      VARCHAR (50)   NULL,
    [ControllingHighBloodPressure]          VARCHAR (50)   NULL,
    [BloodPressure]                         VARCHAR (50)   NULL,
    [HTNDiagnosisDate]                      VARCHAR (50)   NULL,
    [ReportAsOf]                            VARCHAR (50)   NULL,
    [MedicationAdherence90DayConversion]    NVARCHAR (100) NULL,
    [StatinTherapyCardiovascularDisease]    VARCHAR (50)   NULL,
    [CopStgLoadStatus]                      TINYINT        DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([copAetMaCareoppsKey] ASC)
);


GO
CREATE TRIGGER [adi].[TR_adiCopAetMaCareOpps_AU]
    ON adi.copAetMaCareopps
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE adi.copAetMaCareopps
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, copAetMaCareopps a
		  WHERE i.copAetMaCareOppsKey = a.copAetMaCareOppsKey
    END

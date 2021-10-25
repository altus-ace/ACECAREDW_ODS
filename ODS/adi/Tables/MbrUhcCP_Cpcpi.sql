CREATE TABLE [adi].[MbrUhcCP_Cpcpi] (
    [mbrUhcCP_CpcpiKEY]                          INT           IDENTITY (1, 1) NOT NULL,
    [GroupName]                                  VARCHAR (100) NULL,
    [Physician]                                  VARCHAR (100) NULL,
    [PhysicianAddress]                           VARCHAR (100) NULL,
    [FirstName]                                  VARCHAR (100) NULL,
    [LastName]                                   VARCHAR (100) NULL,
    [MemberID]                                   VARCHAR (50)  NULL,
    [DOB]                                        DATE          NULL,
    [Phone]                                      VARCHAR (25)  NULL,
    [MemberAddress]                              VARCHAR (100) NULL,
    [MemberState]                                VARCHAR (25)  NULL,
    [MemberZip]                                  VARCHAR (15)  NULL,
    [DateOfLastService]                          DATE          NULL,
    [IncentiveProgram]                           VARCHAR (50)  NULL,
    [CareScore]                                  VARCHAR (10)  NULL,
    [FUH_FollowUpHospMentalIllness]              VARCHAR (1)   NULL,
    [PPC_PostPartumCare]                         VARCHAR (1)   NULL,
    [PPC_TimelinessPrenatalCare]                 VARCHAR (1)   NULL,
    [AAP_AdultAccessPreventiveHS]                VARCHAR (1)   NULL,
    [ADD_FollowUpCareChild_ADHD_ContMaintPhase]  VARCHAR (1)   NULL,
    [ADD_FollowUpCareChild_ADHD_InitiationPhase] VARCHAR (1)   NULL,
    [AWC_AdolescentWellCareVisits]               VARCHAR (1)   NULL,
    [BCS_BreastCancerScreening]                  VARCHAR (1)   NULL,
    [CBP_ControllingHighBloodPressure]           VARCHAR (1)   NULL,
    [CCS_CervicalCancerScreening]                VARCHAR (1)   NULL,
    [CDC_CompDiabetesCareBP]                     VARCHAR (1)   NULL,
    [CDC_CompDiabetesCareEyeE]                   VARCHAR (1)   NULL,
    [CDC_CompDiabetesCareHbA1cTesting]           VARCHAR (1)   NULL,
    [CDC_CompDiabetesCareHbA1cControl]           VARCHAR (1)   NULL,
    [CDC_CompDiabetesCareHbA1cPoorControl]       VARCHAR (1)   NULL,
    [CDC_CompDiabetesCareMedicalNephropathy]     VARCHAR (1)   NULL,
    [CIS_ChildImmunizationStatusComb10]          VARCHAR (1)   NULL,
    [SSD_DiabetesScreeningSchizophreniaBipolar]  VARCHAR (1)   NULL,
    [URI_ChildUpperRespInf]                      VARCHAR (1)   NULL,
    [W15_WellChildVisitsFirst_15_Months]         VARCHAR (1)   NULL,
    [W34_WellChildVisits_3_6_Years]              VARCHAR (1)   NULL,
    [WCC_WeightCounselingChildBMIPercentile]     VARCHAR (1)   NULL,
    [WCC_WeightCounselingChildNutrition]         VARCHAR (1)   NULL,
    [WCC_WeightCounselingChildPhysicalActivity]  VARCHAR (1)   NULL,
    [HealthPlanName]                             VARCHAR (20)  NULL,
    [Product]                                    VARCHAR (50)  NULL,
    [loadDate]                                   DATE          NOT NULL,
    [DataDate]                                   DATE          NOT NULL,
    [SrcFileName]                                VARCHAR (100) NOT NULL,
    [CreatedDate]                                DATETIME2 (7) CONSTRAINT [DF_adiMbrUhcCpPcpi_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                                  VARCHAR (50)  CONSTRAINT [DF_adiMbrUhcCpPcpi_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]                            DATETIME2 (7) CONSTRAINT [DF_adiMbrUhcCpPcpi_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                              VARCHAR (50)  CONSTRAINT [DF_adiMbrUhcCpPcpi_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrUhcCP_CpcpiKEY] ASC)
);


GO

CREATE TRIGGER [adi].[TR_adiMbrCp_Cpcpi_AU]
    ON [adi].MbrUhcCP_Cpcpi
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE adi.MbrUhcCP_Cpcpi
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, MbrUhcCP_Cpcpi a
		  WHERE i.mbrUhcCP_CpcpiKEY = a.mbrUhcCP_CpcpiKEY
    END

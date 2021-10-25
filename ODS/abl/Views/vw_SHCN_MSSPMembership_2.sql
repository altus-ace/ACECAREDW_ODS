CREATE VIEW [abl].[vw_SHCN_MSSPMembership_2]
AS 

SELECT DISTINCT adwFacMbr.Ace_ID As AceID,
                adiStewardMSSPMbr.LastNM As LAST_NAME, 
				adiStewardMSSPMbr.FirstNM As FIRST_NAME, 
				''                        As MIDDLE_NAME,
                CASE WHEN adiStewardMSSPMbr.SexCD = '1'
				THEN 'M' 
				    WHEN adiStewardMSSPMbr.SexCD = '2'
				THEN 'F'
				ELSE ''
				END As GENDER, 
				adiStewardMSSPMbr.BirthDTS As DATE_OF_BIRTH,
			--	adiStewardMSSPMbr.DeathDTS, 
			    '' As SSN,
				'' AS MEMBER_HOME_ADDRESS,
				'' AS MEMBER_HOME_ADDRESS2,
				'' AS MEMBER_HOME_CITY,
				CASE WHEN adiStewardMSSPMbr.HomeStateCD = 'Texas'
				   THEN 'TX' 
                END
                As MEMBER_HOME_STATE,
				''  AS MEMBER_HOME_ZIP,
                '' AS Member_Home_Phone,
				 CONVERT(VARCHAR(8), DATEADD(DAY, -45, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1)),112) MinEligDate,
	             CONVERT(VARCHAR(8), DATEADD(MONTH, 6, DATEADD(Day, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1))),112) MinExpDate,
				 adiStewardMSSPMbr.MedicareBeneficiaryID     AS ClientMemberKey,
				 adwFacMbr.ClientKey As ClientKey	

				
FROM            [ACDW_CLMS_SHCN_MSSP].adi.Steward_MSSPAnnualmembership_HALRBASE adiStewardMSSPMbr INNER JOIN
                         [ACDW_CLMS_SHCN_MSSP].[adw].[FctMembership] adwFacMbr
						 ON adiStewardMSSPMbr.MedicareBeneficiaryID = adwFacMbr.ClientMemberKey
WHERE        (adiStewardMSSPMbr.HomeStateCD = 'Texas') AND (adiStewardMSSPMbr.DeathDTS IS NULL)

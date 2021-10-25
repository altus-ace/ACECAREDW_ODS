





/****** view for exporting to clinical system the Membership information ******/

CREATE VIEW [dbo].[vw_AH_WC_Membership]
AS

/* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout 
	   */

     SELECT DISTINCT 
            mbr.ClientMemberKey AS Member_id,

            /* GK: changed to use new cs_export_lobName field */

            --CASE WHEN lc.clientKey=2 THEN 'WellCare' ELSE lc.ClientName END AS [CLIENT_ID],
            lc.CS_Export_LobName AS [CLIENT_ID], 
            MbrDemo.MedicaidID AS MEDICAID_ID, 
            MbrDemo.FirstName AS [MEMBER_FIRST_NAME], 
            MbrDemo.MiddleName AS [MEMBER_MI], 
            MbrDemo.LastName AS [MEMBER_LAST_NAME], 
            MbrDemo.DOB AS [DATE_OF_BIRTH], 
            MbrDemo.Gender AS [MEMBER_GENDER], 
            Mbradd1.Address1 + ' ' + Mbradd1.Address2 AS [HOME_ADDRESS], 
            Mbradd1.City AS [HOME_CITY], 
            Mbradd1.State AS [HOME_STATE], 
            Mbradd1.Zip AS [HOME_ZIPCODE],
            CASE
                WHEN PREADD.MEMBER_ADDRESS IS NULL
                THEN(mbrAdd2.Address1 + ' ' + mbrAdd2.Address2)
                ELSE REPLACE(RTRIM(PREADD.MEMBER_ADDRESS), ',', ' ')
            END AS [MAILING_ADDRESS],
            CASE
                WHEN PREADD.MEMBER_CITY IS NULL
                THEN mbrAdd2.City
                ELSE PREADD.MEMBER_CITY
            END AS [MAILING_CITY],
            CASE
                WHEN PREADD.MEMBER_STATE IS NULL
                THEN mbrAdd2.State
                ELSE PREADD.MEMBER_STATE
            END AS [MAILING_STATE],
            CASE
                WHEN PREADD.MEMEBR_ZIP IS NULL
                THEN mbrAdd2.Zip
                ELSE PREADD.MEMEBR_ZIP
            END AS [MAILING_ZIP], 
            mbrPhone1.PhoneNumber AS [HOME_PHONE], 
            mbrPhone3.PhoneNumber AS [ADDITIONAL_PHONE], 
            mbrPhone2.PhoneNumber AS [CELL_PHONE], 
            '' AS [LANGUAGE], 
            '' AS [Ethnicity], 
            '' AS [Email], 
            '' AS [Race], 
            '000000000' AS [MEDICARE_ID], 
            '00/00/0000' AS [MEMBER_ORG_EFF_DATE], 
            '00/00/0000' AS [MEMBER_CONT_EFF_DATE], 
            '00/00/0000' AS [MEMBER_CUR_EFF_DATE], 
            '00/00/0000' AS [MEMBER_CUR_TERM_DATE], 
            '' AS [RESP_FIRST_NAME], 
            '' AS [RESP_LAST_NAME], 
            '' AS [RESP_RELATIONSHIP], 
            '' AS [RESP_ADDRESS], 
            '' AS [RESP_ADDRESS2], 
            '' AS [RESP_CITY], 
            '' AS [RESP_STATE], 
            '00000' AS [RESP_ZIP], 
            '000-000-0000' AS [RESP_PHONE], 
            '' AS [PRIMARY_RISK_FACTOR], 
            '' AS [COUNT_OPEN_CARE_OPPS], 
            '' AS [INP_ADMITS_LAST_12_MOS], 
            '' AS [LAST_INP_DISCHARGE], 
            '' AS [POST_DISCHARGE_FUP_VISIT], 
            '' AS [INP_FUP_WITHIN_7_DAYS], 
            '' AS [ER_VISITS_LAST_12_MOS], 
            '' AS [LAST_ER_VISIT], 
            '' AS [POST_ER_FUP_VISIT], 
            '' AS [ER_FUP_WITHIN_7_DAYS], 
            '' AS [LAST_PCP_VISIT], 
            '' AS [LAST_PCP_PRACTICE_SEEN], 
            '' AS [LAST_BH_VISIT], 
            '' AS [LAST_BH_PRACTICE_SEEN], 
            '' AS [TOTAL_COSTS_LAST_12_MOS], 
            '' AS [INP_COSTS_LAST_12_MOS], 
            '' AS [ER_COSTS_LAST_12_MOS], 
            '' AS [OUTP_COSTS_LAST_12_MOS], 
            '' AS [PHARMACY_COSTS_LAST_12_MOS], 
            '' AS [PRIMARY_CARE_COSTS_LAST_12_MOS], 
            '' AS [BEHAVIORAL_COSTS_LAST_12_MOS], 
            '' AS [OTHER_OFFICE_COSTS_LAST_12_MOS], 
            '' AS [NEXT_PREVENTATIVE_VISIT_DUE]
		  , Mbr.MstrMrnKey AS ACE_ID
		  , MbrDemo.CarrierMemberID Carrier_member_id
		  , MbrDemo.mbrDemographicKey 
		  , MbrDemo.mbrDemographicKey as FctMembershipKey
     FROM [adw].mbrMember mbr
          INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
          --                                                 AND lc.ClientKey = 3
		--, ROW_NUMBER() OVER (PARTITION BY ORDER BY ) AS aRowNumber	
          INNER JOIN (SELECT md.mbrDemographicKey, md.mbrMemberKey, md.EffectiveDate, md.ExpirationDate, 
				    md.LastName, md.FirstName, md.MiddleName, md.SSN, md.Gender, md.DOB, 
				    md.MedicaidID, md.HICN, md.MBI, md.MedicareID, md.Ethnicity, md.Race, md.mbrInsuranceCardIdNum CarrierMemberID,
				    md.PrimaryLanguage, md.LoadDate, md.DataDate, md.CreatedDate
				    , ROW_NUMBER() OVER (PARTITION BY md.MbrMemberKey ORDER BY md.EffectiveDate desc) AS aRowNumber
				    FROM [adw].[MbrDemographic] md
				    WHERE md.EffectiveDate < md.ExpirationDate) AS MbrDemo 
			 ON MbrDemo.MbrMemberKey = mbr.MbrMemberKey and MbrDemo.aRowNumber = 1                
          LEFT JOIN (SELECT ad1.mbrAddressKey, ad1.MbrMemberKey, ad1.EffectiveDate, ad1.ExpirationDate, 
				    ad1.AddressTypeKey, ad1.Address1, ad1.Address2, ad1.CITY, ad1.[STATE], ad1.ZIP, ad1.COUNTY, 
				    ad1.LoadDate, ad1.DataDate
				    , ROW_NUMBER() OVER (PARTITION BY ad1.MbrMemberKey ORDER BY ad1.EffectiveDate desc) AS aRowNumber	
				FROM [adw].[mbraddress] ad1
				WHERE ad1.AddressTypeKey = 1
				    AND ad1.EffectiveDate < ad1.ExpirationDate) AS mbrAdd1 
				ON mbrAdd1.MbrMemberKey = mbr.MbrMemberKey
				    AND mbrAdd1.aRowNumber = 1                                              
          LEFT JOIN lst.[lstAddressType] lad1 ON lad1.[lstAddressTypeKey] = mbrAdd1.[AddressTypeKey]
                                                 AND lad1.lstAddressTypeKey = 1
          LEFT JOIN (SELECT ad2.mbrAddressKey, ad2.MbrMemberKey, ad2.EffectiveDate, ad2.ExpirationDate, 
				    ad2.AddressTypeKey, ad2.Address1, ad2.Address2, ad2.CITY, ad2.[STATE], ad2.ZIP, ad2.COUNTY, 
				    ad2.LoadDate, ad2.DataDate
				    , ROW_NUMBER() OVER (PARTITION BY ad2.MbrMemberKey ORDER BY ad2.EffectiveDate desc) AS aRowNumber	
				FROM [adw].[mbraddress] ad2
				WHERE ad2.AddressTypeKey = 2
				    AND ad2.EffectiveDate < ad2.ExpirationDate) AS mbrAdd2 
				ON mbrAdd2.MbrMemberKey = mbr.MbrMemberKey AND mbrAdd2.aRowNumber = 1
          LEFT JOIN lst.[lstAddressType] lad2 ON lad2.[lstAddressTypeKey] = mbrAdd2.[AddressTypeKey]
                                                 AND lad2.lstAddressTypeKey = 2
          LEFT JOIN (SELECT mp1.mbrPhoneKey, mp1.mbrMemberKey, mp1.EffectiveDate, mp1.ExpirationDate, 
				    mp1.PhoneType, mp1.PhoneNumber
				    , ROW_NUMBER() OVER (PARTITION BY mp1.MbrMemberKey ORDER BY mp1.EffectiveDate desc) AS aRowNumber	
				    FROM [adw].[MbrPhone] mp1
				    WHERE mp1.PhoneType = 1
					   AND mp1.EffectiveDate < mp1.ExpirationDate) AS MbrPhone1
		  ON MbrPhone1.MbrMemberKey = mbr.MbrMemberKey
			 AND mbrPhone1.aRowNumber = 1
          LEFT JOIN lst.lstPhoneType lpt ON lpt.lstPhonetypeKey = mbrPhone1.phoneType
                                            AND lpt.lstPhoneTYpekey = 1
          LEFT JOIN (SELECT mp2.mbrPhoneKey, mp2.mbrMemberKey, mp2.EffectiveDate, mp2.ExpirationDate, 
				    mp2.PhoneType, mp2.PhoneNumber
				    , ROW_NUMBER() OVER (PARTITION BY mp2.MbrMemberKey ORDER BY mp2.EffectiveDate desc) AS aRowNumber	
				    FROM [adw].[MbrPhone] mp2
				    WHERE mp2.PhoneType = 2
					   AND mp2.EffectiveDate < mp2.ExpirationDate) AS mbrPhone2
		  ON mbrPhone2.MbrMemberKey = mbr.MbrMemberKey
			 AND mbrPhone2.aRowNumber = 1
          LEFT JOIN lst.lstPhoneType lpt2 ON lpt2.lstPhonetypeKey = mbrPhone2.phoneType
                                             AND lpt2.lstPhoneTYpekey = 2
          LEFT JOIN (SELECT mp3.mbrPhoneKey, mp3.mbrMemberKey, mp3.EffectiveDate, mp3.ExpirationDate, 
				    mp3.PhoneType, mp3.PhoneNumber
				    , ROW_NUMBER() OVER (PARTITION BY mp3.MbrMemberKey ORDER BY mp3.EffectiveDate desc) AS aRowNumber	
				    FROM [adw].[MbrPhone] mp3
				    WHERE mp3.PhoneType = 5
					   AND mp3.EffectiveDate < mp3.ExpirationDate) AS mbrPhone3 
			 ON mbrPhone3.MbrMemberKey = mbr.MbrMemberKey
				AND mbrPhone3.aRowNumber = 1                            
          LEFT JOIN lst.lstPhoneType lpt3 ON lpt3.lstPhonetypeKey = mbrPhone3.phoneType
                                             AND lpt3.lstPhoneTYpekey = 5
          --INNER JOIN [adw].mbrcsPlanhistory mpl ON mpl.MbrMemberKey = mbr.MbrMemberKey
          --				  AND GETDATE() BETWEEN mpl.EffectiveDate AND mpl.ExpirationDate
          /* There is no required fields from this table. removed 		
		INNER JOIN (SELECT pcp.mbrPcpKey, pcp.mbrMemberKey, pcp.EffectiveDate, pcp.ExpirationDate, 
				    pcp.NPI, pcp.TIN, pcp.ClientEffective, pcp.ClientExpiration, pcp.AutoAssigned        
				    , ROW_NUMBER() OVER (PARTITION BY pcp.MbrMemberKey ORDER BY pcp.EffectiveDate desc) AS aRowNumber	
				    FROM adw.MbrPcp pcp
				     WHERE pcp.EffectiveDate < pcp.ExpirationDate) AS mbrPcp
		  ON mbr.mbrMemberKey = mbrPcp.mbrMemberKey
			 AND mbrPcp.aRowNumber = 1			
			 */
          LEFT JOIN ( SELECT PD.CLIENT_PATIENT_ID AS MEMBER_ID, 
				    --PDD.ADDRESS_TEXT AS MEMBER_ADDRESS,  fixing dirty addresses from AHS
				    [adi].[udf_GetCleanString]( PDD.ADDRESS_TEXT) AS MEMBER_ADDRESS, 		
				    PDD.CITY AS MEMBER_CITY, 
				    PDD.STATE AS MEMBER_STATE, 
				    PDD.ZIP AS MEMEBR_ZIP, 
				    PDD.CREATED_ON, 
				    PDD.UPDATED_ON
				    FROM ahs_altus_prod.dbo.PATIENT_DETAILS AS PD
					   INNER JOIN ahs_altus_prod.dbo.[PATIENT_PREFERRED_ADDRESS] AS PDD ON PDD.PATIENT_ID = PD.PATIENT_ID
					   AND pdd.Deleted_on IS NULL
				) AS PREADD ON PREADD.MEMBER_ID = mbr.ClientMemberKey
		  /* get Uhc Member Summary data */
		  /*
		  LEFT JOIN (SELECT UhcMemSmry.UHC_SUBSCRIBER_ID AS ClientMemberKey, UhcMemSmry.IPRO_ADMIT_RISK_SCORE,
					   dbo.sv_CalcRiskCategory(CONVERT(NUMERIC(10, 4), UhcMemSmry.IPRO_ADMIT_RISK_SCORE)) AS RISK_CATEGORY_C ,
					   --LINE_OF_BUSINESS, PLAN_CODE,PLAN_DESC,
					   UhcMemSmry.PRIMARY_RISK_FACTOR, UhcMemSmry.TOTAL_COSTS_LAST_12_MOS, UhcMemSmry.COUNT_OPEN_CARE_OPPS, UhcMemSmry.INP_COSTS_LAST_12_MOS,
					   UhcMemSmry.ER_COSTS_LAST_12_MOS, UhcMemSmry.OUTP_COSTS_LAST_12_MOS, UhcMemSmry.PHARMACY_COSTS_LAST_12_MOS,
					   UhcMemSmry.PRIMARY_CARE_COSTS_LAST_12_MOS, UhcMemSmry.BEHAVIORAL_COSTS_LAST_12_MOS, UhcMemSmry.OTHER_OFFICE_COSTS_LAST_12_MOS,
					   UhcMemSmry.INP_ADMITS_LAST_12_MOS, UhcMemSmry.LAST_INP_DISCHARGE, UhcMemSmry.POST_DISCHARGE_FUP_VISIT,
					   UhcMemSmry.INP_FUP_WITHIN_7_DAYS, UhcMemSmry.ER_VISITS_LAST_12_MOS, UhcMemSmry.LAST_ER_VISIT,
					   UhcMemSmry.POST_ER_FUP_VISIT, UhcMemSmry.ER_FUP_WITHIN_7_DAYS, UhcMemSmry.LAST_PCP_VISIT, UhcMemSmry.LAST_PCP_PRACTICE_SEEN,
					   UhcMemSmry.LAST_BH_VISIT, UhcMemSmry.LAST_BH_PRACTICE_SEEN, UhcMemSmry.MEMBER_MONTH_COUNT, UhcMemSmry.URN AS ACE_UHC_Membership_URN
				    FROM dbo.UHC_Membership AS UhcMemSmry
					   JOIN (SELECT MAX(mshp.A_LAST_UPDATE_DATE) as A_LAST_UPDATE_DATE
							 FROM dbo.UHC_Membership mshp
							 GROUP BY mshp.A_LAST_UPDATE_DATE
							 ) LoadDate
							 ON UhcMemSmry.A_LAST_UPDATE_DATE = LoadDate.A_LAST_UPDATE_DATE
					   ) MbrSmry ON mbr.ClientMemberKey = MbrSmry.ClientMemberKey 
						  AND mbr.ClientKey = 1
		  */
     --WHERE Mbr.ClientKey <> 1
	;

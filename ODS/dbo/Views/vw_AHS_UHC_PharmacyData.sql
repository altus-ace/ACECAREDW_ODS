

CREATE VIEW [dbo].[vw_AHS_UHC_PharmacyData]
AS
(    SELECT    SUBSCRIBER_ID , 
               LOB, 
			   Ace_ID, claim_number, 
               FILL_DATE, 
			   PRESCRIBE_DATE, 
			   refill_authorized, 
			   Refill_Number, 
               Days_Supply, 
			   Quantity_Supply, 
			   Rx_Number, Drug_Form, 
               Drug_Strength, STC_Code, Physician_ID, Physician_Name, 
               Physician_Address, NDC_Codes, Pharmacy_NPI, Pharmacy_ID, 
               Pharmacy_Name, Pharmacy_Address, Pharmacy_City, Pharmacy_State, 
               Pharmacy_Zip, Claim_Status, Total_Charge, Amount_Paid, 
               Balance_Due, ClientKey  --, s.aRn
FROM(    SELECT  --distinct 
	   ActiveMembers.Member_id AS SUBSCRIBER_ID, -- join this with active members during the file export, for first load send data for all mbrs available in Altruista 
	   'UHC' AS LOB, 
	   ActiveMembers.Ace_ID, 
	   adiData.PRESCRIPTION_NUMBER claim_number, 
	   adiData.FILL_DATE, 
	   adiData.PRESCRIBE_DATE, 
	   '' refill_authorized, 
	   '' Refill_Number, 
	   CAST(adiData.Days_Supply AS INT) Days_Supply, 
	   '' Quantity_Supply, 
	   adiData.prescription_number Rx_Number, 
	   '' Drug_Form, 
	   '' Drug_Strength, 
	   '' STC_Code, 
	   '1111111111' Physician_ID
	   ,  --NPI ---required column or dummy value 
	   adiData.Prescribing_provider Physician_Name, 
	   adiData.PRESCRIBING_PROVIDER_PRACTICE Physician_Address, 
	   adiData.NDC_CODE NDC_Codes, 
	   '1111111111' Pharmacy_NPI, --required column or dummy value: where null put dummy value 
	   '' Pharmacy_ID, 
	   adidata.Fill_Pharmacy Pharmacy_Name, 
	   '' Pharmacy_Address, 
	   '' Pharmacy_City, 
	   '' Pharmacy_State, 
	   '' Pharmacy_Zip, 
	   'Paid' Claim_Status, 
	   '' Total_Charge, 
	   '' Amount_Paid, 
	   '' Balance_Due, 
	   1 AS ClientKey
	   --, 
	   --ROW_NUMBER() OVER(PARTITION BY ActiveMembers.Member_ID, adiData.NDC_CODE, adiData.PRESCRIBE_DATE,   adiData.prescription_number
				--	   ORDER BY adiData.LoadDate DESC) AS aRn
    FROM [adi].[UhcPharmacy] adiData
         JOIN vw_ActiveMembers ActiveMembers ON ActiveMembers.member_id = adiData.UHC_SUBSCRIBER_ID
                                                AND ActiveMembers.clientKey = 1
    /*  Removed per NC: on 10/20/2020 will calculate when we load to adw
	   join acdw_clms_uhc.[adw].[Claims_Headers] c on c.subscriber_id =a.uhc_subscriber_id
	          and c.PRIMARY_SVC_DATE=a.PRESCRIBE_DATE	   	 */
    WHERE ISNULL(adiData.NDC_CODE, '') <> ''
          AND adiData.PRESCRIBE_DATE > '12/31/2019'
          AND adiData.LoadToAhsStatus = 0
    ) s
    
)

 




CREATE VIEW [adw].[vw_Exp_AhsPharmacy]
AS 
	SELECT UHC_SUBSCRIBER_ID, 
		 LOB, 
		 Ace_ID, 
		 claim_number, 
		 FILL_DATE, 
		 PRESCRIBE_DATE, 
		 refill_authorized, 
		 Refill_Number, 
		 Days_Supply, 
		 Quantity_Supply, 
		 Rx_Number, 
		 Drug_Form, 
		 Drug_Strength, 
		 STC_Code, 
		 Physician_ID, 
		 Physician_Name, 
		 Physician_Address, 
		 NDC_Codes, 
		 Pharmacy_NPI, 
		 Pharmacy_ID, 
		 Pharmacy_Name, 
		 Pharmacy_Address, 
		 Pharmacy_City, 
		 Pharmacy_State, 
		 Pharmacy_Zip, 
		 Claim_Status, 
		 Total_Charge, 
		 Amount_Paid, 
		 Balance_Due, 
		 ClientKey  -- DO not export use as a filter for export
    FROM [dbo].[vw_AH_PE_UHC_PharmacyData]





CREATE VIEW [abo].[vw_Exp_AhsPharmacyData]
AS 
	SELECT UhcRx.UHC_SUBSCRIBER_ID Member_ID, 
		 UhcRx.LOB, 
		 UhcRx.Ace_ID, 
		 UhcRx.claim_number, 
		 UhcRx.FILL_DATE, 
		 UhcRx.PRESCRIBE_DATE, 
		 UhcRx.refill_authorized, 
		 UhcRx.Refill_Number, 
		 UhcRx.Days_Supply, 
		 UhcRx.Quantity_Supply, 
		 UhcRx.Rx_Number, 
		 UhcRx.Drug_Form, 
		 UhcRx.Drug_Strength, 
		 UhcRx.STC_Code, 
		 UhcRx.Physician_ID, 
		 UhcRx.Physician_Name, 
		 UhcRx.Physician_Address, 
		 UhcRx.NDC_Codes, 
		 UhcRx.Pharmacy_NPI, 
		 UhcRx.Pharmacy_ID, 
		 UhcRx.Pharmacy_Name, 
		 UhcRx.Pharmacy_Address, 
		 UhcRx.Pharmacy_City, 
		 UhcRx.Pharmacy_State, 
		 UhcRx.Pharmacy_Zip, 
		 UhcRx.Claim_Status, 
		 UhcRx.Total_Charge, 
		 UhcRx.Amount_Paid, 
		 UhcRx.Balance_Due, 
		 UhcRx.ClientKey  -- DO not export use as a filter for export
    FROM [dbo].[vw_AH_PE_UHC_PharmacyData] UhcRx;






CREATE VIEW [dbo].[zz_vw_AH_PE_UHC_PharmacyData]
AS
(
    SELECT  
    --distinct 
    UHC_SUBSCRIBER_ID
       , -- join this with active members during the file export, for first load send data for all mbrs available in Altruista 
       'UHC' AS LOB, 
       b.Ace_ID, 
       c.CLAIM_NUMBER claim_number, 
       FILL_DATE, 
       PRESCRIBE_DATE, 
       '' refill_authorized, 
       '' Refill_Number, 
       CAST(Days_Supply AS INT) Days_Supply, 
       '' Quantity_Supply, 
       prescription_number Rx_Number, 
       '' Drug_Form, 
       '' Drug_Strength, 
       '' STC_Code, 
       C.SVC_PROV_NPI Physician_ID  --NPI
       ,   ---required column or dummy value 
       Prescribing_provider Physician_Name, 
       PRESCRIBING_PROVIDER_PRACTICE Physician_Address, 
       NDC_CODE NDC_Codes,      
       '1111111111' Pharmacy_NPI,  --required column or dummy value: where null put dummy value 
       '' Pharmacy_ID, 
       Fill_Pharmacy Pharmacy_Name, 
       '' Pharmacy_Address, 
       '' Pharmacy_City, 
       '' Pharmacy_State, 
       '' Pharmacy_Zip, 
       'Paid' Claim_Status, 
       '' Total_Charge, 
       '' Amount_Paid, 
       '' Balance_Due
       --row_number () over(partition by a.uhc_subscriber_id order by c.claim_number desc) as urn
FROM [adi].[UhcPharmacy] a 
     JOIN vw_ActiveMembers b ON b.member_id = a.uhc_subscriber_id
                                AND b.clientKey = 1
     join acdw_clms_uhc.[adw].[Claims_Headers] c on c.subscriber_id =a.uhc_subscriber_id
           and c.PRIMARY_SVC_DATE=a.PRESCRIBE_DATE
 where a.NDC_CODE IS NOT NULL
)

 



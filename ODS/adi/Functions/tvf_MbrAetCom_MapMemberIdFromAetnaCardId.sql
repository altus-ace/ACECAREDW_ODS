CREATE FUNCTION adi.tvf_MbrAetCom_MapMemberIdFromAetnaCardId (
    @LoadDate DATE
    )   /*  Member_ID Lookup From Aetna_Card_Id
		  1. Get the Member_Id and AetNa_Card_ID For next prior member load
		  2. use Aetna_card_id as source
		  3. Use Member_id as Targetprocess data warehouse, src: Load Source     
		  */
    RETURNS TABLE 
AS 
    RETURN
  --  DECLARE @LoadDate Date = '10/15/2019'    
    SELECT AdiMbrs.mbrAetComMbr, CONVERT(VARCHAR(50),(CONVERT(BIGINT, AdiMbrs.MEMBER_ID))) AS Member_ID, AdiMbrs.Aetna_Card_ID, 'tvf_MbrAetCom_MapMemberIdFromAetnaCardId' AS MappingRuleName
    FROM adi.tvf_MbrAetCom_GetCurrentMembers((SELECT MAX(adiMbrs.LOADDATE) FROM adi.MbrAetCom adiMbrs WHERE adiMbrs.LoadDate <= @LoadDate))  AS CurrentMembers
	   JOIN adi.MbrAetCom AdiMbrs 
		  ON CurrentMembers.adiKey = AdiMbrs.mbrAetComMbr


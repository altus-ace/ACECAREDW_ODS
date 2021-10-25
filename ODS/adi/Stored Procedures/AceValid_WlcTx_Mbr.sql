
CREATE PROCEDURE [adi].[AceValid_WlcTx_Mbr](
    @LoadDate DATE)
as 
    --declare @LoadDate DATE = '09/29/2020'
    DECLARE @LoadType CHAR(1) = 'P';
    DECLARE @ClientKey INT = 2;       
    DECLARE @EffMonth VARCHAR(6) ;
    
    SELECT @EffMonth = CONVERT(VARCHAR(4), Year(@LoadDate)) + 
	   CASE WHEN LEN(CONVERT(VARCHAR(2), Month(@LoadDate)) ) < 2 THEN '0'+ CONVERT(VARCHAR(2), Month(@LoadDate))
 	   ELSE CONVERT(VARCHAR(2), Month(@LoadDate)) end 
    
    SELECT @LoadDate As LoadDate
	   , @LoadType As LoadType
	   , @ClientKey AS ClientKey
	   , @EffMonth AS EffectiveMonth

    SELECT 'TotalRowsForMonth' AS EffectiveMonthCount, m.LoadDate AS EffectiveMonth, COUNT(*) rowCnt
    FROM adi.MbrWlcMbrByPcp m
    WHERE m.LoadDate = @LoadDate	   
    GROUP BY m.LoadDate
    ORDER By m.LoadDate desc

    SELECT m.mbrWlcMbrByPcpKey, m.Sub_ID ClientMemberKey, PR.TIN, PR.NPI, m.LOB, m.BenePLAN
	   , m.EffDate AdiMemberEffectiveDate, m.TermDate AdiMemberExpirationDate
	   , CASE WHEN (@LoadDate BETWEEN m.effDate and ISNULL(m.TermDate, '12/31/2099'))
		  THEN 1
		  ELSE 0 
		  END AS ActiveMember
    FROM [adi].tvf_PdwSrc_Wlc_MemberByPcp(@LoadDate) m	   
	 JOIN (SELECT pr.Prov_ID, pr.TIN, pr.NPI, pr.Term_Date FROM adw.[MbrWlcProviderLookup] pr) PR 
		  ON  m.Prov_id = PR.Prov_id 
		  AND @loaddate <= PR.Term_Date	
	   JOIN lst.lstPlanMapping PlanLookup 
		  ON m.BenePLAN = PlanLookup.SourceValue
			 AND PlanLookup.ClientKey = @ClientKey
			 AND PlanLookup.TargetSystem = 'ACDW'
			 AND @LoadDate BETWEEN PlanLookup.EffectiveDate and PlanLookup.ExpirationDate
    WHERE m.LoadDate = @LoadDate	   
	   --AND m.MemberRowNumber = 1
    ORDER By m.LoadDate desc, m.Sub_ID

    
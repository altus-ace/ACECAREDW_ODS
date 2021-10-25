
CREATE PROCEDURE [adi].[AceValid_AetComTx_Mbr]( --- [adi].[AceValid_AetComTx_Mbr]'2021-07-21'
    @LoadDate DATE
     )
as 
    -- DECLARE @LoadDate DATE = '2021-07-21'
    DECLARE @AllDetails BIT = 1;
    DECLARE @iLoadDate DATE = @LoadDate;
    DECLARE @LoadType CHAR(1) = 'P';
    DECLARE @ClientKey INT = 9;       
    DECLARE @EffMonth VARCHAR(6) ;
    select @EffMonth = CONVERT(VARCHAR(4), Year(@iLoadDate)) + 
	   CASE WHEN LEN(CONVERT(VARCHAR(2), Month(@iLoadDate)) ) < 2 THEN '0'+ CONVERT(VARCHAR(2), Month(@iLoadDate))
 	   ELSE CONVERT(VARCHAR(2), Month(@iLoadDate)) end 

    IF @AllDetails = 1
    BEGIN
	   SELECT @iLoadDate As LoadDate
	   , @LoadType As LoadType
	   , @ClientKey AS ClientKey
	   , @EffMonth AS EffectiveMonth
    END;
    IF @AllDetails = 1 
    BEGIN 
	   SELECT 'TotalRowsForMonth' AS EffectiveMonthCount, m.EffectiveMonth, COUNT(*) rowCnt
	   FROM adi.MbrAetCom m
	   WHERE m.LoadDate = @iLoadDate
	      and effectiveMonth = @EffMonth
	   GROUP BY m.EffectiveMonth
	   ORDER By m.EffectiveMonth desc
    END;

    SELECT DISTINCT a.mbrAetComMbr,a.EffectiveMonth,  a.MEMBER_ID, a.Attributed_Provider_Tax_ID_Number_TIN, a.Line_of_Business
	   --, PlanProduct.TargetValue MappedLob, pr.TIN, pr.EffectiveDate, pr.ExpirationDate
    FROM adi.MbrAetCom a
	   LEFT JOIN (SELECT t.ClientMemberKey, t.EffectiveMonth, t.LastClientUpdateDate, t.adiKey, t.adiTableName, t.LoadDate
			 FROM [adi].tvf_MbrAetCom_GetCurrentMembers(@iLoadDate) t
			 ) mf ON a.mbrAetComMbr = mf.AdiKey   	     
	    JOIN lst.lstPlanMapping PlanProduct  
		  ON a.[Line_of_Business] = PlanProduct.SourceValue 
			 AND PlanProduct.ClientKey = @ClientKey
			 AND PlanProduct.TargetSystem = 'ACDW'
			 AND @iLoadDate BETWEEN PlanProduct.EffectiveDate and PlanProduct.ExpirationDate	
	   LEFT JOIN (	
					SELECT		AttribTIN,NPI
					FROM		(
					SELECT distinct pr.AttribTIN, pr.NPI
					,ROW_NUMBER() OVER (PARTITION BY pr.AttribTIN,pr.NPI
								 ORDER BY pr.RowEffectiveDate DESC) RwCnt
			 		FROM adw.tvf_AllClient_ProviderRoster(9,@LoadDate,1) PR )a
					WHERE	RwCnt = 1
				  --  AND pr.ProviderType IN ('PCP')
				)PR
		  ON a.Attributed_Provider_Tax_ID_Number_TIN = pr.AttribTIN	
    WHERE a.LoadDate = @iLoadDate 
	   AND a.EffectiveMonth = @EffMonth
	   AND NOT pr.AttribTIN IS NULL 
	     ORDER BY a.MEMBER_ID
    ;

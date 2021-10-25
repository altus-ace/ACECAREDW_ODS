
CREATE PROCEDURE [adi].[AceValid_AetMaTx_Mbr](
    @LoadDate DATE)  ---  [adi].[AceValid_AetMaTx_Mbr]'2021-07-21'
as 
	 --Get Latest Date
	SELECT TOP 5LoadDate
	FROM		adi.MbrAetMaTx a
	GROUP BY	LoadDate
	ORDER BY	LoadDate DESC


    -- Declare @LoadDate DATE = '2021-07-21'
    DECLARE @LoadType CHAR(1) = 'P';
    DECLARE @ClientKey INT = 3;       
    DECLARE @EffMonth VARCHAR(6) ;
    select @EffMonth = CONVERT(VARCHAR(4), Year(@LoadDate)) + 
	   CASE WHEN LEN(CONVERT(VARCHAR(2), Month(@LoadDate)) ) < 2 THEN '0'+ CONVERT(VARCHAR(2), Month(@LoadDate))
 	   ELSE CONVERT(VARCHAR(2), Month(@LoadDate)) end 

    SELECT @LoadDate As LoadDate
	   , @LoadType As LoadType
	   , @ClientKey AS ClientKey
	   , @EffMonth AS EffectiveMonth
	  
    SELECT 'TotalRowsForMonth' AS EffectiveMonthCount, m.EffectiveMonth, COUNT(*) rowCnt
    FROM adi.MbrAetMaTx m
    WHERE m.LoadDate = @LoadDate
	   and effectiveMonth = @EffMonth
    GROUP BY m.EffectiveMonth
    ORDER By m.EffectiveMonth desc
	SELECT DISTINCT mbrAetMaTxKey, MEMBER_ID, Attributed_Provider_Tax_ID_Number_TIN, Line_of_Business, MappedLob
	   , AttribTIN--, EffectiveDate, ExpirationDate
	FROM(
    SELECT DISTINCT a.mbrAetMaTxKey, a.MEMBER_ID, a.Attributed_Provider_Tax_ID_Number_TIN, a.Line_of_Business, PlanProduct.TargetValue MappedLob
	   , pr.AttribTIN--, pr.EffectiveDate, pr.ExpirationDate,RwCnt
    FROM adi.MbrAetMaTx a
	   JOIN (SELECT distinct t.ClientMemberKey, t.EffectiveMonth, t.CurrentLoadingEffectiveMonth, t.adiKey, t.adiTableName, t.LoadDate
			 FROM [adi].[tvf_MbrAetMaTx_GetCurrentMembers](@LoadDate) t
			 ) mf ON a.mbrAetMaTxKey = mf.AdiKey   
	   JOIN lst.lstPlanMapping PlanProduct  
		  ON a.[Line_of_Business] = PlanProduct.SourceValue 
			 AND PlanProduct.ClientKey = @ClientKey
			 AND PlanProduct.TargetSystem = 'ACDW'
			 AND @LoadDate BETWEEN PlanProduct.EffectiveDate and PlanProduct.ExpirationDate	
	   LEFT JOIN (SELECT distinct pr.AttribTIN, pr.NPI
					,ROW_NUMBER() OVER (PARTITION BY pr.AttribTIN
								 ORDER BY RowEffectiveDate DESC) RwCnt
			 	 FROM adw.tvf_AllClient_ProviderRoster(3,@LoadDate,1)   PR 
				)PR
		  ON a.Attributed_Provider_Tax_ID_Number_TIN = pr.AttribTIN	
			--AND @LoadDate BETWEEN pr.EffectiveDate AND pr.ExpirationDate --Commenting this out means there is no slicing by effective date for the pcp
    WHERE a.LoadDate = @LoadDate
	   and NOT pr.AttribTIN IS NULL   
	   )z
	   --WHERE z.RwCnt = 1 
	   ORDER BY MEMBER_ID
    ;
	
	

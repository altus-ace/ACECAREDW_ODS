CREATE PROCEDURE [ast].[PTS_FctProvRoster_Transform_DevPR] 
    ( @LoadDate DATE )
AS
BEGIN      
    
    DECLARE @Unk varchar(10) = 'Unknown'
    Declare @ZeroDate DATE = '01/01/1900'

    -- Set IsActive = 0 where Post match TIN is Null (invalid)
    UPDATE ast SET ast.IsActive = 0        
    FROM ast.fctProviderRoster_DevPR ast
    where ast.TIN is null
	   and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;	   

    -- Set IsActive = 0 where Not NPI and TIN HP Not active on RowEffectiveDate
    UPDATE ast SET ast.IsActive = 0    
    --SELECT ast.fctProviderRosterSkey, IsActive, ast.PrvdrHpEffDate,ast.PrvdrHpExpDate, ast.TinHpEffDate, ast.TinHpExpDate, ast.RowEffectiveDate, ast.TIN
    FROM ast.fctProviderRoster_DevPR ast
    where NOT (ast.RowEffectiveDate BETWEEN ast.PrvdrHpEffDate and ast.PrvdrHpExpDate
				and ast.RowEffectiveDate BETWEEN ast.TinHpEffDate and ast.TinHpExpDate)
	   and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate	   
	   and ast.IsActive = 1
    ;	       
    
    --SELECT ast.TinClientKey , 0
    Update ast set ast.TinClientKey = 0
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.TinClientKey, -1) = -1
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;
    --SELECT ast.TinLob, 'Unknown'	    
    update ast SET ast.TinLob = @Unk
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.TinLob, '') = ''
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;
    --SELECT 	   ast.TinHealthPlan	   , @Unk
    update ast SET ast.TinHealthPlan = @Unk
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.TinHealthPlan, '') = ''
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    --SELECT 	  ast.TinHpEffDate	   , '01/01/1900'
    ;
    UPDATE ast SET ast.TinHpEffDate = @ZeroDate     
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.TinHpEffDate, '01/01/1900') = '01/01/1900'
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;

    --SELECT 	  ast.TinHpExpDate	   
    update ast SET ast.TinHpExpDate = @ZeroDate 
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.TinHpExpDate, '01/01/1900') = '01/01/1900'
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;
    --SELECT ast.PrvdrTin	   , ''
    update ast SET ast.PrvdrTin = @Unk 
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.PrvdrTin, '') = ''
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;
    --SELECT  ast.PrvdrClientKey	   , 0
    update ast SET ast.PrvdrClientKey = 0
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.PrvdrClientKey, -1) = -1
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;
    --SELECT ast.PrvdrLOB	   , 'Unknown'
    update ast SET ast.PrvdrLOB = @Unk
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.PrvdrLOB, '') = ''
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;
    --SELECT ast.PrvdrHealthPlan	 , 'Unknown'
    update ast SET ast.PrvdrHealthPlan = @Unk
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.PrvdrHealthPlan, '') = ''
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate;
    ;
    --SELECT ast.PrvdrHpEffDate	   	  , '01/01/1900' 
    update ast SET ast.PrvdrHpEffDate = @ZeroDate
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.PrvdrHpEffDate, '01/01/1900') = '01/01/1900'
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;

    --SELECT ast.PrvdrHpExpDate	,'01/01/1900'
    update ast SET ast.PrvdrHpExpDate = @ZeroDate
    FROM ast.fctProviderRoster_DevPR ast
    WHERE ISNULL(ast.PrvdrHpExpDate, '01/01/1900') = '01/01/1900'
    and @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate
    ;

END;

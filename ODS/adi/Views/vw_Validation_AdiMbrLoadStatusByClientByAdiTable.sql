


CREATE VIEW [adi].[vw_Validation_AdiMbrLoadStatusByClientByAdiTable]
AS 
    /* Purpose: Select out the last 5 load date and counts by Mbr adi source */
    SELECT TOP 5 LOADDATE , 'MbrAetCom'  AS AdiTable, COUNT(*) as LoadCnt
    FROM adi.MbrAetCom
    GROUP BY LoadDate
    
    UNION ALL
    SELECT TOP 5 LOADDATE, 'MbrAetMaTx' AS AdiTable, COUNT(*) as LoadCnt
    FROM adi.MbrAetMaTx
    GROUP BY LoadDate
    /*
    UNION ALL
    SELECT TOP 5 LOADDATE, 'mbrUhcMbrByPcp' AS AdiTable, COUNT(*) as LoadCnt
    FROM adi.mbrUhcMbrByPcp
    GROUP BY LoadDate
    --ORDER BY LoadDate desc;    
    */
    UNION ALL
    SELECT TOP 5 LOADDATE, 'MbrWlcMbrByPcp' AS AdiTable, COUNT(*) as LoadCnt
    FROM adi.MbrWlcMbrByPcp
    GROUP BY LoadDate
    ORDER BY adiTable, LoadDate desc;
        

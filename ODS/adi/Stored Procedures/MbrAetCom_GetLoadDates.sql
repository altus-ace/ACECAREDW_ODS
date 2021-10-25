CREATE PROCEDURE adi.MbrAetCom_GetLoadDates 
    (@LoadDate DATE OUTPUT)
AS      
    SELECT @LoadDate = MAX(c.CreatedDate)
    FROM adi.MbrAetCom c
    GROUP BY c.CreatedDate 
    ORDER BY c.CreatedDate DESC;   

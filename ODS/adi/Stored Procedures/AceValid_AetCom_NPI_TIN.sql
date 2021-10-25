
CREATE PROCEDURE adi.AceValid_AetCom_NPI_TIN 
    @adiLoaddate Date 
AS 

--declare @adiLoaddate Date = '06/12/2019'

DECLARE @tmp Table (ClientMemberKey VARCHAR(50), ClientKey INT
    , srcPcpNpi VARCHAR(15)
    , srcAttNpi VARCHAR(15)
    , srcPcpTin VARCHAR(15)
    , srcAttTin VARCHAR(15)
    , sfAttTin VARCHAR(15)
    , sfPcpTin VARCHAR(15)
    );
INSERT INTO @tmp (ClientMemberKey, ClientKey, srcPcpNpi, srcAttNpi, srcPcpTin, srcAttTin)
SELECT mf.CLientMemberKey, c.ClientKey
    , m.[PCP_Provider_NPI_Number], m.Attributed_Provider_NPI_Number
    , m.[PCP_Provider_Tax_ID_Number_TIN], m.Attributed_Provider_Tax_ID_Number_TIN 
FROM adi.mbrAetCom m
    JOIN lst.List_Client c ON c.ClientKey = 9
    JOIN (SELECT t.ClientMemberKey, t.EffectiveMonth, t.LastClientUpdateDate, t.adiKey, t.adiTableName, t.LoadDate
		  FROM adi.tvf_MbrAetCom_GetCurrentMembers(@adiLoadDate) t
		  ) mf ON m.mbrAetComMbr = mf.AdiKey        
   ;


MERGE @tmp trg
USING(SELECT DISTINCT vp.TIN 
	   FROM [adw].[tvf_Get_AetCom_ValidProviderTinsByDate](GETDATE())  vp
	   )src
ON trg.srcPcpTin = src.Tin
WHEN MATCHED THEN UPDATE
    SET sfPcpTin = src.TIN
    ;
MERGE @tmp trg
USING(SELECT DISTINCT vp.TIN 
	   FROM [adw].[tvf_Get_AetCom_ValidProviderTinsByDate](GETDATE())  vp
	   )src
ON trg.srcAttTin = src.Tin
WHEN MATCHED THEN UPDATE
    SET sfAttTin = src.TIN
    ;

SELECT 'Provider/Attributed TINs are different' validation, *
FROM @tmp t
WHERE t.sfPcpTin <> t.sfAttTin


SELECT 'Provider/Attributed TINs are different' Validation

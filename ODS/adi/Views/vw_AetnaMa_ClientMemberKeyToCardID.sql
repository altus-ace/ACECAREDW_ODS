CREATE VIEW adi.vw_AetnaMa_ClientMemberKeyToCardID
AS 
SELECT DISTINCT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), c.MEMBER_ID)) AS ClientMemberKey,
    c.MEMBER_ID AetnaMaSource_MemberID, 
    c.Aetna_Card_ID --, c.mbrAetMaTxKey AS adiKey,     'adi.MbrAetMaTx' AS adiTableName
FROM adi.MbrAetMaTx c


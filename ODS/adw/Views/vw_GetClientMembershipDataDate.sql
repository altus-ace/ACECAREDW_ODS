
CREATE VIEW adw.vw_GetClientMembershipDataDate

AS

	SELECT			MAX(a.DataDate) DataDate,b.ClientKey
	FROM			adw.MbrLoadHistory a
	JOIN			(	
						SELECT		e.DataDate, ClientKey
									,e.mbrLoadKey
						FROM		adw.MbrMember e
						JOIN		adw.MbrDemographic f
						ON			e.mbrMemberKey = f.mbrMemberKey
					) b
	ON				a.mbrLoadHistoryKey = b.mbrLoadKey
	GROUP BY		b.ClientKey

	UNION
	SELECT			MAX(DataDate), ClientKey 
	FROM			ACDW_CLMS_SHCN_MSSP.adw.fctmembership
	GROUP BY		ClientKey


	
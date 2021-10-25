CREATE PROCEDURE adi.AceValidMbrAet_CompareAdiToAdw  (
    @cmk VARCHAR(50) = '231512292205291601'
    )
AS

    SELECT 'Adi table Record' AS src, *
    FROM adi.MbrAetMbrByPcp m
        JOIN (SELECT AdiKey
    		  FROM adw.mbrLoadHistory m
    		      JOIN (SELECT m.MbrLoadKey 
    		  		  FROM adw.mbrMember m 
    		  		  WHERE m.ClientMemberKey = @cmk
    		  		  ) LoadKey ON m.mbrLoadHistoryKey = LoadKey.mbrLoadKey
    		  ) adiKey ON m.mbrAetMbrByPcpKey = adiKey.AdiKey
    ;

    SELECT 'Adw Records' src, *
    FROM adw.MbrMember m
        JOIN adw.MbrDemographic d ON m.mbrMemberkey = d.mbrmemberkey
    where m.ClientMemberKey = @cmk


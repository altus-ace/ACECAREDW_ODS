

CREATE FUNCTION [adw].[tvf_Pdw_Mbr_TermSource] 
	(@loadDate date	
	, @ClientKey int )
	 RETURNS TABLE
AS RETURN
(	
	/* purpose: get the mbrs in the mbr model, not in the staging table, as a list to terminate during PDW */
	SELECT m.mbrMemberKey, p.mbrPlanKey, cs.mbrCsPlanKey, pcp.mbrPcpKey, mbrStg.mbrStg2_MbrDataUrn, m.ClientMemberKey
	FROM adw.MbrMember m
		LEFT JOIN adw.MbrPlan p ON m.mbrMemberKey = p.mbrMemberKey	
			AND @LoadDate BETWEEN p.EffectiveDate and p.ExpirationDate	
		LEFT JOIN adw.mbrCsPlanHistory cs ON m.mbrMemberKey = cs.mbrMemberKey	
			AND @LoadDate BETWEEN cs.EffectiveDate and cs.ExpirationDate	
		LEFT JOIN adw.MbrPcp pcp ON m.mbrMemberKey = pcp.mbrMemberKey	
			AND @LoadDate BETWEEN pcp.EffectiveDate and pcp.ExpirationDate	
		LEFT JOIN (SELECT m.mbrStg2_MbrDataUrn, m.ClientSubscriberId , m.LoadDate
					FROM ast.MbrStg2_MbrData m
					WHERE m.ClientKey = @clientkey
						AND m.LoadDate = @LoadDate
					)mbrStg ON m.ClientMemberKey = mbrStg.ClientSubscriberId
	WHERE m.ClientKey = @clientkey	
		AND mbrStg.mbrStg2_MbrDataUrn is null
)
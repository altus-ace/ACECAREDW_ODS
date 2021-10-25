CREATE PROCEDURE [adw].[sp_Ace_Validate_MbrModel] 
(
 @client INT 
 ,@date DATE 
 ,@PlanActive smallInt
 ,@PcpActive smallInt
 ,@ShowDetails TINYINT = 1
 )
 AS 
    IF @ShowDetails = 1
    BEGIN
	   SELECT 'Usage notes' As UsageNotes
	   	   , @Client ClientKey , 'Identifier of client, use -1 for all' As ClientDesc
	   	   , @Date [Date] , 'Date to get effective members for' as DateDesc
	   	   , @PlanActive PlanActive, 'For Plans return only active=1, inactive=0 or all=-1' PlanActiveDesc
	   	   , @PcpActive PcpActive, 'For Pcp return only active=1, inactive=0 or all = -1'	PcpActiveDesc
	   	   ;
	   END;

    SELECT *
    FROM (
    SELECT m.mbrMemberKey, m.ClientMemberKey, m.ClientKey, lc.ClientName
        , case when (p.MbrPcpKey is null) then 0 ELSE 1 END as pcpActive, p.NPI, p.TIN, p.EffectiveDate pcpEffectiveDate, p.ExpirationDate pcpExpirationDate
        , case when (pl.MbrPlanKey is null) then 0 ELSE 1 END as planActive, pl.ProductPlan, pl.ProductSubPlan, pl.EffectiveDate plnEffectiveDate, pl.ExpirationDate plnExpirationDate
    FROM adw.mbrMember m
        LEFT JOIN adw.MbrPcp p on m.mbrMemberKey = p.mbrMemberKey
    	   and @Date between p.EffectiveDate and p.ExpirationDate
        LEFT JOIN adw.MbrPlan pl ON m.mbrMemberKey = pl.mbrMemberKey
    	   and @Date BETWEEN pl.EffectiveDate and pl.ExpirationDate
	   JOIN lst.List_Client lc ON m.ClientKey = lc.ClientKey
    WHERE ((m.ClientKey = @client) or @client = -1)
    ) src
    WHERE ((src.planActive = @PlanActive) or @PlanActive = -1)
        and ((src.pcpActive = @PcpActive) or @PcpActive = -1)
    ORDER by pcpActive, planActive
 

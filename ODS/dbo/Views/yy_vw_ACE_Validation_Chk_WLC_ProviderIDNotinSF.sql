
CREATE VIEW [dbo].[yy_vw_ACE_Validation_Chk_WLC_ProviderIDNotinSF]
AS
--BRIT: V1:  Changes to PR
     SELECT DISTINCT 
            a.Prov_id, 
            A.PROV_NAME,
            CASE
                WHEN b.Prov_ID IS NULL
                THEN 'Provider Not Contracted'
                ELSE 'Provider Contracted'
            END AS [Provider_Contracted?],
            CASE
                WHEN YEAR(c.ExpirationDate) = 2099
                THEN 'Contracted Plan'
                ELSE 'Not contracted plan'
            END AS [Plan_Contracted?], 
            c.sourcevalue AS PlanID, 
            c.targetvalue AS PlanName, 
            COUNT(DISTINCT A.Sub_ID) AS Mbr_Count
     FROM adi.MbrWlcMbrByPcp a
          JOIN lst.lstPlanMapping c ON c.SourceValue = a.BenePLAN
                                       AND YEAR(c.EffectiveDate) = 2020
                                       AND c.ClientKey = 2
          LEFT JOIN [adw].[MbrWlcProviderLookup] b ON b.Prov_ID = a.Prov_id
                                                           AND YEAR(b.ExpirationDate) > 2019
											    --AND b.ProviderType in ('PCP')
     WHERE a.loaddate =
     (
         SELECT MAX(loaddate)
         FROM adi.MbrWlcMbrByPcp
     )
           AND MONTH(a.EffDate) = 1
           AND YEAR(a.EffDate) = 2020 --Change to get month of the current date from next month end
     GROUP BY a.Prov_id, 
              A.Prov_Name, 
              b.Prov_ID, 
              c.ExpirationDate, 
              c.sourcevalue, 
              c.targetvalue;

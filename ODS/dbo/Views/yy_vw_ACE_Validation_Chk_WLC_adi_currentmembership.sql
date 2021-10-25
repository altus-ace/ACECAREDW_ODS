


/* added Prov_id for easier validations*/

CREATE VIEW [dbo].[yy_vw_ACE_Validation_Chk_WLC_adi_currentmembership]
AS
--BRIT: V1:  Changes to PR
     SELECT DISTINCT 
            Sub_ID
     FROM adi.MbrWlcMbrByPcp Y
          INNER JOIN
     (
         SELECT DISTINCT 
                A.PROV_ID
         FROM vw_WellCare_ProviderRoster A
              JOIN [adw].[MbrWlcProviderLookup] B ON B.npi = A.NPI
         WHERE MONTH(B.EffectiveDate) <= MONTH(GETDATE())
               AND B.ExpirationDate >= '2019/08/31'
			--AND b.ProviderType in ('PCP')
     ) X ON X.PROV_ID = Y.PROV_ID
     WHERE Y.LoadDate =
     (
         SELECT MAX(loaddate)
         FROM adi.MbrWlcMbrByPcp
     )
           AND CONVERT(DATE, Y.EffDate, 101) <= '2019/08/01' --Change to current month effective date
           AND ISNULL(CONVERT(DATE, Y.TERMDATE, 101), '2099/01/01') >= CONVERT(DATE, GETDATE(), 101)
     EXCEPT
     SELECT MEMBER_ID
     FROM vw_ActiveMembers
     WHERE CLIENT = 'wlc';

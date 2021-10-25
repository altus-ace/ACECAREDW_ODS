




CREATE VIEW [dbo].[VW_RP_Specilist_Network_Brochure]
AS


WITH CTE
     AS 
	 (
	 SELECT DISTINCT 
                NPI, 
                [Last name], 
                [First Name], 
                --      [Degree], 
                [TAX ID], 
                [Primary Specialty], 
                --       [SECONDARY SPECIALTY], 
                [Practice Name], 
                [Primary Address], 
                [Primary City], 
                [Primary State], 
                [Primary Zipcode], 
                [Primary POD], 
                Concat([Primary Quadrant], ' HOUSTON') as [Primary Quadrant], 
                [Primary Address Phone#], 
				Fax,
				Degree,
                Concat([Client], '-', [LOB]) AS HealthPlan
         FROM ACECAREDW.dbo.vw_NetworkRoster
         WHERE STATUS = 'ACTIVE'
               AND [Primary Specialty] <> ''
               AND [Primary POD] <> ''
	  )
     SELECT DISTINCT 
            NPI, 
            [Last name], 
            [First Name], 
            --      [Degree], 
            [TAX ID], 
            [Primary Specialty], 
            --       [SECONDARY SPECIALTY], 
            [Practice Name], 
            [Primary Address], 
            [Primary City], 
            [Primary State], 
            [Primary Zipcode], 
            [Primary POD], 
            [Primary Quadrant], 
            [Primary Address Phone#],
			Fax,
			Degree,

            --HealthPlan

            HealthPlans = STUFF(
     (
         SELECT DISTINCT 
                ',' + HealthPlan
         FROM  CTE  b
      --        JOIN acecaredw.dbo.vw_networkRoster  c ON b.npi = c.npi 
			  where b.npi = cTE.npi
			  FOR XML PATH ('')),1,1,'')
     FROM CTE




CREATE view [dbo].[vw_RICK_Houston_phy_SF]
AS
SELECT case when rtrim(Practice) ='' or practice is null then [Last Name] else 
	   RTRIM(replace(RTRIM(Practice), ',', ' ')) end AS [Account Name],
       Rtrim(replace(RTRIM(Address), ',','')) AS Street,
       RTRIM(City) AS City,
       RTRIM(State) AS State,
       RTRIM(zip) AS [Postal Code],
       SUBSTRING(zip, 1, 5) AS Zipcode_lookup,
       RTRIM(County) AS County,
       RTRIM(PHone) AS Phone,
       RTRIM(Fax) AS Fax,
       RTRIM([First Name]) AS FirstName,
       RTRIM([Last Name]) AS LastName,
       RTRIM(Email) AS Email,
       RTRIM(Gender) AS Gender,
       rtrim(replace(RTRIM(RTRIM(Specialty)
	  +CASE
        WHEN LEN(LTRIM(RTRIM([Specialty 2]))) > 0
         THEN ';'
            ELSE ''
             END+RTRIM([Specialty 2])+CASE
            WHEN LEN(LTRIM(RTRIM([Specialty 3]))) > 0
           THEN ';'
            ELSE ''
        END+RTRIM([Specialty 3])+CASE
            WHEN LEN(LTRIM(RTRIM([Specialty 4]))) > 0
                THEN ';'
               ELSE ''
            END+RTRIM([Specialty 4])+CASE
   WHEN LEN(LTRIM(RTRIM([Specialty 5]))) > 0
      THEN ';'
  ELSE ''
END+RTRIM([Specialty 5])),',',' &')) AS [Provider Specialties],
       RTRIM(NPi) AS [NPI],
       ROW_NUMBER() OVER(PARTITION BY SUBSTRING(zip, 1, 5),
                                      phone,
                                      Practice ORDER BY Practice ASC) AS arn
FROM rick_physician_roster
WHERE State = 'TX'
      AND City = 'Houston'
      AND NPI NOT IN
(
    SELECT DISTINCT
           NPI
    FROM rick_physician_roster
    WHERE State = 'TX'
          AND City = 'Houston'
          AND npi <> ' '
          AND npi IN
    (
        SELECT DISTINCT
               Provider_NPI__c
        FROM tmpSalesforce_Contact
        WHERE provider_npi__C IS NOT NULL
    )
)



CREATE VIEW adi.MPulseOptOuts_Valid
AS 
    /* purpose: gets validation state of MPulse Adi data
	   1. Client member key is required
	   2. Client Key is required
	   3. Ace_id is required
	   4. PHone number is requried
	   5. Do we need a campaign ID?

	   */
    SELECT m.MpulseOptOutUrn, m.ClientMemberKey, m.ClientKey, m.Ace_ID, m.PhoneNumber, 'MIssing campaign ID'CampaignID
    , CASE WHEN (ISNULL(m.ClientMemberKey, '') = '') THEN 'N'
	   ELSE 'Y'
	   END AS ClientMemberKeyIsValid
    , CASE WHEN (ISNULL(m.ClientKey, '') = '') THEN 'N'
	   ELSE 'Y'
	   END AS ClientKeyIsValid
    , CASE WHEN (ISNULL(m.Ace_ID, 0) = 0) THEN 'N'
	   ELSE 'Y'
	   END AS AceIdIsValid
    , CASE WHEN (ISNULL(adw.AceCleanPhoneNumber(m.PhoneNumber), '') = '') THEN 'N'
	   ELSE 'Y'
	   END AS PhoneNumberIsValid
    FROM adi.MPulseOptOuts m

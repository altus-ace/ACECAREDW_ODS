CREATE FUNCTION [dbo].[tvf_Activemembers_Keys](@EffectiveDate DATE, @ClientKey INT)
RETURNS TABLE
    /* Purpose: gets all members active for all clients for a specific day.
	   Incudes the keys of the Rows used to create the set. 
	   */  
AS
    RETURN
(   /*
	   SET STATISTICS IO ON;
	   DBCC FREEPROCCACHE;

	   DECLARE @EffectiveDate date = '02/25/2020'
	   declare @clientKey int = 9

	   */

    --DECLARE @EffectiveDate date = '01/01/2020'
    SELECT 
           M.[mbrMemberKey]
		 , MbrDemo.mbrDemographicKey
		 , MbrPlan.mbrPlanKey
		 , MbrPcp.mbrPcpKey
		 , mbrCsPlan.mbrCsPlanKey
		 , MbrPhone1.mbrPhoneKey MbrPhoneKeyType1
		 , ISNULL(MbrPhone2.mbrPhoneKey, 0) MbrPhoneKeyType4
		 , MbrPhone3.mbrPhoneKey MbrPHoneKeyType3
		 , MbrAddress1.mbrAddressKey AS MbrAddressKey1
		 , MbrAddress2.mbrAddressKey AS MbrAddressKey2
		 , lc.ClientShortName	  AS CLIENT
		 , lc.ClientKey		  AS ClientKey
		 , M.[ClientMemberKey]	  AS MEMBER_ID
		 , m.MstrMrnKey		  AS Ace_ID
		 , GETDATE() AS CreatedDate
		 , system_user AS CreatedBy
		 , @EffectiveDate AS MemberMonthDate		 		 
    FROM [adw].[MbrMember] m    
         INNER JOIN [lst].[List_Client] lc ON lc.Clientkey = m.clientkey	
	    JOIN [adw].[MbrPcp] MbrPcp ON MbrPcp.mbrMemberKey = m.mbrMemberKey
                                                       AND @EffectiveDate BETWEEN MbrPcp.EffectiveDate AND MbrPcp.ExpirationDate
         JOIN [adw].[MbrPlan] MbrPlan ON MbrPlan.mbrMemberKey = m.mbrMemberKey
                                                     AND @EffectiveDate BETWEEN MbrPlan.EffectiveDate AND MbrPlan.ExpirationDate
         INNER JOIN [adw].[MbrDemographic] MbrDemo ON MbrDemo.[mbrMemberKey] = m.[mbrMemberKey]
                                                            AND @EffectiveDate BETWEEN MbrDemo.EffectiveDate AND MbrDemo.ExpirationDate    

	    JOIN [adw].[mbrCsPlanHistory] MbrCsPlan ON MbrCsPlan.mbrMemberKey = m.mbrMemberKey
                                                     AND @EffectiveDate BETWEEN MbrCsPlan.EffectiveDate AND MbrCsPlan.ExpirationDate
         LEFT JOIN (SELECT MbrMemberKey, EffectiveDate, ExpirationDate, AddressTypeKey, MbrAddressKey,
					   Address1, Address2, city, STATE, 
					   case when try_convert(int,RIGHT(address1,5)) IS null then ZIP 
						  else RIGHT(address1,5)  end  ZIP,COUNTY, TRY_CONVERT(int, Zip) AS zipCodeJoin
				FROM [adw].[MbrAddress]) AS MbrAddress1 ON MbrAddress1.MbrMemberKey = m.mbrMemberKey
				    AND MbrAddress1.AddressTypeKey = 1
				    AND @EffectiveDate BETWEEN MbrAddress1.EffectiveDate AND MbrAddress1.ExpirationDate
         LEFT JOIN lst.[lstAddressType] lstAddressType1 ON lstAddressType1.[lstAddressTypeKey] = MbrAddress1.[AddressTypeKey]
                                                            AND lstAddressType1.lstAddressTypeKey = 1
         LEFT JOIN [adw].[MbrAddress] MbrAddress2 ON MbrAddress2.MbrMemberKey = m.mbrMemberKey
                                                         AND MbrAddress2.AddressTypeKey = 2
                                                 AND @EffectiveDate BETWEEN MbrAddress2.EffectiveDate AND MbrAddress2.ExpirationDate
         LEFT JOIN lst.[lstAddressType] lstAddressType2 ON lstAddressType2.[lstAddressTypeKey] = MbrAddress2.[AddressTypeKey]
                                                            AND lstAddressType2.lstAddressTypeKey = 2
         LEFT JOIN(SELECT [mbrPhoneKey], [mbrMemberKey], [mbrLoadKey], [EffectiveDate], [ExpirationDate], [PhoneType], [PhoneNumber], rank
				FROM (SELECT p.[mbrPhoneKey], p.[mbrMemberKey], p.[mbrLoadKey], p.[EffectiveDate],p.[ExpirationDate], p.[PhoneType], p.[PhoneNumber]
					   , ROW_NUMBER() OVER(PARTITION BY p.[mbrMemberKey]/* force single phNUm ,p.[PhoneNumber]*/ ORDER BY p.[ExpirationDate] DESC) AS rank
					   FROM [adw].[MbrPhone] p
					   WHERE p.PhoneType = 1
					  ) AS c
				WHERE c.rank = 1
				) AS MbrPhone1 ON MbrPhone1.MbrMemberKey = m.MbrMemberKey
				    AND @EffectiveDate BETWEEN MbrPhone1.EffectiveDate AND MbrPhone1.ExpirationDate
		LEFT JOIN lst.lstPhoneType lpt ON lpt.lstPhonetypeKey = MbrPhone1.phoneType
                                                       AND lpt.lstPhoneTYpekey = 1
         LEFT JOIN ( SELECT [mbrPhoneKey], [mbrMemberKey],[mbrLoadKey],[EffectiveDate], [ExpirationDate],[PhoneType],[PhoneNumber], [rank]
				    FROM (SELECT p.[mbrPhoneKey], p.[mbrMemberKey], p.[mbrLoadKey], p.[EffectiveDate],p.[ExpirationDate], p.[PhoneType], p.[PhoneNumber]
					   , ROW_NUMBER() OVER(PARTITION BY p.[mbrMemberKey]/* force single phNUm ,p.[PhoneNumber]*/ ORDER BY p.[ExpirationDate] DESC) AS rank
					   FROM [adw].[MbrPhone] p
					   WHERE p.PhoneType = 4
						  ) AS c1
				    WHERE c1.rank = 1) MbrPhone2 ON MbrPhone2.MbrMemberKey = m.MbrMemberKey
					   AND @EffectiveDate BETWEEN MbrPhone2.EffectiveDate AND MbrPhone2.ExpirationDate
	   LEFT JOIN lst.lstPhoneType lpt2 ON lpt2.lstPhonetypeKey = MbrPhone2.phoneType
                                                        AND lpt2.lstPhoneTYpekey = 4
        LEFT JOIN(SELECT [mbrPhoneKey], [mbrMemberKey],[mbrLoadKey],[EffectiveDate],[ExpirationDate],[PhoneType],[PhoneNumber]
				FROM(SELECT p.[mbrPhoneKey], p.[mbrMemberKey], p.[mbrLoadKey], p.[EffectiveDate],p.[ExpirationDate], p.[PhoneType], p.[PhoneNumber]
					   , ROW_NUMBER() OVER(PARTITION BY p.[mbrMemberKey]/* force single phNUm ,p.[PhoneNumber]*/ ORDER BY p.[ExpirationDate] DESC) AS rank
					   FROM [adw].[MbrPhone] p
					   WHERE p.PhoneType = 3
					   ) AS c3
				WHERE c3.rank = 1) MbrPhone3 ON MbrPhone3.MbrMemberKey = m.MbrMemberKey
				    AND @EffectiveDate BETWEEN MbrPhone3.EffectiveDate AND MbrPhone3.ExpirationDate
         LEFT JOIN lst.lstPhoneType lpt3 ON lpt3.lstPhonetypeKey = MbrPhone3.phoneType
                                                        AND lpt3.lstPhoneTYpekey = 3											          
    -- removed,  as the keys don't require the Provider roster to work
    --     LEFT JOIN(SELECT DISTINCT [NPI], [LAST NAME], [FIRST NAME], [TAX ID], [PRIMARY SPECIALTY], [SECONDARY SPECIALTY]
	   --			    , [PRACTICE NAME], [PRIMARY ADDRESS], [PRIMARY CITY], [PRIMARY STATE], [PRIMARY ZIPCODE]
	   --			    , [PRIMARY POD], [PRIMARY ADDRESS PHONE#], [STATUS], [ACCOUNT TYPE], [NETWORK_CONTACT__c], [PRIMARY QUADRANT]
	   --			    FROM [dbo].[vw_NetworkRoster]	   			 	 	   			
				--) PR ON  PR.NPI =  MbrPcp.NPI  AND PR.[TAX ID] = MbrPcp.tin
        left JOIN (SELECT CONVERT(INT, zp.ZipCode) ZipCode, zp.Quadrant, zp.Pod 
				FROM [dbo].[LIST_ZIPCODES] zp) zp 
			ON zp.zipcode = MbrAddress1.zipCodeJoin
    WHERE (@clientKey = 0) or (@clientKey <> 0 and lc.ClientKey = @clientKey)
  
  )
;
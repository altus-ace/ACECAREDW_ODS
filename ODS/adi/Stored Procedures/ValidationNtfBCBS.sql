
CREATE PROCEDURE adi.ValidationNtfBCBS

AS



	--Validation --Count of records to be processed into ast
		SELECT		DISTINCT COUNT(*)
		FROM		(
						SELECT		DISTINCT InsuranceMemberID,SubscriberID,a.IPAdmitDateTime
									,b.MemberDateBirth ,a.Birth,PatientID,ClientMemberKey
						FROM		ACDW_CLMS_SHCN_MSSP.[adi].Steward_MSSPDischargedMedicarePatients a
						JOIN		ACDW_CLMS_SHCN_BCBS.adi.Steward_BCBS_MemberCrosswalk b
						ON			a.InsuranceMemberID = b.SubscriberID
						AND			a.Birth = b.MemberDateBirth
						JOIN		ACDW_CLMS_SHCN_BCBS.adw.FctMembership c
						ON			CONVERT(VARCHAR(50),b.PatientID) = c.ClientMemberKey
						WHERE		PriInsurance NOT LIKE '%Medic%'
					)z
	

	---		Record events processed already by GHH
						SELECT c.ClientMemberKey,z.ClientMemberKey 
						FROM	(
										SELECT		DISTINCT InsuranceMemberID,SubscriberID,a.IPAdmitDateTime
													,b.MemberDateBirth ,a.Birth,PatientID,ClientMemberKey
										FROM		ACDW_CLMS_SHCN_MSSP.[adi].Steward_MSSPDischargedMedicarePatients a
										JOIN		ACDW_CLMS_SHCN_BCBS.adi.Steward_BCBS_MemberCrosswalk b
										ON			a.InsuranceMemberID = b.SubscriberID
										AND			a.Birth = b.MemberDateBirth
										JOIN		ACDW_CLMS_SHCN_BCBS.adw.FctMembership c
										ON			CONVERT(VARCHAR(50),b.PatientID) = c.ClientMemberKey
										WHERE		PriInsurance NOT LIKE '%Medic%'
									 )c
						LEFT JOIN		(SELECT * FROM adw.NtfNotification) z
						ON			c.ClientMemberKey =z.ClientMemberKey
						ORDER BY	c.ClientMemberKey DESC

	----		Count Record of BCBS IP events processed already in adw.
						SELECT ClientMemberKey FROM adw.NtfNotification WHERE ClientKey = 20
						AND NtfPatientType = 'IP'
						ORDER BY ClientMemberKey DESC

	---			Daily count of records				
					SELECT AceFollowUpDueDate,* FROM adw.NtfNotification where ClientKey = 20
					AND CONVERT(DATE,CreatedDate) = '2021-03-19'
					AND NtfPatientType = 'IP'

					SELECT * FROM ACDW_CLMS_SHCN_MSSP.adi.Steward_MSSPDischargedMedicarePatients
					WHERE PriInsurance NOT LIKE '%Medic%'
					AND CONVERT(DATE,CreateDate) = '2021-03-19'
					---- MSSP only is the only ClientKey who has AcefollowupDueDate for IP.All other clients have null as AceFollowUpDueDate

----- Cummulative processed records 
					SELECT		 /*DISTINCT*/ InsuranceMemberID,SubscriberID,PatientID,a.IPAdmitDateTime,a.CreateDate
								,b.MemberDateBirth ,a.Birth--,ClientMemberKey
					FROM		ACDW_CLMS_SHCN_MSSP.[adi].Steward_MSSPDischargedMedicarePatients a
					LEFT JOIN	ACDW_CLMS_SHCN_BCBS.adi.Steward_BCBS_MemberCrosswalk b
					ON			a.InsuranceMemberID = b.SubscriberID
					AND			a.Birth = b.MemberDateBirth
					--LEFT JOIN		ACDW_CLMS_SHCN_BCBS.adw.FctMembership c
					--ON			CONVERT(VARCHAR(50),b.PatientID) = c.ClientMemberKey
					WHERE		PriInsurance NOT LIKE '%Medic%'
					ORDER BY	a.CreateDate DESC
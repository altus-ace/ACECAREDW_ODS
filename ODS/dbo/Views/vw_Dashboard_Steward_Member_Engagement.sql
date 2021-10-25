
CREATE VIEW [dbo].[vw_Dashboard_Steward_Member_Engagement]
AS
 select * from(
     SELECT DISTINCT 
            QM.Clientmemberkey, 
            Act.[CareActivityTypeName] AS Activity_Name,
            CASE
                WHEN [Text].uhc_subscriber_id IS NULL
                THEN 0
                ELSE 1
            END Text_Flag, 
			CASE
                WHEN Act.ActivityCreatedDate IS NULL
                THEN 0
                ELSE 1
            END Activity_Flag, 
            Convert(date,Act.[ActivityCreatedDate],101) AS Activity_Date, 
            convert(date,um.LAST_PCP_VISIT,101) as LAST_PCP_VISIT, 
			[Text].Text_Count,
            COUNT(DISTINCT PCPV.PRIMARY_SVC_DATE) AS PCP_Visit_Count, 
            ROW_NUMBER() OVER(PARTITION BY qm.clientmemberkey
            ORDER BY qmdate) AS Rnk, 
            QMDate as AHR_Sent_Date, 
            COUNT(qm.qmcntcat) AS Total_Gaps, 
            COUNT(appt.AppointmentCreatedDate) AS Appointments_Count
     FROM ACECAREDW.adw.QM_ResultByMember_History QM
          LEFT JOIN ACECAREDW.[dbo].[tmp_Ahs_PatientActivities] Act ON Act.Clientmemberkey = QM.Clientmemberkey and YEAR([ActivityCreatedDate]) = 2019 and QM.QmCntCat = 'COP'
          LEFT JOIN ACECAREDW.[dbo].[tmp_Ahs_PatientAppointments] Appt ON Appt.Clientmemberkey = QM.Clientmemberkey and QM.QmCntCat = 'COP'
          LEFT JOIN (select UHC_Subscriber_ID, LAST_PCP_VISIT from ACECAREDW.dbo.UHC_membership where YEAR(A_LAST_UPDATE_DATE) = 2019) UM ON UM.UHC_Subscriber_ID = Qm.Clientmemberkey   and QmCntCat = 'COP'
          LEFT JOIN
     (
         SELECT SUBSCRIBER_ID, PRIMARY_SVC_DATE
         FROM ACECAREDW_TEST.[adw].[z_tvf_Get_PCPVisits]('Physician', 'P', 'P', '01/01/2019', '12/31/2099')
     ) PCPV ON PCPV.Subscriber_ID = QM.Clientmemberkey and QmCntCat = 'COP'
          LEFT JOIN
     (
         SELECT UM.UHC_SUBSCRIBER_ID, 
                COUNT(DISTINCT msg.content) AS Text_Count
         FROM [DEV_ACECAREDW].[dbo].[tmp_mPulseMessages] msg
              JOIN ACECAREDW.dbo.UHC_membership UM ON RIGHT(msg.phone_number, 10) = UM.MEMBER_PHONE
                                            AND YEAR(UM.A_LAST_UPDATE_DATE) = 2019
         GROUP BY UM.UHC_SUBSCRIBER_ID
     ) [Text] ON [text].UHC_SUBSCRIBER_ID = qm.ClientMemberKey and QmCntCat = 'COP' 
	 where  QM.ClientKey = 1
     GROUP BY QM.Clientmemberkey, 
              Act.[CareActivityTypeName], 
              [Text].uhc_subscriber_id, 
              Act.[ActivityCreatedDate], 
              um.LAST_PCP_VISIT, 
			  Text_Count,
              PCPV.PRIMARY_SVC_DATE, 
              QMDate
			  ) x where Rnk = 1 ;

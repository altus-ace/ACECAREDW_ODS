
CREATE PROCEDURE [adi].[GetDailyNoteToAHS]
   	--[CreatedDate] [datetime] ,
	--@FilterDate [varchar](50)

AS
BEGIN TRY 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRANSACTION
    SELECT  distinct  mbr.ClientMemberKey AS Member_ID, 
              x.[Text] AS Note, 
              'Text Message' AS Note_Type, 
              'N/A' AS Script_Name, 
              x.Entered_by,
			--  convert(date, x.CENTRAL_DATE_TIME) as Created_On,
			  CAST(CONVERT(CHAR(16), x.CENTRAL_DATE_TIME,20) AS datetime)  as Created_On,
			  'N/A' as Updated_by
    FROM
(
    SELECT central_date_time, 'mPulse' AS Entered_by,
           phone_number, 
           concat('ACE: ', content) AS [Text]
    FROM adi.mpulsemessages
	WHERE [Status] is NULL 
--	where CENTRAL_DATE_TIME between '04/1/2020' and '06/22/2020' 
	--> @Date
	--'04/10/2020'
    UNION
    SELECT central_date_time, 'mPulse' AS Entered_by,
           phone_number, 
           Concat('Mbr: ', MESSAGE_RECEIVED) AS [Text]
    FROM adi.mpulsememberresponses
	WHERE [Status] is NULL 
	--	where CENTRAL_DATE_TIME between '04/10/2020' and '06/22/2020' 
	
    UNION
    SELECT optOut_date_time central_date_time, 'mPulse' AS Entered_by,
           phonenumber, 
           'Mbr: STOP' AS [Text]
    FROM adi.mpulseoptouts
	WHERE [Status] is NULL 
	--	where optOut_date_time  between '04/10/2020' and '06/22/2020' 
		--> @Date
    UNION
    SELECT central_date_time, 'mPulse' AS Entered_by,
           phone_number, 
           Concat('Mbr: ',MESSAGE_RECEIVED) AS [Text]
    FROM adi.MpulseWorkflowResponses
	WHERE [Status] is NULL 
	--	where CENTRAL_DATE_TIME between '04/10/2020' and '06/22/2020' 
		--> @Date
	UNION 
	SELECT  Central_date_time,Username AS Entered_by,
			Phone_Number,
			CONCAT(UserName,': ',content) AS [TEXT]
	FROM adi.mpulseacemessages 
	WHERE [Status] is NULL
	--where CENTRAL_DATE_TIME is not null and  CENTRAL_DATE_TIME > @Date
) AS x
JOIN ACECAREDW.adw.[MbrPhone] mp ON mp.phonenumber = RIGHT(x.PHONE_NUMBER, 10)
JOIN ACECAREDW.adw.MbrMember mbr ON mp.mbrmemberkey = mbr.mbrmemberkey
where PHONE_NUMBER <> ''
--and Entered_by <> 'mPulse'


/** Adding UHC members since they are not in membermodel **/

union 
SELECT  distinct  mp.uhc_subscriber_id AS Member_ID, 
              x.[Text] AS Note, 
              'Text Message' AS Note_Type, 
              'N/A' AS Script_Name, 
              x.Entered_by,
			  convert(date, x.CENTRAL_DATE_TIME) as Created_On,
			  'N/A' as Updated_by
FROM
(
    SELECT central_date_time, 'mPulse' AS Entered_by,
           phone_number, 
           concat('ACE: ', content) AS [Text]
    FROM adi.mpulsemessages
	WHERE [Status] is NULL 
	--	where CENTRAL_DATE_TIME between '04/10/2020' and '06/22/2020' 
		--> @Date
    UNION
    SELECT central_date_time, 'mPulse' AS Entered_by,
           phone_number, 
           Concat('Mbr: ', MESSAGE_RECEIVED) AS [Text]
    FROM adi.mpulsememberresponses
	WHERE [Status] is NULL 
	--	where CENTRAL_DATE_TIME > @Date
    UNION
    SELECT optOut_date_time central_date_time, 'mPulse' AS Entered_by,
           phonenumber, 
           'Mbr: STOP' AS [Text]
    FROM adi.mpulseoptouts
	WHERE [Status] is NULL 
	--	where optOut_date_time > @Date
    UNION
    SELECT central_date_time, 'mPulse' AS Entered_by,
           phone_number, 
           Concat('Mbr: ',MESSAGE_RECEIVED) AS [Text]
    FROM adi.MpulseWorkflowResponses
	WHERE [Status] is NULL 
	--	where CENTRAL_DATE_TIME > @Date
	UNION 
	SELECT  Central_date_time,Username AS Entered_by,
			Phone_Number,
			CONCAT(UserName,': ',content) AS [TEXT]
	FROM adi.mpulseacemessages 
	WHERE [Status] is NULL
	--where CENTRAL_DATE_TIME is not null and 	 CENTRAL_DATE_TIME > @Date
) AS x
JOIN ACECAREDW.dbo.uhc_membersbypcp mp ON mp.member_home_phone = RIGHT(x.PHONE_NUMBER, 10)
where PHONE_NUMBER <> ''
--and Entered_by <> 'mPulse'

--group by x.member_id, x.[Text],x.CENTRAL_DATE_TIME, x.entered_by
order by member_id desc, created_on 

-- update the status on all unsended mPulse message to send 

UPDATE adi.mpulsemessages
SET [Status] = 1
WHERE [Status] is NULL

UPDATE adi.mpulsememberresponses 
SET [Status] = 1
WHERE [Status] is NULL 

UPDATE adi.mpulseoptouts
SET [Status] = 1
WHERE [Status] is NULL 

UPDATE adi.MpulseWorkflowResponses
SET [Status] = 1
WHERE [Status] is NULL 

UPDATE [adi].[MpulseAceMessages]
SET [Status] = 1
WHERE [Status] is NULL 
COMMIT TRANSACTION

END TRY

BEGIN CATCH 
      IF @@trancount > 0 ROLLBACK TRANSACTION
      DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
      RETURN 55555
END CATCH 
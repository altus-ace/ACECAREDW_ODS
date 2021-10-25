
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import8x8Allinteractions](
   
	@SrcFileName [varchar](100) NULL,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@mediatype [varchar](50) NULL,
	@channelobjid [varchar](50) NULL,
	@queuename [varchar](50) NULL,
	@interactionid [varchar](50) NULL,
	@originteractionid [varchar](50) NULL,
	@origination varchar(50) NULL,
	@destinationoriginal [varchar](50) NULL,
	@destinationtranslated [varchar](50) NULL,
	@customername [varchar](50) NULL,
	@caseid [varchar](50) NULL,
	@interactiondirection [varchar](50) NULL,
	@interactiontype [varchar](50) NULL,
	@dialcode [varchar](50) NULL,
	@dialtext [varchar](50) NULL,
	@createtimestamp varchar(50) NULL,
	@agentid [varchar](50) NULL,
	@agentname [varchar](50) NULL,
	@accepttimestamp varchar(50) NULL,
	@processtime [int] NULL,
	@postprocesstime [int] NULL,
	@totaltime [int] NULL,
	@abandontimestamp [varchar](50) NULL,
	@voicemessageleft [varchar](50) NULL,
	@recordingfilename [varchar](50) NULL,
	@ivrtreatmenttime [varchar](50) NULL,
	@transferfrom [varchar](50) NULL,
	@conferencefrom [varchar](50) NULL,
	@maxholdtime [varchar](50) NULL,
	@holdcount [varchar](50) NULL,
	@totalholdtime [varchar](50) NULL,
	@callleg1postdialdelay [varchar](50) NULL,
	@callleg2postdialdelay [varchar](50) NULL,
	@callleg1answertime [varchar](50) NULL,
	@callleg2answertime [varchar](50) NULL,
	@callleg1sipid [varchar](50) NULL,
	@callleg2sipid [varchar](50) NULL,
	@inboundsipid [varchar](50) NULL,
	@notes [varchar](50) NULL,
	@campaignname [varchar](50) NULL,
	@recordid [varchar](50) NULL,
	@recordstatus [varchar](50) NULL,
	@dispositioncode [varchar](50) NULL,
	@exttransdata [varchar](50) NULL,
	@wrapupcode [varchar](50) NULL,
	@wrapuptext [varchar](100) NULL,
	@agentaccepttimestamp varchar(50) NULL,
	@agentabandontimestamp varchar(50) NULL,
	@transrecnum [varchar](50) NULL,
	@isinteractioncompleted [varchar](10) NULL,
	@Status [char](1) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    

 
 INSERT INTO [adi].[ACE8x8Allinteractions]
   (
    [SrcFileName] ,
	[CreateDate],
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[media-type] ,
	[channel-obj-id] ,
	[queue-name] ,
	[interaction-id] ,
	[orig-interaction-id] ,
	[origination] ,
	[destination-original] ,
	[destination-translated] ,
	[customer-name] ,
	[case-id] ,
	[interaction-direction],
	[interaction-type] ,
	[dial-code] ,
	[dial-text] ,
	[create-timestamp] ,
	[agent-id] ,
	[agent-name] ,
	[accept-timestamp] ,
	[process-time] ,
	[post-process-time] ,
	[total-time] ,
	[abandon-timestamp] ,
	[voice-message-left] ,
	[recording-filename] ,
	[ivr-treatment-time] ,
	[transfer-from] ,
	[conference-from] ,
	[max-hold-time] ,
	[hold-count] ,
	[total-hold-time] ,
	[call-leg1-post-dial-delay] ,
	[call-leg2-post-dial-delay] ,
	[call-leg1-answer-time] ,
	[call-leg2-answer-time] ,
	[call-leg1-sip-id] ,
	[call-leg2-sip-id] ,
	[inbound-sip-id] ,
	[notes] ,
	[campaign-name] ,
	[record-id] ,
	[record-status] ,
	[disposition-code] ,
	[ext-trans-data] ,
	[wrap-up-code] ,
	[wrap-up-text] ,
	[agent-accept-timestamp] ,
	[agent-abandon-timestamp] ,
	[trans-rec-num] ,
	[is-interaction-completed] ,
	[Status] 
     )
     VALUES
   (   
   @SrcFileName ,
   GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
	@mediatype ,
	@channelobjid ,
	@queuename ,
	@interactionid ,
	@originteractionid ,
	@origination ,
	@destinationoriginal ,
	@destinationtranslated ,
	@customername,
	@caseid,
	@interactiondirection,
	@interactiontype,
	@dialcode,
	@dialtext,
	CASE WHEN @createtimestamp = ''
	THEN NULL
	ELSE CONVERT(datetime,@createtimestamp)
	END,
	@agentid,
	@agentname,
	CASE WHEN @accepttimestamp = ''
	THEN NULL
	ELSE CONVERT(datetime, 	@accepttimestamp)
    END,
	@processtime,
	@postprocesstime,
	@totaltime,
	@abandontimestamp,
	@voicemessageleft,
	@recordingfilename,
	@ivrtreatmenttime,
	@transferfrom ,
	@conferencefrom ,
	@maxholdtime ,
	@holdcount ,
	@totalholdtime ,
	@callleg1postdialdelay ,
	@callleg2postdialdelay ,
	@callleg1answertime ,
	@callleg2answertime ,
	@callleg1sipid ,
	@callleg2sipid ,
	@inboundsipid ,
	@notes ,
	@campaignname ,
	@recordid ,
	@recordstatus ,
	@dispositioncode ,
	@exttransdata ,
	@wrapupcode ,
	@wrapuptext ,
	CASE WHEN @agentaccepttimestamp  = ''
	THEN NULL
	ELSE CONVERT(datetime, @agentaccepttimestamp )
    END,
	CASE WHEN @agentabandontimestamp  = ''
	THEN NULL
	ELSE CONVERT(datetime, @agentabandontimestamp)
    END,
	@transrecnum,
	@isinteractioncompleted ,
	@Status  


   )
  
END

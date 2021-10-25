-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import8x8ReportLog](
   
	--@DataDate varchar(10) ,
	--@SrcFileName varchar(100),
	----[CreatedDate] datetime],
	--@CreatedBy varchar(50),
	----@LastUpdatedDate datetime,
	--@LastUpdatedBy varchar(50) ,
	@SrcFileName varchar(100),
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@mediatype [varchar](20) NULL,
	@channelobjid [varchar](50) NULL,
	@queuename [varchar](50) NULL,
	@interactionid [varchar](50) NULL,
	@originteractionid [varchar](50) NULL,
	@originationphone [varchar](50) NULL,
	@destinationoriginal [varchar](50) NULL,
	@destinationtranslated [varchar](50) NULL,
	@customername [varchar](50) NULL,
	@caseid [varchar](50) NULL,
	@interactiondirection [varchar](50) NULL,
	@interactiontype [varchar](50) NULL,
	@dialcode [varchar](50) NULL,
	@dialtext [varchar](500) NULL,
	@createtimestamp varchar(50),
	@agentid [varchar](50) NULL,
	@agentname [varchar](50) NULL,
	@accepttimestamp varchar(50),
	@agentaccepttimestamp varchar(50),
	@processtime int,
	@postprocesstime int,
	@totaltime [int] NULL,
	@abandontimestamp varchar(50),
	@agentabandontimestamp varchar(50),
	@voicemessageleft [bit] NULL,
	@recordingfilename [varchar](50) NULL,
	@ivrtreatmenttime varchar(50),
	@transferfrom [varchar](50) NULL,
	@conferencefrom [varchar](50) NULL,
	@maxholdtime [int] NULL,
	@holdcount [int] NULL,
	@totalholdtime [int] NULL,
	@callleg1postdialdelay [int] NULL,
	@callleg2postdialdelay [int] NULL,
	@callleg1answertime [decimal](18, 0) NULL,
	@callleg2answertime [decimal](18, 0) NULL,
	@callleg1sipid [varchar](10) NULL,
	@callleg2sipid [varchar](10) NULL,
	@inboundsipid [varchar](50) NULL,
	@notes [varchar](500) NULL,
	@campaignname [varchar](100) NULL,
	@recordid [varchar](50) NULL,
	@recordstatus [varchar](50) NULL,
	@dispositioncode [varchar](50) NULL,
	@exttransdata [varchar](100) NULL,
	@wrapupcode [varchar](50) NULL,
	@wrapuptext [varchar](100) NULL,
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
    

 
 INSERT INTO [adi].[ACE_8x8ReportLogs]
   (
    [SrcFileName],
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[media-type] ,
	[channel-obj-id] ,
	[queue-name] ,
	[interaction-id] ,
	[orig-interaction-id],
	[origination-phone] ,
	[destination-original] ,
	[destination-translated] ,
	[customer-name] ,
	[case-id] ,
	[interaction-direction] ,
	[interaction-type] ,
	[dial-code] ,
	[dial-text] ,
	[create-timestamp] ,
	[agent-id] ,
	[agent-name] ,
	[accept-timestamp] ,
	[agent-accept-timestamp] ,
	[process-time] ,
	[post-process-time] ,
	[total-time] ,
	[abandon-timestamp] ,
	[agent-abandon-timestamp] ,
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
	[call-leg2-answer-time],
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
	[trans-rec-num] ,
	[is-interaction-completed], 
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
	@originationphone ,
	@destinationoriginal ,
	@destinationtranslated ,
	@customername ,
	@caseid ,
	@interactiondirection ,
	@interactiontype ,
	@dialcode ,
	@dialtext ,
	CASE WHEN @createtimestamp = ''
    THEN NULL
	ELSE CONVERT(datetime, @createtimestamp)
	END ,
	@agentid ,
	@agentname ,
	CASE WHEN @accepttimestamp = ''
    THEN NULL
	ELSE CONVERT(datetime, @accepttimestamp)
	END ,
	CASE WHEN @agentaccepttimestamp = ''
    THEN NULL
	ELSE CONVERT(datetime, @agentaccepttimestamp)
	END ,
	@processtime,
    @postprocesstime,
	@totaltime,
	CASE WHEN @abandontimestamp  = ''
    THEN NULL
	ELSE CONVERT(datetime, @abandontimestamp)
	END, 
	CASE WHEN @agentabandontimestamp  = ''
    THEN NULL
	ELSE CONVERT(datetime, @agentabandontimestamp)
	END, 
	@voicemessageleft ,
	@recordingfilename ,
	@ivrtreatmenttime ,
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
	@transrecnum ,
	@isinteractioncompleted ,
	@Status 
   )
  
END
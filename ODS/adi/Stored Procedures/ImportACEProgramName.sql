-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportACEProgramName](
    --  @loadDate varchar(10)
      @DataDate varchar(10),
      @OriginalFileName varchar(100),
      @SrcFileName varchar(100),
     -- ,[CreatedDate]
      @CreatedBy varchar(100),
      
	--  @LastUpdatedDate]
      @LastUpdatedBy varchar(100),
      @LOB varchar(100),
      @MemberID varchar(100),
      @Program varchar(100),
      @StartDate varchar(10),
      @EndDate  varchar(10),
      @ProductSubgroup  varchar(100),
	  @Status varchar(50)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
 INSERT INTO [adi].[ACEProgramName]
   (
   
       [loadDate]
      ,[DataDate]
      ,[OriginalFileName]
      ,[SrcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[LOB]
      ,[MemberID]
      ,[Program]
      ,[StartDate]
      ,[EndDate]
      ,[ProductSubgroup]
	  ,[AceStatusCode]
    
    )
     VALUES
   (
     GETDATE(),
      @DataDate ,
      @OriginalFileName ,
      @SrcFileName ,
      GETDATE(),
      @CreatedBy,
      GETDATE(),
      @LastUpdatedBy ,
      @LOB,
      @MemberID,
      @Program ,
	  CASE WHEN @StartDate = ''
	  THEN NULL
	  ELSE CONVERT(DATE, @StartDate)
	  END ,
	  CASE WHEN @EndDate = ''
	  THEN NULL
	  ELSE CONVERT(DATE, @EndDate)
	  END ,
      @ProductSubgroup  ,
	  CASE @Status
	  WHEN  '' THEN NULL
	  WHEN 'Active' THEN 1
	  END 
)
  
END


END


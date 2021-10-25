


CREATE PROCEDURE [adw].[z_AceMrnMbrWlcMbrByPcp]
	@loadDate DATE, @ClientKey INT	
AS
	/* #3 POC Load Mrn */
	--Step 1
	DECLARE @adiTableName VARCHAR(25) = 'adi.MbrWlcMbrByPcp';
	--Process load from adi into staging
	INSERT INTO ast.mbrstg2_mbrData
			([mbrFirstName]
           ,[mbrLastName]
           ,[mbrMiddleName]
           ,[mbrDob]
           ,[mbrGENDER]
           ,[mbrMEDICARE_ID]
           ,[mbrMEDICAID_NO]
           ,[AdiKey]  
           ,[SrcFileName]
           --,[Active]
           ,[LoadDate]
           ,[DataDate]
		   ,[MbrState]
		   ,[ClientKey]
		   ,[ClientSubscriberId]
		  )
	 --- DECLARE @adiTableName VARCHAR(25) = 'adi.MbrWlcMbrByPcp' DECLARE @LoadDate DATE = '2021-02-22'
    SELECT --m.Wlc_SUBSCRIBER_ID, mbr.Client_Member_ID ,
        m.FirstName
        ,m.LastName
        ,m.MName
        ,m.BirthDate
        ,m.[Gender]
        ,m.[MedicareID]
        ,CONVERT(numeric, m.[Medicaid_NO]) medicareNo
	   ,m.mbrWlcMbrByPcpKey AS [src_URN] /* use stg urn to make location easy in second step */
        , @AdiTableName AS srcTbl
	   --, 1		    AS isActive
	   , m.LoadDate
	   , m.DataDate	 
	   ,[State]  
	   ,2 AS ClientKey
	   ,Sub_ID
    FROM (SELECT DISTINCT m.Sub_ID, m.mbrWlcMbrByPcpKey, m.FirstName,m.LastName,'' AS MName
		  ,m.BirthDate, 'U' AS Gender, '' medicareId,LoadDate,m.[State]
		  , TRY_CONVERT(numeric, CASE WHEN (m.MEDICAID_NO = '') THEN NULL else m.medicaid_no end ) aS Medicaid_NO, m.DataDate    		  
    		  FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@LoadDate) m
		  WHERE m.BestMemberRow = 1
		  ) M
			 LEFT JOIN adw.MbrMember mbr ON RTRIM(LTRIM(m.SUB_ID)) = mbr.ClientMemberKey
    WHERE mbr.ClientMemberKey is null;
 

 ---Step 2
	/* Identify members to insert into MRN  */
	--Truncate working tables
	TRUNCATE TABLE AceMPI.ast.MPI_SourceTable
	TRUNCATE TABLE AceMPI.ast.MPI_OutputTable

	--  DECLARE @LoadDate DATE = '2021-02-22'
   INSERT INTO [AceMPI].[ast].[MPI_SourceTable] (
			[ClientSubscriberId]
			, [ClientKey]
			, [MstrMrnKey]
			, [mbrLastName]
			, [mbrFirstName]
			, [mbrMiddleName]
			, [mbrGENDER]
			, [mbrDob]
			, [SrcFileName]
			, [AdiTableName]
			, [ExternalUniqueID]
			, [MbrState]
			, [DataDate]) 
    SELECT	[ClientSubscriberId]
			, [ClientKey]
			, [MstrMrnKey]
			, [mbrLastName]
			, [mbrFirstName]
			, [mbrMiddleName]
			, [mbrGENDER]
			, [mbrDob]
			, [SrcFileName]
			, [AdiTableName]
			, [AdiKey]				AS [ExternalUniqueID]
			, [MbrState]
			, [DataDate]
	FROM	[ACECAREDW].[ast].[MbrStg2_MbrData]
	WHERE	LoadDate = (	SELECT MAX(LoadDate) 
								FROM [ACECAREDW].[ast].[MbrStg2_MbrData]
								WHERE ClientKey = 2
							)
	AND			ClientKey = 2

	--Step 3
		-- Run Load_MPI_MasterJob algorithm to Generate Mstrmrnkeys for members
			IF (SELECT COUNT(*) FROM [AceMPI].[ast].[MPI_SourceTable]) >= 1
			EXECUTE ACEMPI.adw.[Load_MasterJob_MPI]

			BEGIN
			
			--Update stg table with the mstrmrnkeys
			--	BEGIN TRAN				-- rollback -- COMMIT
			UPDATE		ACECAREDW.ast.MbrStg2_MbrData
			SET			MstrMrnKey = z.MstrMrn
			-- SELECT		z.ClientSubscriberId,a.ClientKey,MstrMrn,a.MstrMrnKey,a.ClientSubscriberId,z.ClientKey --a.ExternalUniqueID,b.ExternalUniqueID,
			FROM		ACECAREDW.ast.MbrStg2_MbrData a
			JOIN		(	SELECT		ClientSubscriberId, ClientKey,a.ExternalUniqueID,b.ExternalUniqueID bExternalUniqueID
										,MstrMrnKey,MstrMrn
							FROM		AceMPI.ast.MPI_SourceTable a
							JOIN		AceMPI.ast.MPI_OutputTable b
							ON			a.ExternalUniqueID = b.ExternalUniqueID
						)z
			ON			a.ClientSubscriberId = z.ClientSubscriberId
			WHERE		a.ClientKey = 2
			AND			LoadDate =  (	SELECT	MAX(LoadDate) 
										FROM	ACECAREDW.ast.MbrStg2_MbrData 
										WHERE	ClientKey = 2
									)

		END

		

	

/* insert into mbr 
    JOIn mrn to member by pcp on src urn and filter for today's inserts
     */ 
	/* this code would be replaced with a full member load */
/*    INSERT INTO [adw].[A_Mbr_Members]
           ([A_MSTR_MRN]
           ,[Client_Member_ID]
           ,[A_Client_ID])
    SELECT 
	   mrn.A_MSTR_MRN
	   ,  m.Wlc_SUBSCRIBER_ID 
	   , c.[A_Client_ID]
    FROM adw.A_MSTR_MPI mrn
	   JOIN dbo.Wlc_MembersByPCP m ON mrn.src_URN = m.URN
	   JOIN adw.A_List_Clients c ON 1 = 1
    WHERE mrn.A_CREATED_DATE >= DATEADD(day, -1, GETDATE());
    */
/* 3. update src id 
    This can be run after the Import to ADW */ 

    /*
    SELECT 
	   mrn.A_MSTR_MRN
	   ,  m.Wlc_SUBSCRIBER_ID 
	   , c.[A_Client_ID]
    FROM adw.A_MSTR_MPI mrn
	   JOIN dbo.Wlc_MembersByPCP m ON mrn.src_URN = m.URN
	   JOIN adw.A_List_Clients c ON 1 = 1
    WHERE mrn.A_CREATED_DATE >= DATEADD(day, -1, GETDATE());

    */

	--- DECLARE @adiTableName VARCHAR(25) = 'adi.MbrWlcMbrByPcp' DECLARE @LoadDate DATE = '2021-02-22'
	
		  ----SELECT * FROM ast.mbrstg2_mbrData WHERE CLIENTKEY = 2

		  --- select * from  adi.tvf_PdwSrc_Wlc_MemberByPcp('2021-02-22')
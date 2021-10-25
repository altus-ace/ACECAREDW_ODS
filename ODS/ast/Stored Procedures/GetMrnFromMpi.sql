-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ast].[GetMrnFromMpi]
AS
BEGIN
    /* PURPOSE: 
	   1. Staged Mbrs into MRN Input table, AlL Members in "loaded" status.
	   2. execute mrn Match/Create
	   3. update Stged members with Matched/Created MRN
	   
    */
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    /* Load to aceMPI Source table */
     SELECT * FROM AceMpi.ast.MPI_SOURCETABLE trg
	   /* add a log call here */    
    MERGE AceMpi.ast.MPI_SOURCETABLE trg
    USING (SELECT 
		  Stg.ClientSubscriberID, Stg.ClientKey, 
		  Stg.MbrLastName AS mbrLastName, Stg.MbrFirstName as mbrFirstName, Stg.mbrMiddleName, 
		  Stg.mbrSSN, Stg.MbrGender, Stg.mbrDob,
		  Stg.mbrMEDICAID_NO, Stg.mbrMEDICARE_ID, Stg.HICN, Stg.MBI, '' AS AltMemberID1, '' AS AltMemberID2,           
		  Stg.mbrEthnicity, Stg.mbrRace,  Stg.mbrPrimaryLanguage,          
		  Stg.MbrState,
		  Stg.prvNPI, Stg.prvTIN,  Stg.prvAutoAssign, Stg.prvClientEffective, Stg.prvClientExpiration,              
		  Stg.plnProductPlan,  Stg.plnProductSubPlan,  Stg.plnProductSubPlanName,  Stg.plnMbrIsDualCoverage, Stg.plnClientPlanEffective,                 
		  Stg.rspLastName, Stg.rspFirstName, Stg.rspAddress1, Stg.rspAddress2, Stg.rspCITY, Stg.rspSTATE, Stg.rspZIP, Stg.rspPhone,                 
		  Stg.SrcFileName,                
		  Stg.AdiTableName,          
		  Stg.AdiKey,              
		  Stg.LoadDate,          
		  Stg.DataDate,                 
		  Stg.mbrStg2_MbrDataUrn  AS ExternalUniqueID /* Using the local staging key to be the unique key */
		 FROM [ast].[MbrStg2_MbrData] Stg
		 WHERE stg.stgRowStatus = 'Loaded'
		 ) src
    ON trg.ExternalUniqueID = src.ExternalUniqueID
        AND trg.LoadDate = src.LoadDate
    WHEN NOT MATCHED BY TARGET THEN 
        INSERT (ClientSubscriberId,  ClientKey,           
    			 mbrLastName,  mbrFirstName, mbrMiddleName,          
    			 mbrSSN, mbrGENDER, mbrDob,      
    			 mbrMEDICAID_NO, mbrMEDICARE_ID, HICN, MBI, AltMemberID1, AltMemberID2,          
    			 mbrEthnicity, mbrRace,  mbrPrimaryLanguage,      
			 mbrState, 
    			 prvNPI, prvTIN,  prvAutoAssign, prvClientEffective, prvClientExpiration,          
    			 plnProductPlan,  plnProductSubPlan,  plnProductSubPlanName,  plnMbrIsDualCoverage, plnClientPlanEffective,             
    			 rspLastName, rspFirstName, rspAddress1, rspAddress2, rspCITY, rspSTATE, rspZIP, rspPhone,             
    			 SrcFileName,            
    			 AdiTableName,      
    			 AdiKey,          
    			 LoadDate,      
    			 DataDate,             
    			 ExternalUniqueID  )
        VALUES (src.ClientSubscriberId,  src.ClientKey,           
    			 src.mbrLastName,  src.mbrFirstName, src.mbrMiddleName,          
    			 src.mbrSSN, src.mbrGENDER, src.mbrDob,      
    			 src.mbrMEDICAID_NO, src.mbrMEDICARE_ID, src.HICN, src.MBI, src.AltMemberID1, src.AltMemberID2,          
    			 src.mbrEthnicity, src.mbrRace,  src.mbrPrimaryLanguage,      
			 src.MbrState,
    			 src.prvNPI, src.prvTIN,  src.prvAutoAssign, src.prvClientEffective, src.prvClientExpiration,          
    			 src.plnProductPlan,  src.plnProductSubPlan,  src.plnProductSubPlanName,  src.plnMbrIsDualCoverage, src.plnClientPlanEffective,             
    			 src.rspLastName, src.rspFirstName, src.rspAddress1, src.rspAddress2, src.rspCITY, src.rspSTATE, src.rspZIP, src.rspPhone,             
    			 src.SrcFileName,            
    			 src.AdiTableName,      
    			 src.AdiKey,          
    			 src.LoadDate,      
    			 src.DataDate,             
    			 src.ExternalUniqueID  )
	   ;
    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
    /* Execute MPI Job */      
    
    EXECUTE AceMPI.[adw].[Load_MasterJob_MPI] ;

    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
    /* Get Result from Staging Output Table */
    
    /* XXXXXXXX TO DO XXXXXXXXX*/
	   /* add a log call here */
    MERGE ast.MbrStg2_MbrData trg     
    USING (SELECT mpiOut.MstrMrn, mpiOut.ExternalUniqueID --, mbrStg.mbrStg2_MbrDataUrn , mbrstg.mstrMrnKey
		  FROM AceMpi.ast.MPI_OutputTable mpiOut
			 LEFT JOIN ast.MbrStg2_MbrData mbrStg ON mpiOut.ExternalUniqueID = mbrStg.mbrStg2_MbrDataUrn
		  ) src 
    ON trg.mbrStg2_MbrDataUrn = src.ExternalUniqueID 
    WHEN MATCHED THEN 
    UPDATE SET 
	   trg.mstrMrnKey = src.MstrMrn    
        ;   
	   
    /* for every record loaded into out put that was updated, delete from input table */
    DELETE SrcIn 
    --SELECT SrcIn.AdiTableName, SrcIn.ExternalUniqueID 
    FROM AceMPI.ast.MPI_SourceTable SrcIn
	   JOIN AceMpi.ast.MPI_OutputTable MpiOut ON SrcIn.AdiTableName = MpiOut.AdiTableName AND SrcIn.ExternalUniqueID = MpiOut.ExternalUniqueID
	   JOIN ast.MbrStg2_MbrData mbrStg ON MpiOut.ExternalUniqueID = mbrStg.mbrStg2_MbrDataUrn
	   ;
		
	
	 
    
END

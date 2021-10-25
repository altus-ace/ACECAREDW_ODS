

CREATE Function [adi].[tvf_pdwSrc_CopUhcPcor] (
    @LoadDate Date
    )
    /* Pdw: process data warehouse, src: Load Source     */
    RETURNS TABLE 
AS 
RETURN

    SELECT     PcorData.[MemberID]
    		,PcorData.[DateOfLastService]
    		,PcorData.[IncentiveProgram]		
    		,PcorData.HealthPlanName
    		,PcorData.Product
    		,PcorData.AdiKey
    		,PcorData.[loadDate]
    		,PcorData.[SrcFileName]
    		,PcorData.CopMsrStatus
    		,PcorData.CopMsrName AS CopMsrName
    		,PcorData.[DataDate] as QM_Date
    		,PcorData.Destination /* To concatenate Destination so as to mapped Data running downstream*/
    		,pcorData.QM_ID
    		,PcorData.DataDate
    		,PcorData.AdiTableName
    		,PcorData.Destination as srcMeasureDesc
    		, '' srcMeasureID
    FROM [adi].[vw_pdwSrc_CopUhcPcor] pcorData    
    WHERE PcorData.MemberID <> '' 
        AND ISNULL(PcorData.CopMsrStatus, '') <> ''    
        AND PcorData.DataDate = @LoadDate
        AND PcorData.IncentiveProgram = 'ACO' /* this is a business rule, for client we only want to include all rows for ACO incentives, we are an aco, the others are not our QM members */
        ;
    

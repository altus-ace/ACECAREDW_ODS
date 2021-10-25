CREATE PROCEDURE [ast].[Pst_MbrStagingValidation] (@CLIENTKEY INT )


AS 

    
BEGIN    

    EXEC [ast].[p_LoadMstrMrnISNotValidValidationWorkTable]		   @clientKey;
    EXEC [ast].[p_LoadNPIStgngCheckValidationWorkTable]		   @clientKey;
    EXEC [ast].[p_LoadPhnMmbrsInMmbrDtlNotNullValidationWorkTable]  @clientKey;
    EXEC [ast].[p_LoadPlanMAppingCheckValidationWorkTable]		   @clientKey;
    EXEC [ast].[p_LoadPlanStatusValidationWorkTable]			   @clientKey;
    EXEC [ast].[p_LoadPrvTinNotNullValidationWorkTable]		   @clientKey;
    
END

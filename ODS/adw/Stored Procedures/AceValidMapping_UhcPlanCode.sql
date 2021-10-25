CREATE PROCEDURE adw.AceValidMapping_UhcPlanCode
AS 
    /* validation for subgroup mapping */
    SELECT 'Lst' MappintType, src.SUBGRP_ID , a.Destination
    FROM (SELECT distinct m.SUBGRP_ID
    	   FROM dbo.Uhc_membersbyPcp m
    	   where A_LAST_UPDATE_FLAG = 'Y') src
        LEFT JOIN lst.ListAceMapping a
    	   ON src.SUBGRP_ID = a.Source
    		  and a.MappingTypeKey =1
    WHERE a.destination is null
    union
    SELECT 'dbo' MappintType, src.SUBGRP_ID , a.DESTINATION_VALUE
    FROM (SELECT distinct m.SUBGRP_ID
    	   FROM dbo.Uhc_membersbyPcp m
    	   where A_LAST_UPDATE_FLAG = 'Y') src
        LEFT JOIN dbo.ALT_MAPPING_TABLES a 	
    	   ON src.SUBGRP_ID = a.SOURCE_VALUE
    		  and a.SOURCE = 'UHC'
    		  and a.DESTINATION = 'ALTRUISTA'
    WHERE a.destination is null

     
/* 

this code will insert a single value for the given input values into  2 mapping tables 
    DECLARE @SrcValue VARCHAR(10) = 'D002'

    DECLARE @ClientKey int = 1;
    DECLARE @MappingTypeKey INT = 1;
    DECLARE @IsActive tinyInt   = 1;
    DECLARE @Source VARCHAR(50) = @srcValue;
    DECLARE @Destination VARCHAR(50) = @srcValue;
    
    DECLARE @dSource VARCHAR(10) = 'UHC';
    DECLARE @dDest VARCHAR(10) = 'ALTRUISTA';
    -- when blah
    DECLARE @TYPE VARCHAR(20) = 'PLAN CODE';
    
    INSERT INTO dbo.ALT_MAPPING_TABLES (Source, Destination, Type, Source_Value, Destination_Value)
    VALUES (@dSource, @dDest, @Type, @Source, @Destination);
    
    INSERT INTO lst.ListAceMapping  (ClientKey, MappingTypeKey, IsActive, Source, Destination)
    VALUES (@ClientKey, @MappingTypeKey, @IsActive, @Source, @Destination);

    */


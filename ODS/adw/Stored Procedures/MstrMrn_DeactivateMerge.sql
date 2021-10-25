CREATE PROCEDURE adw.MstrMrn_DeactivateMerge(
    @KeyToKeepActive NUMERIC(15,0)
    , @KeyToDeactivate NUMERIC(15,0)
    )
AS 
    /* add checks and logging. */

    DECLARE @lKtoKeep NUMERIC(15,0) = @KeyToKeepActive;
    DECLARE @lKtoKill NUMERIC(15,0) = @KeyToDeactivate;

    --select top 1 * from adw.mstrmrn 
    Update adw.MstrMrn  SET 
	     Active = 0
	   , MergeToMrn = @lKtoKeep
	   WHERE mstrMrnKey = @lKtoKeep;

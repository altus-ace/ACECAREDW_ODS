CREATE procedure [dbo].[execute_ssis_package_sample]
 @output_execution_id varchar output
as
begin
declare @execution_id bigint
 exec ssisdb.catalog.create_execution 
  @folder_name = 'Notification'
 ,@project_name = 'exec-ssis-stored-proc-ssis-sample'
 ,@package_name = 'Sample.dtsx'
 ,@execution_id = @execution_id output
 exec ssisdb.catalog.start_execution @execution_id
 set @output_execution_id = CONVERT(varchar, @execution_id)
end
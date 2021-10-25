

CREATE FUNCTION [dbo].[tvf_Phlebotomist_labResults](@month int, @year int)
RETURNS TABLE
AS
    RETURN
(
SELECT distinct c.ProviderID,
       c.ProviderName,
       c.NPI,
       c.NPIName,
      a.PCPADDRESS,
       c.MemberName,
       'Jesus Phlebotomist' AS Staff,
       c.Subscriber,
       c.MedicareID,
       c.DOB,
       c.Phone,
       a.MEMBER_HOME_ADDRESS AS Address,
       c.Measure,
       c.Category,
       c.ServiceStartDate,
       c.ServiceEndDate,
	  'LAB' As AppointmentType,
	  '' as AppointmentDate,
	  '' as AppointmentNotes,
	  '' as 'AppointmentStatus(Pending\Scheduled\Completed)',
	  ''	as 'HBA1c Value',
	  '' as 'Monitor Nephrophaty value'
   FROM tmpWLC_Careopps c
     INNER JOIN 	(
	select * from (select Member_id, PCP_Name as PCPName,concat(LTRIM(RTRIM(PCP_ADDRESS)),
	   '', LTRIM(RTRIM(PCP_ADDRESS2)),
	    ',', LTRIM(RTRIM(PCP_CITY)), 
	    ',', LTRIM(RTRIM(PCP_STATE)), 
	    ',', LTRIM(RTRIM(PCP_ZIP_C))) AS PCPAddress,MEMBER_HOME_ADDRESS,
	    row_Number() over(Partition by Member_id order by MEMBER_HOME_ADDRESS desc) as arn
	      from vw_ActiveMembers where client='WLC')as ss where ss.arn=1
)a ON a.Member_id = c.subscriber 
WHERE c.Measure IN('Diabetes HbA1c Test', 'Diabetes Monitor Nephropathy')
     AND convert(int,MONTH(convert(date,c.A_LAST_UPDATE_DATE))) = @month
     AND convert(int,YEAR(convert(date,c.A_LAST_UPDATE_DATE))) = @year
	and c.ComplianceStatus='Non-Compliant'
	);

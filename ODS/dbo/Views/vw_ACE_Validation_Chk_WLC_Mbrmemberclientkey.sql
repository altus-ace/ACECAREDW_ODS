
CREATE view [dbo].[vw_ACE_Validation_Chk_WLC_Mbrmemberclientkey]
AS

SELECT  distinct p.sub_id,m.ClientMemberKey,m.LoadDate as mbrmemberloaddate,p.LoadDate  as adiloaddate
    FROM  ACECAREDW.adi.[MbrWlcMbrByPcp] p 
    left join acecaredw.[adw].[MbrMember] m on m.ClientMemberKey=p.sub_id
         INNER JOIN [ACECAREDW].[lst].[List_Client] lc ON lc.Clientkey = m.clientkey
	    where month(p.LoadDate)=MONTH(getdate()) and YEAR(p.loaddate)= YEAR(getdate()) and lc.ClientKey=2 
	    and m.ClientMemberKey is null

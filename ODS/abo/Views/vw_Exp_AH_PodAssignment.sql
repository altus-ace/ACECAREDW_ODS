
CREATE VIEW [abo].[vw_Exp_AH_PodAssignment]
AS 
    SELECT p.CLIENT_ID, 
       p.Zipcode, 
       p.POD
    FROM vw_AH_PodAssignment p;


create view vw_frequent_diagcode_pivot as
SELECT member_id ,isnull([1],null) as freq1, isnull([2],null)as freq2, isnull([3],null)as freq3, isnull([4],null)as freq4,isnull([5],null)as freq5  
FROM  
(SELECT rowNumber, member_id, diagCode
    FROM acecaredw_test.dbo.vw_frequent_diag_1_and_2 )  AS SourceTable  
PIVOT  
(  
max(diagCode)
FOR SourceTable.rowNumber IN ([1], [2], [3], [4],[5])  
) AS PivotTable; 
create view vw_frequent_diagcodename_1_and_2_pivot as
SELECT member_id ,isnull([1],null) as freq1code, isnull([2],null)as freq2code
, isnull([3],null)as freq3code, isnull([4],null)as freq4code,isnull([5],null)as freq5code  
FROM  
(SELECT rowNumber, member_id, value_code_name
    FROM acecaredw_test.dbo.vw_frequent_diag_1_and_2 )  AS SourceTable  
PIVOT  
(  
max(value_code_name)
FOR SourceTable.rowNumber IN ([1], [2], [3], [4],[5])  
) AS PivotTable; 
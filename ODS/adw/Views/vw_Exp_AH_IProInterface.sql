CREATE VIEW adw.vw_Exp_AH_IProInterface
AS 
    SELECT I.MEMBER_ID, 
       I.CLIENT_ID, 
       I.MEMBER_FIRST_NAME, 
       I.MEMBER_LAST_NAME, 
       I.DATE_OF_BIRTH, 
       I.GENDER, 
       I.RISK_CATEGORY_C, 
       I.RISK_TYPE, 
       I.RISK_SCORE, 
       I.GC_START_DATE, 
       I.GC_END_DATE
FROM vw_AH_IProInterface I;

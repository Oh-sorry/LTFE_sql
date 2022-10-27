-------------------------------------------------------------------------------------------------------------------------------------------
SELECT B.사번,
       B.사원명,
       NVL(A.전공, ' ')   AS 전공,
       NVL(A.졸업일자, ' ') AS 졸업일자
FROM   (SELECT  a.pern_no       AS 사번,
                a.gradu_date2   AS 졸업일자,
                a.special_study AS 전공
       FROM     hsc100t a
       GROUP BY a.pern_no
       )
       A,
       (SELECT b.pern_no AS 사번,
               b.NAME    AS 사원명
       FROM    hpa100t b
       )
       B
WHERE  A.사번(+)=B.사번 ;

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------수정---------------------------------------------------------
SELECT   B.pern_no,
         B.NAME,
         NVL(C.detail_code_name, ' ')                                           AS SCH,
         NVL(d.detail_code_name, ' ')                                           AS GRADU,
         c.detail_code                                                          AS 학력코드,
         d.detail_code                                                          AS 졸업구분코드,
         ROW_NUMBER() over (partition BY B.pern_no ORDER BY A.gradu_date2 DESC) AS RAN
FROM     hpa100t B
         LEFT JOIN hsc100t A
         ON       A.pern_no = B.pern_no
         LEFT JOIN bco100t C
         ON       C.com_code IN ('H009')
         AND      A.schship_code=C.detail_code
         LEFT JOIN bco100t D
         ON       D.com_code IN ('H010')
         AND      A.gradu_code=D.detail_code ;

--------------------------------------------------------------------------------------------------------------
SELECT PERN_NO,
       NAME,
       SCH,
       GRADU
FROM   (SELECT  B.pern_no,
                B.NAME,
                NVL(C.detail_code_name, ' ')                                           AS SCH,
                NVL(d.detail_code_name, ' ')                                           AS GRADU,
                c.detail_code                                                          AS SCH_CODE,
                d.detail_code                                                          AS GRADU_CODE,
                ROW_NUMBER() over (partition BY B.pern_no ORDER BY A.gradu_date2 DESC) AS ROW_NO
       FROM     hpa100t B
                LEFT JOIN hsc100t A
                ON       A.pern_no = B.pern_no
                LEFT JOIN bco100t C
                ON       C.com_code IN ('H009')
                AND      A.schship_code=C.detail_code
                LEFT JOIN bco100t D
                ON       D.com_code IN ('H010')
                AND      A.gradu_code=D.detail_code
       )
WHERE  ROW_NO = 1 ;
--------------------------------------------------------------------------------------------------------------
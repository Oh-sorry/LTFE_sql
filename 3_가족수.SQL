-------------------------------------------------------------------------------------------------------------------------------------------
SELECT B.pern_no     AS 사번,
       B.NAME        AS 사원이름,
       NVL(A.cnt, 0) AS 가족수
FROM   (SELECT  a.pern_no,
                SUM(
                CASE
                         WHEN a.rel_code IS NOT NULL
                         THEN 1
                         ELSE 0
                END) AS cnt
       FROM     hpa130t a
       GROUP BY a.pern_no
       )
       A,
       (SELECT b.pern_no,
               b.name
       FROM    hpa100t b
       )
       B
WHERE  B.pern_no=A.pern_no (+) ;

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------수정-----------------------------------------------
SELECT   A.PERN_NO         AS EM_NO,
         A.NAME            AS EM_NA,
         COUNT(B.rel_code) AS FA_COUNT
FROM     hpa100t a
         LEFT JOIN hpa130t b
         ON       A.PERN_NO (+) = B.PERN_NO
GROUP BY A.PERN_NO;

----------------------------------------------------------------------------------------

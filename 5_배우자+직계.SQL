--------------------------------------------------------------------------------------------------
SELECT A.pern_no,
       G.NAME,
       G.join_date,
       A.spa_yn,
       B.dep_cnt,
       C.lin_cnt
FROM   (SELECT  d.pern_no,
                SUM(
                CASE
                         WHEN d.rel_code IN ('1')
                         THEN '1'
                         ELSE '0'
                END) AS spa_yn
       FROM     hpa130t d
       GROUP BY d.pern_no
       )
       A,
       (SELECT  e.pern_no,
                SUM(
                CASE
                         WHEN e.rel_code IN ('3',
                                             '4',
                                             '9',
                                             '10',
                                             '12',
                                             '13')
                         THEN '1'
                         ELSE '0'
                END) AS dep_cnt
       FROM     hpa130t e
       GROUP BY e.pern_no
       )
       B,
       (SELECT  f.pern_no,
                SUM(
                CASE
                         WHEN f.rel_code IN ('2',
                                             '11')
                         THEN '1'
                         ELSE '0'
                END) AS lin_cnt
       FROM     hpa130t f
       GROUP BY f.pern_no
       )
       C,
       hpa100t G
WHERE  A.pern_no = B.pern_no
AND    B.pern_no = C.pern_no
AND    C.pern_no = G.pern_no ;

-------------------------------------------------------------------------------------------------
--- 배우자
SELECT   d.pern_no,
         SUM(
         CASE
                  WHEN d.rel_code IN ('1')
                  THEN '1'
                  ELSE '0'
         END) AS spa_yn
FROM     hpa130t d
GROUP BY d.pern_no ;

--- 직계 존속
SELECT   e.pern_no,
         SUM(
         CASE
                  WHEN e.rel_code IN ('3',
                                      '4',
                                      '9',
                                      '10',
                                      '12',
                                      '13')
                  THEN '1'
                  ELSE '0'
         END) AS dep_cnt
FROM     hpa130t e
GROUP BY e.pern_no ;

--- 직계 비속
SELECT   f.pern_no,
         SUM(
         CASE
                  WHEN f.rel_code IN ('2',
                                      '11')
                  THEN '1'
                  ELSE '0'
         END) AS lin_cnt
FROM     hpa130t f
GROUP BY f.pern_no ;
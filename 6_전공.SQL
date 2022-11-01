------------------------------------------------------------------------------------------------------------------------
SELECT   a.pern_no,
         D.NAME,
         d.join_date,
         d.retr_date,
         b.detail_code_name,
         a.special_study,
         a.gradu_date1,
         a.gradu_date2
FROM     hsc100t a,
         bco100t b,
         bco100t c,
         hpa100t d
WHERE    (
                  a.pern_no, a.schship_code
         )
         IN
         (SELECT  pern_no,
                  MAX(schship_code)
         FROM     hsc100t a
         WHERE    schship_code NOT IN ('99')
         GROUP BY pern_no
         )
AND      a.schship_code = b.detail_code
AND      b.com_code     = 'H009'
AND      a.schship_code IN ('5',
                            '6')
AND      a.gradu_code = c.detail_code
AND      c.com_code   = 'H010'
AND      a.gradu_code IN ('4')
AND      a.pern_no = d.pern_no
AND
         (
                  a.special_study LIKE '%컴퓨터%' OR a.special_study LIKE '%전자%' OR a.special_study LIKE '%통신%' OR a.special_study LIKE '%정보%' OR a.special_study LIKE '%전기%' OR a.special_study LIKE '%전산%' OR a.special_study LIKE '%인터넷%' OR a.special_study LIKE '%프로그래밍%' OR a.special_study LIKE '%소프트웨어%' OR a.special_study LIKE '%미디어%' OR a.special_study LIKE '%디지털%' OR a.special_study LIKE '%게임%'
         )
ORDER BY a.pern_no
;
------------------------------------------------------------------------------------------------------------------------

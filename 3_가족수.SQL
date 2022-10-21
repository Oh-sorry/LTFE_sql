-------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	B.pern_no AS 사번, B.NAME AS 사원이름, NVL(A.cnt, 0) AS 가족수
FROM
	(SELECT a.pern_no, SUM(CASE WHEN a.rel_code IS NOT NULL THEN 1 ELSE 0 END) AS cnt FROM hpa130t a GROUP BY a.pern_no) A,
	(SELECT b.pern_no, b.name FROM hpa100t b) B
WHERE B.pern_no=A.pern_no (+)
;
-------------------------------------------------------------------------------------------------------------------------------------------
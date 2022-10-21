-------------------------------------------------------------------------------------------------------------------------------------------
SELECT dp_code, B.dep_name AS 부서명, A.cnt AS 인원수
FROM
(SELECT SUBSTR(a.dept_code, 1, 2) AS dp_code, SUM(CASE WHEN a.retr_date='' THEN 0 ELSE 1 END) AS cnt FROM hpa100t a GROUP BY dp_code) A,
(SELECT SUBSTR(b.detail_code, 1, 2) AS dep_code, b.detail_code_name AS dep_name FROM bco100t b WHERE b.com_code='H002' GROUP BY dep_code) B
WHERE A.dp_code = B.dep_code
;
-------------------------------------------------------------------------------------------------------------------------------------------

--전체 목록
SELECT SUBSTR(a.detail_code_name, 1,
		CASE WHEN INSTR(a.detail_code_name, ' ') = '' THEN INSTR(a.detail_code_name,  '본부', -1)
			ELSE INSTR(a.detail_code_name, ' ')
		END
	) AS 소속부서, SUBSTR(a.detail_code, 1, 2) AS 소속코드, b.pern_no AS 사번, B.NAME AS 성명
FROM bco100t a JOIN hpa100t b ON a.detail_code=b.dept_code
WHERE a.com_code='H002'
ORDER BY 소속코드 ASC
;

--부서별 직원 현황
SELECT
	DISTINCT(SUBSTR(a.detail_code, 1, 2)) AS 소속코드,
	SUBSTR(a.detail_code_name, 1,
		CASE WHEN INSTR(a.detail_code_name, ' ') = '' THEN INSTR(a.detail_code_name,  '본부', -1)
			ELSE INSTR(a.detail_code_name, ' ')
		END
	) AS 소속부서,
	COUNT(b.pern_no) AS 부서별직원수
FROM bco100t a JOIN hpa100t b ON a.detail_code=b.dept_code
WHERE (SELECT COUNT(*) FROM bco100t a, hpa100t b WHERE SUBSTR(a.detail_code, 1, 2) = SUBSTR(b.dept_code, 1, 2)) != 0
AND a.com_code = 'H002'
GROUP BY 소속코드
;

-- 현황
SELECT
	DISTINCT(SUBSTR(c.dept_code, 1, 2)) AS 소속코드,
	SUBSTR(d.detail_code_name, 1,
		CASE WHEN INSTR(d.detail_code_name, ' ') = ' ' THEN INSTR(d.detail_code_name,  '본부', -1)
			ELSE INSTR(d.detail_code_name, ' ')
		END
	)
	AS 소속부서,
	(SELECT COUNT(*) FROM hpa100t a WHERE a.retr_date!=''
		AND CASE
			WHEN SUBSTR(a.dept_code, 1, 2) = '50' THEN (SUBSTR(c.dept_code, 1, 3)=SUBSTR(a.dept_code, 1, 3))
			ELSE (SUBSTR(c.dept_code, 1, 2)=SUBSTR(a.dept_code, 1, 2))
		END
	)
	AS 퇴직자수,
	(SELECT COUNT(*) FROM hpa100t b WHERE b.retr_date='' AND SUBSTR(c.dept_code, 1, 2)=SUBSTR(b.dept_code, 1, 2)) AS 재직자수,
	COUNT(c.pern_no) AS 부서별전체직원수,
	(SELECT COUNT(*) FROM hpa100t a WHERE a.retr_date!=''
		AND CASE
			WHEN SUBSTR(a.dept_code, 1, 2) = '50' THEN (SUBSTR(c.dept_code, 1, 3)=SUBSTR(a.dept_code, 1, 3))
			ELSE (SUBSTR(c.dept_code, 1, 2)=SUBSTR(a.dept_code, 1, 2))
		END
	)+(SELECT COUNT(*) FROM hpa100t b WHERE b.retr_date='' AND SUBSTR(c.dept_code, 1, 2)=SUBSTR(b.dept_code, 1, 2))-COUNT(c.pern_no)
	AS 누락직원수
FROM bco100t d JOIN hpa100t c ON d.detail_code=c.dept_code
WHERE (SELECT COUNT(*) FROM bco100t a, hpa100t b WHERE SUBSTR(a.detail_code, 1, 2) = SUBSTR(b.dept_code, 1, 2)) != 0
AND d.com_code='H002'
GROUP BY 소속코드
;
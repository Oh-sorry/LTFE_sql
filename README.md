# LTFE_sql

--------------------------------------------------------------------------------
1. 연도별 입퇴사자 COUNT
--------------------------------------------------------------------------------
SELECT join_yyyy AS 연도, A.입사자, B.퇴사자
FROM
	(SELECT SUBSTRING(a.join_date, 1, 4)AS join_yyyy, COUNT(a.join_date) AS 입사자
		FROM hpa100t a
		GROUP BY join_yyyy) A,
	(SELECT SUBSTRING(a.retr_date, 1, 4) AS retr_yyyy, COUNT(a.retr_date) AS 퇴사자
		FROM hpa100t a
		GROUP BY retr_yyyy) B
	WHERE A.join_yyyy=B.retr_yyyy (+)
;

--------------------------------------------------------------------------------
2. 부서별 재직인원 수 COUNT
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT dp_code, B.dep_name AS 부서명, A.cnt AS 인원수
FROM
(SELECT SUBSTR(a.dept_code, 1, 2) AS dp_code, SUM(CASE WHEN a.retr_date='' THEN 0 ELSE 1 END) AS cnt FROM hpa100t a GROUP BY dp_code) A,
(SELECT SUBSTR(b.detail_code, 1, 2) AS dep_code, b.detail_code_name AS dep_name FROM bco100t b WHERE b.com_code='H002' GROUP BY dep_code) B
WHERE A.dp_code = B.dep_code
;
-------------------------------------------------------------------------------------------------------------------------------------------
3. 사원별 가족 수 COUNT
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT
	B.pern_no AS 사번, B.NAME AS 사원이름, NVL(A.cnt, 0) AS 가족수
FROM
	(SELECT a.pern_no, SUM(CASE WHEN a.rel_code IS NOT NULL THEN 1 ELSE 0 END) AS cnt FROM hpa130t a GROUP BY a.pern_no) A,
	(SELECT b.pern_no, b.name FROM hpa100t b) B
WHERE B.pern_no=A.pern_no (+)
;
-------------------------------------------------------------------------------------------------------------------------------------------
4. 재직 사원 별 최종 학력
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT B.사번, B.사원명, NVL(A.전공, ' ') AS 전공, NVL(A.졸업일자, ' ') AS 졸업일자
FROM
(SELECT a.pern_no AS 사번, a.gradu_date2 AS 졸업일자, a.special_study AS 전공 FROM hsc100t a GROUP BY a.pern_no) A,
(SELECT b.pern_no AS 사번, b.NAME AS  사원명 FROM hpa100t b) B
WHERE A.사번(+)=B.사번
;-------------------------------------------------------------------------------------------------------------------------------------------

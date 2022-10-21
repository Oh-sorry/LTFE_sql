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

SELECT * FROM hpa100t a ORDER BY a.join_date DESC;
SELECT * FROM hpa100t a ORDER BY a.retr_date DESC;

--입사--
SELECT SUBSTRING(a.join_date, 1, 4)AS join_yyyy, COUNT(a.join_date) AS 입사자
FROM hpa100t a
GROUP BY join_yyyy;

--퇴사
SELECT SUBSTRING(a.retr_date, 1, 4) AS retr_yyyy, COUNT(a.retr_date) AS 퇴사자
FROM hpa100t a
GROUP BY retr_yyyy;
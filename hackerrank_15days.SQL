WITH CTE1 AS (
SELECT
    SUBMISSION_DATE,
    HACKER_ID,
    ROW_NUMBER () OVER (PARTITION BY submission_date, hacker_id ORDER BY submission_date, hacker_id)  as rw_max_per_day,
    DENSE_RANK () OVER (ORDER BY submission_date) as dr_month,
    DENSE_RANK () OVER (PARTITION BY hacker_id ORDER BY submission_date) as dr_hacker_per_day
FROM SUBMISSIONS
ORDER BY submission_date, hacker_id), CTE2 AS (
SELECT
    submission_date,
    COUNT(DISTINCT hacker_id) cnt_total
FROM CTE1
WHERE dr_month = dr_hacker_per_day
GROUP BY submission_date), CTE3 AS (
SELECT
    submission_date,
    MAX(rw_max_per_day) max_per_day
FROM CTE1
GROUP BY submission_date), CTE4 as (
SELECT
    c1.submission_date,
    c2.cnt_total,
    c1.hacker_id,
    ROW_NUMBER () OVER (PARTITION BY c1.submission_date ORDER BY c1.submission_date, c1.hacker_id) as rw
FROM CTE1 c1
JOIN CTE2 c2 ON c1.Submission_date = c2.submission_date
JOIN CTE3 c3 ON c1.submission_date = c3.submission_date AND c1.rw_max_per_day = c3.max_per_day
ORDER BY c1.submission_date)
SELECT
    ct4.submission_date,
    ct4.cnt_total,
    ct4.hacker_id,
    h.name
FROM CTE4 ct4
JOIN Hackers h ON ct4.hacker_id = h.hacker_id
WHERE ct4.rw = 1
ORDER BY ct4.submission_date;
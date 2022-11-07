WITH
    CTE1 AS (
    SELECT C1.contest_id contest_id, C1.hacker_id hacker_id, name, TEMP1.total_submissions S1, TEMP1.total_accepted_submissions S2, TEMP2.total_views S3, TEMP2.total_unique_views S4
    FROM Contests C1
    INNER JOIN Colleges  C2 ON C1.contest_id = C2.contest_id
    INNER JOIN Challenges C3 ON C2.college_id = C3.college_id
    LEFT JOIN
        (
         SELECT challenge_id, SUM(total_submissions) total_submissions, SUM(total_accepted_submissions) total_accepted_submissions
         FROM Submission_Stats
         GROUP BY challenge_id
        ) TEMP1
    ON C3.challenge_id = TEMP1.challenge_id
    LEFT JOIN
        (
         SELECT challenge_id, SUM(total_views) total_views, SUM(total_unique_views) total_unique_views
         FROM View_Stats
         GROUP BY challenge_id
        ) TEMP2
    ON C3.challenge_id = TEMP2.challenge_id
    )
SELECT contest_id, hacker_id, name, SUM(S1), SUM(S2), SUM(S3), SUM(S4)
FROM CTE1
GROUP BY contest_id, hacker_id, name
HAVING (SUM(S1) + SUM(S2) + SUM(S3) + SUM(S4)) > 0
ORDER BY contest_id;
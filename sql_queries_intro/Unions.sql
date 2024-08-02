/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
Description: unions
*/

-- get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL -- combine another table

-- get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

-- get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

--Problem
/*Find job postings from the first quarter that have a salary greater than 70k
- Combine job postings from Jan-March
- Get job postings with an average yearly salary > 70000
*/

SELECT
    Q1_job_postings.job_title_short,
    Q1_job_postings.job_location,
    Q1_job_postings.job_via,
    Q1_job_postings.job_posted_date::DATE,
    Q1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS Q1_job_postings
WHERE
    Q1_job_postings.salary_year_avg > 70000
    AND Q1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    Q1_job_postings.salary_year_avg DESC


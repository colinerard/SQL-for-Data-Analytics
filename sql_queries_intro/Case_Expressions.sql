/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: Create a new column classifying jobs based on location:
    - Anywhere jobs as Remote
    - New York, NY jobs as Local
    - Onsite otherwise
*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END as location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category
;

-- PROBLEMS

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: categorize the salaries from each job
*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg IS NULL THEN '99. N/A'
        WHEN salary_year_avg < 100000 THEN '1. Low'
        WHEN salary_year_avg < 200000 THEN '2. Medium'
        ELSE '3. High'
    END as salary_range,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END as location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    salary_range,
    location_category
ORDER BY
    salary_range;
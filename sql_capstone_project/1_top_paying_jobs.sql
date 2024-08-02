/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
DESCRIPTION: What are the top paying Business & Data Analysts jobs in Switzerland or Germany?
STEPS:
    1. Identify the top 10 highest-paying roles 
    2. Remove roles with no salary
*/


SELECT
    job_id,
    name AS company_name,
    job_title,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    (job_title_short LIKE '%Data Analyst%' 
    OR job_title_short LIKE '%Business Analyst')
    AND
    (job_location LIKE '%Switzerland%'
    OR job_location LIKE '%Germany%')
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
;
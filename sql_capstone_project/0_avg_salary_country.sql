/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-05
DESCRIPTION: What are the top paying countries in Europe for Business & Data Analysts jobs ?
STEPS:
    1. Identify the top 3 highest-paying countries in average 
    2. Remove roles with no salary
*/


SELECT
    job_country,
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    COUNT(*)
FROM
    job_postings_fact
WHERE
    (job_title_short LIKE '%Data Analyst%' 
    OR job_title_short LIKE '%Business Analyst')
    AND
    (job_country LIKE '%France%'
    OR job_country LIKE '%Germany%'
    OR job_country LIKE '%Switzerland%'
    OR job_country LIKE '%Italy%'
    OR job_country LIKE '%Spain%'
    OR job_country LIKE '%Portugal%'
    OR job_country LIKE '%United Kingdom%'
    OR job_country LIKE '%Netherlands%'
    OR job_country LIKE '%Belgium%'
    OR job_country LIKE '%Austria%'
    OR job_country LIKE '%Denmark%'
    OR job_country LIKE '%Sweden%'
    OR job_country LIKE '%Norway%'
    OR job_country LIKE '%Estonia%'
    OR job_country LIKE '%United States%'
    )
    AND
    salary_year_avg IS NOT NULL
GROUP BY
    job_country
ORDER BY
    avg_salary DESC
;
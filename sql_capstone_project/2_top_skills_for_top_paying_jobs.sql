/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
DESCRIPTION: What are the skills demanded by these top paying Business & Data Analysts jobs in Switzerland or Germany?
STEPS:
    1. Identify the top 10 highest-paying roles
    2. Join the data from 1. to the skills tables & data (using CTE or subquery)
*/

WITH top_20_paying_jobs AS (
    SELECT
        job_id,
        name AS company_name,
        job_title,
        job_title_short,
        job_location,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_country LIKE '%Switzerland%'
        OR job_country LIKE '%Germany%'
        OR job_country LIKE '%Netherlands%')
        AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 20
)

SELECT 
    skills AS skills_name,
    COUNT(*)
FROM top_20_paying_jobs
INNER JOIN
    skills_job_dim
    ON top_20_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_name
ORDER BY
    COUNT(*) DESC
;

/*Results
1. Tableau is the most requested with 4 roles demanding this skill.
2. IT is closely followed by spark, sql and python with 3 roles each requiring some level of technical literacy.

-» In addition, could decide to have a bit less of a precise query and load the output of the one below in ChatGPT / excel to visualise it

WITH top_10_paying_jobs AS (
    SELECT
        job_id,
        name AS company_name,
        job_title,
        job_title_short,
        job_location,
        salary_year_avg
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
)

SELECT 
    top_10_paying_jobs.*,
    skills AS skills_name
FROM top_10_paying_jobs
INNER JOIN
    skills_job_dim
    ON top_10_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg
;
*/
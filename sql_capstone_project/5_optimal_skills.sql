/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
DESCRIPTION: What are the most optimal skills to learn (aka in high demand and high paying) for Business & Data Analysts jobs in Switzerland or Germany?
Steps:
    1. Identify the skills in high-demand and associated with high-paying jobs for our roles
    2. Focus on roles in our geographies of choice that have salary information.
-» Use CTE to come up with the results (just for fun - it can be more effectively by doing a couple of joins)
*/

WITH top_skills_demanded AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skill_name,
        COUNT(skills_job_dim.job_id) AS skill_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_location LIKE '%Switzerland%'
        OR job_location LIKE '%Germany%')
        AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS yearly_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_location LIKE '%Switzerland%'
        OR job_location LIKE '%Germany%')
        AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT
    top_skills_demanded.skill_id,
    top_skills_demanded.skill_name,
    top_skills_demanded.skill_count,
    average_salary.yearly_salary
FROM
    top_skills_demanded
INNER JOIN
    average_salary
    ON top_skills_demanded.skill_id = average_salary.skill_id
WHERE
    skill_count > 5
ORDER BY
    yearly_salary DESC,
    skill_count DESC
;
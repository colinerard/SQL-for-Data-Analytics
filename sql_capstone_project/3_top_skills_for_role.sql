/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
DESCRIPTION: What are the skills demanded by Business & Data Analysts jobs in Switzerland or Germany? 
WHY? To be able to see the wider trend in terms of in-demand skills in CH and GER for these types of roles.
STEPS:
    1. Join skills and job postings tables together
    2. Filter for location and job title
    3. Identify the top 5 skills across all job postings 
*/

SELECT
    skills AS skill_name,
    COUNT(*) AS skill_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title_short LIKE '%Data Analyst%' 
    OR job_title_short LIKE '%Business Analyst')
    AND
    (job_location LIKE '%Switzerland%'
    OR job_location LIKE '%Germany%')
GROUP BY 
    skill_name
ORDER BY 
    skill_count DESC
LIMIT 5
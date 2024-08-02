/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
DESCRIPTION: What are the average salaries associated with each skill for Business & Data Analysts jobs in Switzerland or Germany? 
WHY? Identify the skill that commands a higher salary premium, the most rewarding skill.
STEPS:
    1. Join skills and job postings tables together
    2. Filter for location and job title and job with salary info
    3. Calculate the average yearly salary per skill
    4. Remove the squills that appear only less than 5 times, as it is a very small sample
    5. Group the results by skill and order in descending order of value (highest value first)
*/

SELECT
    skills AS skill_name,
    ROUND(AVG(salary_year_avg), 0) AS yearly_salary,
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
    AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skill_name
HAVING
    COUNT(*) > 5
ORDER BY 
    yearly_salary DESC
;

/*
We could again extract the results and feed them to ChatGPT to extract insights and come up with descriptive text.
*/
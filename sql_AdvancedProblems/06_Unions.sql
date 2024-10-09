/*
CREATED DATE: 2024-09-12
CREATED BY: Colin Erard
DESCRIPTION: Create a unified query that categorizes job postings into two groups: those with salary information (salary_year_avg or salary_hour_avg is not null) and those without it. 
Each job posting should be listed with its job_id, job_title, and an indicator of whether salary information is provided.
Steps:
    1. Query to find all jobs with salary information
    2. Query to find all jobs without salary information.
    3. UNION ALL to merge both queries
*/

--Solution without UNIONs (simpler)

SELECT
    job_id,
    job_title,
    CASE
        WHEN salary_year_avg IS NOT NULL THEN 'With salary information'
        WHEN salary_hour_avg IS NOT NULL THEN 'With salary information'
        ELSE 'Without salary information'
    END AS salary_information
FROM
    job_postings_fact
ORDER BY
    salary_information DESC,
    job_id;

--Solution with UNIONs (just to practice them)

(
    SELECT
        job_id,
        job_title,
        'With salary information' AS salary_information 
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
)
UNION ALL
(
    SELECT
        job_id,
        job_title,
        'Without salary information' AS salary_information 
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NULL AND salary_hour_avg IS NULL
)
ORDER BY
    salary_information DESC,
    job_id

/*
CREATED DATE: 2024-09-12
CREATED BY: Colin Erard
DESCRIPTION: Retrieve the job id, job title short, job location, job via, skill and skill type for each job posting from the first quarter (January to March).
Using a subquery to combine job postings from the first quarter.
Only include postings with an average yearly salary greater than $70,000.
Steps:
    1. UNION to combine the tables including jobs from the first quarter 
    2. Include the relevant columns and filter for 70k+ jobs
*/

SELECT
    Q1_job_postings.job_id,
    Q1_job_postings.job_title_short,
    Q1_job_postings.job_via,
    skills_dim.skills,
    skills_dim.type
FROM
(
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS Q1_job_postings
LEFT JOIN
    skills_job_dim
    ON Q1_job_postings.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    Q1_job_postings.salary_year_avg > 70000


/*
CREATED DATE: 2024-09-12
CREATED BY: Colin Erard
DESCRIPTION: Analyze the monthly demand for skills by counting the number of job postings for each skill in the first quarter (January to March), utilizing data from separate tables for each month. 
Steps:
    1. CTE to combine the tables from the first quarter 
    2. CTE to extract the month and year skill demand and group per skill
    3. Query to display the results
*/

WITH Q1_job_postings AS (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
),
monthly_skill_demand AS (
    SELECT
        skills_dim.skills,
        EXTRACT(YEAR FROM Q1_job_postings.job_posted_date) AS posted_year,        
        EXTRACT(MONTH FROM Q1_job_postings.job_posted_date) AS posted_month,
        COUNT(Q1_job_postings.job_id) AS postings_count
    FROM
        Q1_job_postings
    INNER JOIN
        skills_job_dim
        ON Q1_job_postings.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
        skills_dim.skills,
        posted_year,
        posted_month
)

SELECT
    skills,
    posted_year,
    posted_month,
    postings_count
FROM
    monthly_skill_demand
ORDER BY
    skills,
    posted_year,
    posted_month








SELECT
    skills_dim.skills,
    COUNT(DISTINCT Q1_job_postings.job_id) AS distinct_jobs
FROM
(
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS Q1_job_postings
LEFT JOIN
    skills_job_dim
    ON Q1_job_postings.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
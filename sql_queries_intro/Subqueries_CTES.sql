/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
Description: subqueries and CTES
*/

--subquery--

SELECT *
FROM ( -- subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs
ORDER BY job_posted_date;
--sub query ends here

--CTE--

WITH january_jobs AS (--CTE starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)--CTE finishes here

SELECT *
FROM january_jobs
;

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
Description: find jobs where no degree is needed and associate them with the company name 
*/

SELECT
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE 
    company_id IN(
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
);

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
Description: find the companies with the most job openings.
    - Get the total number of job postings per company id
    - return the total number of jobs with the company name
*/

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN
    company_job_count
    ON company_job_count.company_id = company_dim.company_id
ORDER BY
    company_job_count.total_jobs DESC
;

-- Problems

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
Description: find the number of remote data analyst job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name and count of postings requiring the skill

Steps for resolution
1. Create a CTE that collects the number of job postings per skill. Create a join (Inner join)
2. Once we have the temp results, we can combine with the skills_dim table to have the name.
*/

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN
        job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home IS TRUE AND
        job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skill.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN
    skills_dim AS skill
    ON skill.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5


/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-02
Description: top 5 skills that are most frequently mentioned in job postings
    - Use a subquery to find the skills ID with the highest counts in the skills-job_dim table
    - Then join the result with teh skills_dim to get the names
*/

-- no sub-query solution

SELECT
    skills_dim.skills AS skill_name,
    COUNT(*) AS skills_count
FROM
    skills_job_dim
LEFT JOIN
    skills_dim
    ON 
        skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skill_name
ORDER BY
    skills_count DESC
LIMIT 5;



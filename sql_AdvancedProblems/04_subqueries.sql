/*
CREATED DATE: 2024-09-11
CREATED BY: Colin Erard
DESCRIPTION: Identify the top 5 skills mentioned in job_postings using a subquery and join them with the skills_dim table to get their name.
Steps:
    1. Calculate the top 5 most frequent skills listed in the skills_job_dim table
    2. Join this subquery on the skills_dim table to get their names. 
*/

SELECT 
    skills_dim.skills,
    skill_count
FROM 
    skills_dim
INNER JOIN 
    (
        SELECT 
        skill_id,
        COUNT(job_id) AS skill_count
        FROM skills_job_dim
        GROUP BY skill_id
        ORDER BY COUNT(job_id) DESC
        LIMIT 5
    ) AS top_skills 
    ON skills_dim.skill_id = top_skills.skill_id
ORDER BY top_skills.skill_count DESC;

/*
CREATED DATE: 2024-09-11
CREATED BY: Colin Erard
DESCRIPTION: Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have
Steps:
    1. Subquery to aggregate the number of job counts per company
    2. Quantify them in small, medium or large based on the number of postings.
*/

SELECT 
    company_dim.company_id,
    company_dim.name AS company_name,
    job_per_company.job_count,
    CASE
        WHEN job_per_company.job_count > 50 THEN 'Large'
        WHEN job_per_company.job_count >= 10 THEN 'Medium'
        ELSE 'Small'
    END AS company_size
FROM
    company_dim
INNER JOIN 
    (
        SELECT
            company_id,
            COUNT(job_id) AS job_count
        FROM job_postings_fact
        GROUP BY company_id
    ) AS job_per_company
    ON company_dim.company_id = job_per_company.company_id

/*
CREATED DATE: 2024-09-11
CREATED BY: Colin Erard
DESCRIPTION: Find companies that offer an average salary above the overall average yearly salary of all job postings. 
Use subqueries to select companies with an average salary higher than the overall average salary (which is another subquery).
Steps:
    1. Subquery to calculate the overall average yearly salary per company.
    2. Subquery to identify the overall acerage yearly salary across all jobs.
    3. Identify the companies that are greater than the average.
*/


SELECT
    company_dim.name,
    company_salaries.avg_salary
FROM
    company_dim
INNER JOIN
        (
            SELECT 
                company_id,
                ROUND(AVG(salary_year_avg), 0) AS avg_salary
            FROM
                job_postings_fact
            GROUP BY
                company_id
        ) AS company_salaries
        ON company_dim.company_id = company_salaries.company_id
WHERE company_salaries.avg_salary > 
    (
        SELECT
            ROUND(AVG(salary_year_avg), 0)
        FROM
            job_postings_fact
    )

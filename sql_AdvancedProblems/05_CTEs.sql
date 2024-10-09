/*
CREATED DATE: 2024-09-11
CREATED BY: Colin Erard
DESCRIPTION: Identify companies with the most diverse (unique) job titles 
Steps:
    1. Count the numbers of unique job titles per company
    2. Join the results from the job_postings_fact to the Company_dim table
    3. Sort and limit to the top 10 results
*/

WITH unique_jobs AS 
    (
        SELECT
            company_id,
            COUNT(DISTINCT job_id) AS distinct_jobs
        FROM job_postings_fact
        GROUP BY company_id
    )

SELECT
    company_dim.name,
    unique_jobs.distinct_jobs
FROM
    unique_jobs
INNER JOIN
    company_dim 
    ON unique_jobs.company_id = company_dim.company_id
ORDER BY unique_jobs.distinct_jobs DESC
LIMIT 10

/*
CREATED DATE: 2024-09-11
CREATED BY: Colin Erard
DESCRIPTION: Explore job postings by listing job id, job titles, company names, and their average salary rates, while categorizing these salaries relative to the average in their respective countries.
Include the month of the job posted date. Use CTEs, conditional logic, and date functions, to compare individual salaries with national averages. 
Steps:
    1. Calculate average yearly salaries per country using a CTE¸
    2. Case to classify each job posting compared with the national average (either above or below)
    3. EXTRACT function to find the month
    4. Join the company_dim to include the company name 
*/

WITH average_salary_country AS
    (
        SELECT
            job_country,
            ROUND(AVG(salary_year_avg),0) AS avg_salary,
            COUNT(job_id) AS job_count
        FROM
            job_postings_fact
        GROUP BY
            job_country
    )

SELECT
    postings.job_id,
    postings.job_title,
    companies.name,
    postings.salary_year_avg,
    CASE
        WHEN postings.salary_year_avg > average_salary_country.avg_salary THEN 'Above'
        ELSE 'Below'
    END AS national_salary_comparison,
    EXTRACT(MONTH FROM job_posted_date) AS posting_month
FROM
    job_postings_fact AS postings
INNER JOIN
    company_dim AS companies
    ON postings.company_id = companies.company_id
INNER JOIN
    average_salary_country
    ON postings.job_country = average_salary_country.job_country
ORDER BY 
    posting_month DESC

/*
CREATED DATE: 2024-09-11
CREATED BY: Colin Erard
DESCRIPTION: Calculate the number of unique skills per company and which companies offer the highest avg. salary for jobs with a least one skill.
Steps:
    1. CTE to identify the number of unique skills per company
    2. CTE to identify the highest average salary offered per company
    3. LEFT JOIN to include all companies, incl. those with 0 skill-related job postings
    4. Join the company_dim table with both CTEs 
*/

WITH unique_skills AS
    (
        SELECT
            companies.company_id,
            COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
        FROM
            company_dim AS companies
        LEFT JOIN 
            job_postings_fact AS job_postings
            ON companies.company_id = job_postings.company_id
        LEFT JOIN
            skills_job_dim AS skills_to_job
            ON job_postings.job_id = skills_to_job.job_id
        GROUP BY
            companies.company_id
    ),

max_salary AS
    (
        SELECT
            job_postings.company_id,
            MAX(job_postings.salary_year_avg) AS highest_avg_salary
        FROM
            job_postings_fact AS job_postings
        WHERE
            job_postings.job_id
            IN 
            (
                SELECT
                    job_id
                FROM
                    skills_job_dim
            )
        GROUP BY
            job_postings.company_id        
    )

SELECT
    companies.name,
    unique_skills.unique_skills_required,
    max_salary.highest_avg_salary
FROM
    company_dim AS companies
LEFT JOIN
    unique_skills
    ON companies.company_id = unique_skills.company_id
LEFT JOIN
    max_salary
    ON companies.company_id = max_salary.company_id
ORDER BY
    companies.name;
/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Classify jobs base on the salary in 3 categories: high, medium and low.
*/

SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High'
        WHEN salary_year_avg > 60000 THEN 'Medium'
        ELSE 'Low'
    END as salary_category
FROM 
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Count the number of unique companies that offer work from home versus those that don't.
*/

--Option 1

SELECT
    job_work_from_home,
    COUNT (DISTINCT company_id)    
FROM
    job_postings_fact
GROUP BY 
    job_work_from_home

--Option 2

SELECT
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM
    job_postings_fact

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Identify jobs by experience level and remote work
*/


SELECT
    job_id,
    salary_year_avg,
    job_title,
    CASE
        WHEN job_title ILIKE '%Senior%' OR job_title ILIKE '%Sr.%' THEN 'Senior'
        WHEN job_title ILIKE '%Lead%' OR job_title ILIKE '%Manager%' OR job_title ILIKE '%Mgr.%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' OR job_title ILIKE '%Jr.%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home IS TRUE THEN 'Yes'
        WHEN job_work_from_home IS FALSE THEN 'No'
    END AS remote_option
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;
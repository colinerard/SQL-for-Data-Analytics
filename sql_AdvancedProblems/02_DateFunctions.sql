/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Calculate average salaries, both yearly and hourly and group by job postings
*/

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS yearly_salary,
    AVG(salary_hour_avg) AS hourly_salary
FROM 
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type


/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Count the number of job postings per month in 2023
*/

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS column_month,
    COUNT(job_title) AS job_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') = '2023'
GROUP BY
    column_month
ORDER BY
    column_month

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Find companies with job offering health insurance posted in 2nd quarter
*/

SELECT
    c.name,
    COUNT(j.job_id) AS job_count
FROM job_postings_fact AS j
LEFT JOIN
    company_dim AS c
    ON j.company_id = c.company_id
WHERE
    j.job_health_insurance IS TRUE AND
    EXTRACT(QUARTER FROM j.job_posted_date) = 2
GROUP BY
    c.name
HAVING
    COUNT(j.job_id) > 0
ORDER BY
    COUNT(j.job_id) DESC
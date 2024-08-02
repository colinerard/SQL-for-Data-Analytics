/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: convert as a date
*/

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact;

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: change time zone
*/

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact
LIMIT
    5;

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: extract month
*/

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS column_month
FROM
    job_postings_fact
LIMIT
    5;

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: Group # of postings for data analyst by month, sort by months where there are most postings
*/

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH from job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC
;

---Problems

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: Avg. hourly and yearly salary for postings after 1 Jun 2023, grouped by job schedule type
*/

SELECT
    job_schedule_type AS schedule_type,
    AVG(salary_hour_avg) AS salary_hour,
    AVG(salary_year_avg) AS salary_year
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    salary_year DESC;

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: Count # of postings per month in 2023, adjust for America/New York time zone before extracting the month, assuming posting is in UTC. Group and order by month
*/


SELECT
    EXTRACT(MONTH from job_posted_date) AS month,
    COUNT(job_id) AS job_posted_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR from job_posted_date) = 2023
GROUP BY
    EXTRACT(MONTH from job_posted_date)
ORDER BY
    job_posted_count DESC
;

/*
CREATED BY: Colin Erard
CREATED ON: 2024-08-01
DESCRIPTION: Find company names that posted job offering health insurance in the second quarter of 2023.
*/

SELECT
    COUNT(job_postings_fact.job_id),
    company_dim.name
FROM
    job_postings_fact
INNER JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    EXTRACT(QUARTER from job_postings_fact.job_posted_date) = 2 AND
    job_postings_fact.job_health_insurance IS TRUE
GROUP BY
    company_dim.name
ORDER BY
    company_dim.name;
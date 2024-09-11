/*
CREATED BY: Colin Erard
CREATED ON: 2024-09-04
DESCRIPTION: Create a new table containing only data science jobs and certain fields.
*/

CREATE TABLE data_science_jobs (
    job_id INT,
    job_title VARCHAR(255),
    company_name VARCHAR(255),
    post_date DATE
);

/*
CREATED BY: Colin Erard
CREATED ON: 2024-09-04
DESCRIPTION: 
*/

INSERT INTO data_science_jobs
            (job_id,
            job_title,
            company_name,
            post_date
            )
VALUES      (1,
            'Data Scientist',
            'Tech Innovations',
            '2023-01-01'),
            (2,
            'Machine Learning Engineer',
            'Data Driven Co',
            '2023-01-15'),
            (3,
            'AI Specialist',
            'Future Tech',
            '2023-02-01'
            );

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Altering table
*/

ALTER TABLE data_science_jobs
ADD remote BOOLEAN;

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Rename a column
*/

ALTER TABLE data_science_jobs
RENAME COLUMN post_date TO posted_on

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Set default value in a column
*/

ALTER TABLE data_science_jobs
ALTER COLUMN remote
SET DEFAULT FALSE

INSERT INTO data_science_jobs 
            (job_id,
            job_title,
            company_name,
            posted_on)
VALUES      (4,
            'Data Scientist',
            'Google',
            '2023-02-05')

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Drop a column
*/

ALTER TABLE data_science_jobs
DROP COLUMN company_name

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Update a value
*/

UPDATE  data_science_jobs
SET     remote = TRUE
WHERE   job_id = 2;

/*
CREATED DATE: 2024-08-01
CREATED BY: Colin Erard
DESCRIPTION: Drop a table
*/

DROP TABLE data_science_jobs

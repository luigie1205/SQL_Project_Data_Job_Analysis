-- Get jobs and companies from January 
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION -- combine Januaary with February jobs

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION -- combine another month

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

-- UNION ALL -- use UNION ALL to include duplicates

--Practice problem
/*
Find job postings for the first quarter that have sa salary greater than $70K
    - Combine job posting tables from the first quarter of 2023 (Jan0Mar)
    - Gets job posting with anual avaerage salary greater than $70K
*/
-- Easy way - without CTEs
SELECT job_id
FROM job_postings_fact
WHERE 
    salary_year_avg > 70000 AND 
    job_posted_date >= '2023-01-01' AND job_posted_date < '2023-04-01'  -- this can be an option if you don't want to use UNION, filter directly from the fact table
ORDER BY job_id;
-- Using CTEs and UNION
-- Step 1: combine the first quarter tables
WITH q1_jobs AS (
    SELECT *    
    FROM                        
        january_jobs
    UNION
    SELECT *
    FROM
        february_jobs
    UNION
    SELECT *
    FROM
        march_jobs
)
-- Step 2: Filter for jobs with average salary greater than $70K
WITH q1_jobs AS (
    SELECT *    
    FROM                        
        january_jobs
    UNION
    SELECT *
    FROM
        february_jobs
    UNION
    SELECT *
    FROM
        march_jobs
)
SELECT *
FROM q1_jobs
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY job_id;
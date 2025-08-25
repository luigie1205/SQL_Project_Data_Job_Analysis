-- Converto to date
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date -- convert to date format only 
FROM job_postings_fact;

-- Extract year, month, timezone
SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS time, -- convert to selected timezone 
    EXTRACT (MONTH FROM job_posted_date) AS date_month, --extract month and add new column
    EXTRACT (YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 5;

-- Extract month
SELECT
    job_id,
    EXTRACT (MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
LIMIT 5;

-- aggregate to see the count of job id each month/ COUNT & GROUP BY COMBO 
SELECT
    COUNT (job_id),
    EXTRACT (MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
GROUP BY
    month;

-- another example; searcj for Data Analyst 
SELECT
    COUNT (job_id) AS job_posted_count,
    EXTRACT (MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY    
    job_posted_count DESC;




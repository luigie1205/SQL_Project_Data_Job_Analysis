-- Create temporary table using SubQuery
SELECT *
FROM ( -- SubQuery starts here
    SELECT * 
    FROM
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- SubQuery ends here


-- Create temporary table using CTE
WITH january_jobs AS ( -- CTE definitio starts here 
    SELECT * 
    FROM
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE Definition ends here
SELECT *
FROM
    january_jobs;

-- Example; this will be the base tabl/reference?
SELECT
    company_id
    job_no_degree_mention -- not necesaary added to see/check
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = true

-- 
SELECT 
    company_id, 
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT
        company_id
        --job_no_degree_mention -- not necesaary added to see/check
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
)

--Example 
/* 
Find the companies that have the most job openings
-Get the total number oj job postings per company id (job_posting_fact)
-Return the total number of jobs with the company name (company_dim)
*/

-- start with this; this will be the temporary table 
SELECT 
    company_id,
    COUNT (*)
FROM
    job_postings_fact
GROUP BY
    company_id

-- use CTEs 
WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT (*)
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT * 
FROM company_job_count


-- LEFT JOIN temporary table company_job_count and company_dim
WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT (*) AS total_jobs
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
    total_jobs DESC; 

--Practice Problem 
/*
Find the count of number of remote job postings per skill
    - Display the top 5 skills by thier demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
*/

/* My first attempt - incorrect
SELECT
    COUNT(job_id) AS job_posted_count,
    job_location
FROM 
    job_postings_fact
WHERE 
    job_location = 'Anywhere'
GROUP BY
    job_location
LEFT JOIN
    skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
*/

-- Step 1: get the count of number of remote job postings per skill 
SELECT
    skill_id,
    COUNT (*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
GROUP BY
    skill_id

--Step 2: add filter for remote jobs by joining job_postings_fact table 
SELECT
    skill_id,
    --job_postings.job_id -- (2nd to remove)
    -- job_postings.job_work_from_home -used to check remote jobs (1st to remove)
    COUNT (*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN
    job_postings_fact AS job_postings
    ON skills_to_job.job_id = job_postings.job_id
WHERE
    job_postings.job_work_from_home = True
GROUP BY
    skill_id

-- Step 3 : Use CTE to create temporary table
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT (*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN
        job_postings_fact AS job_postings
        ON skills_to_job.job_id = job_postings.job_id
    WHERE
        job_postings.job_work_from_home = True AND 
        job_postings.job_title_short = 'Data Analyst' -- added to filter for Data Analyst role
    GROUP BY
        skill_id
)
SELECT
    skills.skill_id,
    skills.skills AS skill_name,
        remote_job_skills.skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills
    ON remote_job_skills.skill_id = skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
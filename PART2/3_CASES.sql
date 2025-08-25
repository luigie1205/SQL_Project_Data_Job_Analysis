SELECT
    job_title_short,
    job_location
FROM 
    job_postings_fact;

/*
Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York', 'NY, jobs as 'Local'
- Otherwise 'Onsite'
*/

-- Case 
SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact;

--aggregate count - group by - combo 
SELECT
    COUNT(job_id) AS job_posted_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
GROUP BY
    location_category;

-- aggregate count - group by - combo 
-- filter data analyst
SELECT
    COUNT(job_id) AS job_posted_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE   
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;


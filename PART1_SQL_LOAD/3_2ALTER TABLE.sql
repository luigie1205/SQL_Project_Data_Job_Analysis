ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name; -- This will rename the contact column to contact_name

SELECT * FROM job_applied;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT; -- This will change the data type of contact_name to TEXT

ALTER TABLE job_applied
DROP COLUMN contact_name; -- This will remove the contact_name column from the job_applied table


DROP TABLE job_applied; -- This will delete the job_applied table from the database
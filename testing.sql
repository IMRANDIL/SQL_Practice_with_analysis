-- SELECT * from job_postings_fact LIMIT 10;

-- SELECT job_posted_date::Date from job_postings_fact LIMIT 100; taking only date from job_posted_date...it consists of date and timestamp as well.


-- SELECT job_title_short AS title,
-- job_location AS location,
-- job_posted_date::DATE AS date --casting to DATE only
--  FROM job_postings_fact
--  LIMIT 10;






-- SELECT job_title_short AS title,
-- job_location AS location,
-- job_posted_date as date
--  FROM job_postings_fact
--  LIMIT 10;





 --- query with timezone and timestamp

-- SELECT job_title_short AS title,
-- job_location AS location,
-- job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' as date
--  FROM job_postings_fact
--  LIMIT 10;



---extract function in sql query


-- SELECT job_title_short AS title,
-- job_location AS location,
-- job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' as date,
-- EXTRACT(MONTH FROM job_posted_date) AS month,
-- EXTRACT(YEAR FROM job_posted_date) AS year
--  FROM job_postings_fact
--  LIMIT 10;


--- some more analysis using extract function in sql

-- SELECT 
-- EXTRACT(MONTH FROM job_posted_date) as month,
-- count(job_id) as count
-- FROM
-- job_postings_fact
-- GROUP BY
-- month
-- ORDER BY
-- count desc
-- LIMIT 100;
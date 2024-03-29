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




-- create 3 table ...1st table has only janury month data, 2nd table has february month data and 3rd table has march month data


--january table..done
-- CREATE TABLE january_jobs as
--     SELECT 
--     * 
--     FROM job_postings_fact
--     WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
--     AND
--     salary_year_avg is not null



-- feb table below

-- CREATE TABLE feb_jobs as
--     SELECT * FROM job_postings_fact
--     WHERE EXTRACT(MONTH from job_posted_date) = 2
--     and salary_year_avg is not null


-- march job table below

-- CREATE TABLE march_jobs as
--     SELECT * from job_postings_fact
--     WHERE EXTRACT(MONTH from job_posted_date) = 3
--     and salary_year_avg is not null




--- case statement in sql.......practice...needed badly this...


/*
Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'


*/





SELECT job_location, 
job_title_short,
CASE
WHEN job_location = 'Anywhere' THEN 'Remote'
WHEN job_location = 'New York, NY' THEN 'Local'
ELSE 'Onsite'
END AS location_category
from 
job_postings_fact 
limit 100;
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





-- SELECT 
-- COUNT(job_id) as number_of_jobs,
-- job_location, 
-- job_title_short,
-- CASE
-- WHEN job_location = 'Anywhere' THEN 'Remote'
-- WHEN job_location = 'New York, NY' THEN 'Local'
-- ELSE 'Onsite'
-- END AS location_category
-- from 
-- job_postings_fact 
-- GROUP BY
-- location_category, job_location, job_title_short
-- ORDER BY
-- number_of_jobs DESC
-- limit 100;



--- subqueries at a glance


-- SELECT
--     jpf.company_id,
--     jpf.job_no_degree_mention,
--     cd.name as company_name,
--     COUNT(job_no_degree_mention = TRUE) as number_of_no_degree_count
-- FROM
--     job_postings_fact as jpf
--     LEFT JOIN company_dim as cd ON
--     cd.company_id = jpf.company_id
-- WHERE
--     job_no_degree_mention = TRUE
-- GROUP BY
-- company_name, jpf.company_id, jpf.job_no_degree_mention
-- ORDER BY
-- number_of_no_degree_count DESC 
-- LIMIT 100





---- CTE - Common Table Expression at a glance

/*
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_posting_fact)
- Return the total number of jobs with the company name (company_dim)
*/


--- in cte we can divide the query


-- WITH company_job_count AS (
--     SELECT
--         company_id,
--         COUNT(*) AS job_count
--     FROM
--         job_postings_fact
--     GROUP BY
--         company_id
-- )

-- SELECT company_dim.name as company_name,
-- COALESCE(company_job_count.job_count, 0) AS job_count ---Used COALESCE(company_job_count.job_count, 0) to handle cases where there are no matching job counts for a company, defaulting to 0.
-- from company_dim
-- left join company_job_count on
-- company_dim.company_id = company_job_count.company_id
-- ORDER BY company_job_count.job_count DESC;






-----again CTE with some more example


/*
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill

*/



--- why we need to choose skills_job_dim ..as it has skill_id and job_id both is there..

-- with skill_info as (

-- SELECT sjd.skill_id,count(*) as skill_count from skills_job_dim as sjd
-- INNER JOIN job_postings_fact as jpf on 
-- jpf.job_id = sjd.job_id
-- WHERE jpf.job_work_from_home = TRUE
-- GROUP BY sjd.skill_id


-- )

-- SELECT sd.skill_id, sd.skills, si.skill_count from skill_info as si
-- INNER JOIN skills_dim as sd
-- on sd.skill_id = si.skill_id
-- ORDER BY si.skill_count desc
-- LIMIT 5
-- ;




--union and union all practice below

/*
Find job postings from the first quarter that have 
a salary greater than $70K

- combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Get job posting with an average yearly salary > $70,000

*/




-- SELECT
-- quarter1_job_postings.job_title_short,
-- quarter1_job_postings.job_location,
-- quarter1_job_postings.job_via,
-- quarter1_job_postings.job_posted_date::DATE,
-- quarter1_job_postings.salary_year_avg
-- FROM (
-- SELECT * from january_jobs WHERE salary_year_avg > 70000
-- UNION ALL
-- SELECT * from feb_jobs WHERE salary_year_avg > 70000
-- UNION ALL
-- SELECT * from march_jobs WHERE salary_year_avg > 70000
-- ) As quarter1_job_postings
-- WHERE quarter1_job_postings.job_location is not NULL
-- ORDER BY quarter1_job_postings.salary_year_avg DESC




/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available reotely.
- Focuses on job postings with specified salaries (remove nulls).
- why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment opportunities.

*/


-- SELECT job_id,
-- job_title,
-- job_location,
-- company_dim.name as company_name,
-- job_schedule_type,
-- salary_year_avg,
-- job_posted_date::DATE
-- FROM
--     job_postings_fact
--     INNER JOIN company_dim
--     ON
--     company_dim.company_id = job_postings_fact.company_id
-- WHERE
--     job_title LIKE '%Data Analyst%'
--     and salary_year_avg is not NULL
--     and job_location = 'Anywhere'
--     ORDER BY salary_year_avg desc 
--     LIMIT 10;
    



--- another problem

/*
Question: What skills are required for the top-paying data analyst jobs?

- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- why? It provides a detailed look at which high-paying jobs demand certain skills,
helping job seekers understand which skills to develop that align with top salaries.

*/



-- WITH top_10_paying_jobs AS (
--     SELECT
--         jp.job_id,
--         jp.job_title,
--         cd.name AS company_name,
--         jp.salary_year_avg
--     FROM
--         job_postings_fact AS jp
--     INNER JOIN
--         company_dim AS cd ON cd.company_id = jp.company_id
--     WHERE
--         jp.job_title LIKE '%Data Analyst%'
--         AND jp.salary_year_avg IS NOT NULL
--         AND jp.job_location = 'Anywhere'
--     ORDER BY
--         jp.salary_year_avg DESC 
--     LIMIT 10
-- )

-- SELECT
--     tp.*,
--     ARRAY_TO_STRING(ARRAY_AGG(sjd.skill_id), ',') AS skill_ids
-- FROM
--     top_10_paying_jobs AS tp
-- INNER JOIN
--     skills_job_dim AS sjd ON sjd.job_id = tp.job_id
-- GROUP BY
--     tp.job_id, tp.job_title, tp.company_name, tp.salary_year_avg
-- ORDER BY
--     tp.salary_year_avg DESC
-- LIMIT 10;



-- WITH top_10_paying_jobs AS (
--     SELECT
--         jp.job_id,
--         jp.job_title,
--         cd.name AS company_name,
--         jp.salary_year_avg
--     FROM
--         job_postings_fact AS jp
--     INNER JOIN
--         company_dim AS cd ON cd.company_id = jp.company_id
--     WHERE
--         jp.job_title LIKE '%Data Analyst%'
--         AND jp.salary_year_avg IS NOT NULL
--         AND jp.job_location = 'Anywhere'
--     ORDER BY
--         jp.salary_year_avg DESC 
--     LIMIT 10
-- )

-- SELECT sd.skills, tp.* 
-- FROM 
--     skills_dim sd
-- INNER JOIN 
--     skills_job_dim sjd ON sd.skill_id = sjd.skill_id
-- INNER JOIN 
--     top_10_paying_jobs tp ON tp.job_id = sjd.job_id
-- LIMIT 10;




--- top 10 most high paying skills


-- SELECT sd.skills, count(*) as skill_count from 
-- job_postings_fact as jpf
-- INNER JOIN 
--     skills_job_dim sjd ON jpf.job_id = sjd.job_id
-- INNER JOIN 
--     skills_dim sd ON sjd.skill_id = sd.skill_id
-- WHERE jpf.salary_year_avg > 200000
-- GROUP BY sd.skills
-- ORDER BY skill_count desc
-- LIMIT 10;

-- focus on python, sql, spark , aws, azure, and r probably

---below is the result

-- [
--   {
--     "skills": "sql",
--     "skill_count": "385750"
--   },
--   {
--     "skills": "python",
--     "skill_count": "381863"
--   },
--   {
--     "skills": "aws",
--     "skill_count": "145718"
--   },
--   {
--     "skills": "azure",
--     "skill_count": "132851"
--   },
--   {
--     "skills": "r",
--     "skill_count": "131285"
--   },
--   {
--     "skills": "tableau",
--     "skill_count": "127500"
--   },
--   {
--     "skills": "excel",
--     "skill_count": "127341"
--   },
--   {
--     "skills": "spark",
--     "skill_count": "114928"
--   },
--   {
--     "skills": "power bi",
--     "skill_count": "98363"
--   },
--   {
--     "skills": "java",
--     "skill_count": "85854"
--   }
-- ]


--- two cte sql query.....

WITH skills_demand AS (
    SELECT 
    sd.skills,
    sd.skill_id, 
    count(*) as skill_count 
    from 
    job_postings_fact as jpf
    INNER JOIN 
        skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN 
        skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE salary_year_avg is not NULL
    GROUP BY sd.skill_id

), Average_salary As (
    SELECT
    sd.skill_id,
    ROUND(AVG(jpf.salary_year_avg),0) as avg_salary
    FROM job_postings_fact as jpf
    INNER JOIN skills_job_dim as sjd on jpf.job_id = sjd.job_id
    INNER JOIN skills_dim as sd on sd.skill_id = sjd.skill_id
    WHERE salary_year_avg is not NULL
    GROUP BY sd.skill_id
    ORDER BY avg_salary desc
)


SELECT sd.skills, sd.skill_count, avs.avg_salary from skills_demand as sd INNER JOIN Average_salary as avs
on sd.skill_id = avs.skill_id
WHERE sd.skill_count > 10
ORDER BY sd.skill_count desc, avs.avg_salary desc
# Introduction
In today's dynamic job market, understanding the demand for specific skills and their corresponding salary trends is crucial for both job seekers and employers alike. Leveraging the power of SQL and PostgreSQL, we delve into job postings data to uncover insights that can inform strategic decisions.

# Background
Imagine a scenario where I, as a data enthusiast, set out on a quest to unearth valuable insights from the vast sea of job postings data. Armed with SQL prowess and a PostgreSQL database spun up effortlessly using Docker containers, I embarked on a journey to analyze job postings and reveal hidden patterns.

# Query Overview
```sql
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
```

The provided SQL query is a testament to the power of data analysis. It delves into two essential aspects: skills demand and average salary trends. By joining tables representing job postings, skills, and salary information, the query crunches numbers to reveal valuable insights.

#### Skills Demand:

The `skills_demand` Common Table Expression (CTE) calculates the demand for various skills by counting their occurrences in job postings. It meticulously analyzes the connections between job postings and required skills, providing a comprehensive view of the skill landscape.

#### Average Salary:

The `Average_salary` CTE computes the average salary associated with each skill, shedding light on the financial rewards linked to specific skill sets. By aggregating salary data and skill information, this CTE offers valuable insights into salary trends across different skills.

# Some Previews
![Alt text](assets\data_analysis.png)

# Conclusion

This SQL query represents a crucial step towards understanding the job market dynamics. It empowers stakeholders with actionable insights, enabling informed decisions regarding skill acquisition, recruitment strategies, and talent management.
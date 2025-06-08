### **Introduction**

Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

Check out my SQL queries here: [project_sql folder](/project_sql/). 

### **Background**

The motivation behind this project came from my drive to grow as a data professional. While my background is rooted in SEO, I’ve always been drawn to the broader patterns behind performance, behavior, and strategy. I wanted to strengthen my SQL skills to work more confidently with structured data and large datasets, and this project gave me the opportunity to explore the data analyst job market firsthand. By identifying which skills are most in demand and highest paying, I can shape my learning path more intentionally and expand beyond SEO into deeper, more versatile data work.

The data for this analysis is from Luke Barousse’s SQL [Course](https://www.lukebarousse.com/). This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

### Tools I Used

In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

### Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
### Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
```sql
SELECT
    job_id,
    job_title,     
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
    left JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
🤑 **Top Remote Data Jobs Can Pay Extremely Well** Up to $650K
*Mantys* listed a Data Analyst role at $650,000, significantly higher than others.

This suggests some remote roles—especially at startups or with equity-heavy comp packages—can rival top-tier in-office tech salaries.


### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
With top_paying_jobs AS (
    SELECT
        job_id,
        job_title,     
        job_location,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
        left JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

Select 
    top_paying_jobs.*,
    skills_dim.skills
From top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
order BY
salary_year_avg DESC;
```
🔢 **SQL & Python Dominate the Top Tier**
- SQL appears in every single role listed, highlighting its absolute necessity for senior data jobs.

- Python is nearly as common — critical for automation, modeling, and ETL.

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql

Select 
skills,
count(skills_job_dim.job_id) as demand_count
From job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
Group BY skills
ORDER BY
demand_count DESC
Limit 5
```
📊 **SQL and Excel Dominate**
- When it comes to remote, Data Analyst positions, SQL, Excel and Python are the best skills to know when comes to finding great paying jobs with flexability.
### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
Select 
skills,
ROUND (AVG (salary_year_avg), 2) AS avg_salary
From job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    and job_work_from_home = TRUE
Group BY skills
ORDER BY
    avg_salary DESC
Limit 25
```
🏢**High-End Tools Dominate the Top**

- PySpark leads with an average of $208,172, suggesting strong demand for distributed data processing skills in large-scale data environments.

- Other high-paying tools like Bitbucket, Couchbase, and Watson point toward companies valuing version control, NoSQL databases, and AI platforms.

🧠 **Engineering & DevOps Tools Are Valuable**

- Tools like GitLab, Jenkins, Kubernetes, and Airflow suggest that DevOps knowledge and pipeline automation enhance data analyst compensation.

- Linux and Golang also rank high, pointing to hybrid roles blending analysis and backend infrastructure.

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
-- Identifies skills in high demand for Data Analyst roles
WITH skills_demand AS (
  SELECT
    skills_dim.skill_id,
		skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	  INNER JOIN
	    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_dim.skill_id
),
-- Skills with high average salaries for Data Analyst roles
average_salary AS (
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	  
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_job_dim.skill_id
)

SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 2) AS avg_salary 
FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
  demand_count > 10
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 25
; 
```
🔥 **Most In-Demand Skills (High Demand Count)**

- SQL (398 postings): Still the most requested skill across data roles. Often a baseline requirement.

- Excel (256): Despite being older tech, it's deeply embedded in workflows, especially for analysts.

- Python (236): High demand with a notably higher salary than Excel and SQL — a core modern skill.

- Tableau (230) and R (148): Solid visualization and statistical analysis tools — commonly requested.

💰 **Top Paying Skills (Highest Average Salary)**

- Go ($115,319) – Low demand (27), but very high salary, indicating niche or backend/data infrastructure roles.

- Hadoop ($113,192), Snowflake ($112,947), Azure ($111,225): These cloud & big data tools are commanding a premium.

- AWS ($108,317) and Oracle ($104,533): Also strong pay with moderate demand — infrastructure-heavy.

- Looker ($103,795) and R ($100,498): High-value BI and statistical skills.

Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

### **What I Learned**

Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

### **Insights**

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### **Conclusion**

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
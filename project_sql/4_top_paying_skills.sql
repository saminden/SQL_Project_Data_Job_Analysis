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

/*
📊 Key Trends & Insights
1. High-End Tools Dominate the Top
PySpark leads with an average of $208,172, suggesting strong demand for distributed data processing skills in large-scale data environments.

Other high-paying tools like Bitbucket, Couchbase, and Watson point toward companies valuing version control, NoSQL databases, and AI platforms.

2. Modern Machine Learning and Data Science Ecosystems
Libraries such as Pandas, Jupyter, NumPy, and Scikit-learn appear prominently.

This confirms that hands-on analysis, exploratory notebooks, and model building are highly rewarded.

3. Engineering & DevOps Tools Are Valuable
Tools like GitLab, Jenkins, Kubernetes, and Airflow suggest that DevOps knowledge and pipeline automation enhance data analyst compensation.

Linux and Golang also rank high, pointing to hybrid roles blending analysis and backend infrastructure.

4. Cloud Proficiency = Higher Salaries
GCP (Google Cloud Platform) and Databricks appear with strong averages, reinforcing the industry shift to cloud-based data pipelines.

5. Less Common = Higher Pay?
Tools like Datarobot, Watson, and Twilio may show high salaries due to their rarity and specialization, suggesting niche skills can command a premium.  /*
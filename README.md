# Introduction & Exex Summary
This is test project using some real job market data for data-focused roles. This project focuses on Data and Business Analyst roles in Switzerland and Germany, exploring top paying jobs and in-demand skills. 

### Key finding
It turns out that sql, python and tableau are the most in-demand skills for data and business roles in this region. Yearly salaries average around 100k, with more specific and niche skills (e.g. spark) commanding a salary premium. 

Interested in the SQL queries used ? Check out: [sql_capstone_project](/sql_capstone_project/)

# Background
### The questions I answer

### Why doing this?


### The data and where it is from?

# Tools Used
### **SQL**
### **PostgreSQL**
### **VS Code**
### **Git & GitHub**

# The Analysis
### 1 - Top paying jobs

Have a little intro

```sql
    SELECT
        job_id,
        name AS company_name,
        job_title,
        job_title_short,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_location LIKE '%Switzerland%'
        OR job_location LIKE '%Germany%')
        AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
    ;
```
Here are the main learnings on top paying jobs
- **aaa**: aaa
- **aaa**: aaa
- **aaa**: aaa


![Image](assets\Capture d’écran 2024-08-02 163449.png)
*Description of the image

### 2 - 

# Key Findings


# Conclusions
### Main insight
### What I learned
# Introduction & Exec Summary
This is test project using some real job market data for data-focused roles. This project focuses on Data and Business Analyst roles, exploring top paying countries in Europe, identifying top-paying positions in the chosen geographies and most in-demand technical skills.

### Key finding
It turns out that Germany and the Netherlands are the highest-paying countries on average for these type of roles. Sql, python and tableau are the most in-demand skills across these geographies. Yearly salaries average slightly below 100k, with more specific and niche skills (e.g. spark) commanding a salary premium. 

### SQL and context
Interested in the SQL queries used ? Check out: [sql_capstone_project](/sql_capstone_project/)

This exercise is done based on the "SQL for Data Analytics - Learn SQL in 4 Hours" course developed by Luke Barousse. Check out the [course on Youtube](https://youtu.be/7mz73uXD9DA?si=2mj-CefmYcr_WW6k).

# Background
### The questions answered
Below are the questions and the order in which they were solved to reach an overall conclusion:
1. **What coutries have the highest average salaries for data analyst and business analyst roles?** 
    This allows to narrow down the search to countries where the average salaries are the highest. Regardless of the average salaries in Switzerland, this country will be included in the sample as this is a country of interest for the author.    
2. **What are the top-paying job postings in the countries of interest?** 
    This allows to identify the top 20 highest paying roles and dive deeper in the expected salaries for the targeted roles. 
3. **What are the top skills across all data analysts and business analysts roles?**
    This is a wider look at the required skills for these positions, extending the search to a wider sample than the top 20 highest paying roles in the chosen geographies. This grants a wider view of potential skills in high-demand.
4. **What is the skill leading to a higher average salary?**
    This allows to identify potential outliars in terms of skills commanding a higher salary premium, meaning it could interesting to further develop these skills.
5. **What are the skills required by the highest paying jobs?**
    This allows to identify the specific technical skills necessary to increase the likelihood of success in obtaining one of the top 20 highest-paying roles identified earlier.


### Why do this?
This is a high-level investigation of roles of interest in the data science and analysis field. This exercise also serves as a practice to further develop and fine-tune SQL skills using a variety of tools.

### What data is used and where is it from?
The data has been provided as part of the "SQL for Data Analytics - Learn SQL in 4 Hours" course. 

The dataset contains four main data tables:
- **Job postings table**: contains hundred of thousands of job postings and their details, such as title, location, salary, company, posting source (website), requirements
- **Company table**: contains company ids, name and link to specific websites
- **Skills per job table**: contains the various technical skills required for each job posting
- **Skills table**: contains the various skills title and type

# Tools Used

### **SQL**
SQL is the language used construct all the queries made on the database. 

### **PostgreSQL**
PostgreSQL is the database provider used to host and access the data for this exercise. Its open source nature makes it easily accessible.

### **VS Code**
VS Code is the code editor used to create all SQL queries necessary for this exercise. Its open source nature makes it easily accessible.

### **Git & GitHub**
Any updates and versioning made to the code are tracked using Git and hosted on GitHub for ease of access and sharing. 

# The Analysis
## 1 - What coutries have the highest average salaries for data analyst and business analyst roles? 

As initial step, various European countries were analysed to identify which ones had the highest average salaries. This helps to identify the geographies with the most lucrative roles and therefore the open roles that could be of a higher interest, all else being equal. A count of the number of jobs meeting the research criteria is also included to understand the depth of the job market in each country.

Not all countries in Europe were included for conciseness' sake. As a comparison point, the United States were also included in the countries examined.

All roles that did not provide salary information were removed of the sample to remove any impact when calculating average yearly salaries.

### SQL query  

```sql
    SELECT
        job_country,
        ROUND(AVG(salary_year_avg),0) AS avg_salary,
        COUNT(*)
    FROM
        job_postings_fact
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_country LIKE '%France%'
        OR job_country LIKE '%Germany%'
        OR job_country LIKE '%Switzerland%'
        OR job_country LIKE '%Italy%'
        OR job_country LIKE '%Spain%'
        OR job_country LIKE '%Portugal%'
        OR job_country LIKE '%United Kingdom%'
        OR job_country LIKE '%Netherlands%'
        OR job_country LIKE '%Belgium%'
        OR job_country LIKE '%Austria%'
        OR job_country LIKE '%Denmark%'
        OR job_country LIKE '%Sweden%'
        OR job_country LIKE '%Norway%'
        OR job_country LIKE '%Estonia%'
        OR job_country LIKE '%United States%'
        )
        AND
        salary_year_avg IS NOT NULL
    GROUP BY
        job_country
    ORDER BY
        avg_salary DESC
    ;
```
### Results

| Country        |   Avg. Salary|# of jobs|
|:---------------|-------------:|--------:|
| United States  |        98044 |    5720 |
| Germany        |        97881 |      74 |
| Netherlands    |        97256 |      24 |
| Spain          |        96910 |      45 |
| Portugal       |        93945 |      44 |
| Belgium        |        93641 |      25 |
| Austria        |        92783 |       6 |
| Sweden         |        91435 |      19 |
| United Kingdom |        88752 |      85 |
| France         |        86137 |      66 |
| Denmark        |        79380 |       5 |
| Italy          |        78199 |      15 |
| Norway         |        75450 |       4 |
| Estonia        |        72262 |      13 |
| Switzerland    |        68620 |      10 |


### Learnings
- **Germany and Netherlands** have the highest average salaries in Europe amongst the examined countries.
- **Spain and Portugal** come in 3rd and 4th place in Europe when it comes to average salary, which may come at a slight surprise given the lower average cost of life in the 2 countries of the Iberic peninsula vis-à-vis the others in the sample.
- **United States** has the highest average salary and the most job postings. This is likely due to the highest prevalence of salary information in US job postings.
- **Low sample size** in many European countries due to the fact that no salary information is included in the majority of the European-based roles. As an example, there are more than 15k job postings in France when accounting for roles without salary information.

## 2 - What are the top-paying job postings in the countries of interest?
Germany and The Netherlands were identified as most lucrative markets for data and business analyst roles and will be the geographies in focus. In addition, Switzerland will be added as this is a geography of interest for the author.

It is time to dig deeper and identify the top 20 paying roles across these 3 countries to identify if the average salary is a good representation of the top dollar a role in this domain can expect.

### SQL
```SQL
    SELECT
        job_id,
        name AS company_name,
        job_title,
        job_title_short,
        job_location,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_country LIKE '%Switzerland%'
        OR job_country LIKE '%Germany%'
        OR job_country LIKE '%Netherlands%')
        AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC,
        job_title
    LIMIT 20
    ;
```
### Results
|job_id  |company_name|job_title|job_title_short    |job_location          |salary_year_avg|
|--------|------------|---------|-------------------|----------------------|---------------|
|107183  |Bosch Group |Research Engineer (f/m/div.)|Data Analyst       |Hildesheim, Germany   |200000.0       |
|1202839 |Bosch Group |Technology Research Engineer for Power Semiconductors (f/m/div.)|Data Analyst       |Renningen, Germany    |200000.0       |
|156108  |Bosch Group |Research Engineer for Security and Privacy  (f/m/div.)|Data Analyst       |Renningen, Germany    |199675.0       |
|1263109 |Fraunhofer-Gesellschaft|Research Engineer* / Research Scientist* for Development of Radar...|Data Analyst       |Germany               |179500.0       |
|24675   |ServiceNow  |Staff Research Engineer|Data Analyst       |Amsterdam, Netherlands|177283.0       |
|59701   |Volt.io     |Head of Data Analytics|Data Analyst       |Berlin, Germany       |166419.5       |
|20461   |PPRO        |Head of Data Analytics (F/M/X)|Data Analyst       |Munich, Germany       |166419.5       |
|931367  |Datalogue GmbH|Data Architect (m/w/d)|Data Analyst       |Hamburg, Germany      |165000.0       |
|1719883 |LyondellBasell|Data Architect - Sustainability|Data Analyst       |Netherlands           |155000.0       |
|1051496 |Netflix     |Analytics Engineer (L5) - Promotional Media - EMEA|Data Analyst       |Amsterdam, Netherlands|147500.0       |
|1432577 |Salesforce  |Sr. Business Analyst - Business Data Governance|Business Analyst   |Mühlhausen, Germany   |126000.0       |
|647890  |Delivery Hero|Senior Data Analyst|Senior Data Analyst|Germany               |119400.0       |
|1437705 |AUTO1 Group |(Senior) Product Data Analyst (f/m/x)|Senior Data Analyst|Berlin, Germany       |111202.0       |
|348471  |Adyen       |Data Analyst, Reporting|Data Analyst       |Amsterdam, Netherlands|111202.0       |
|537995  |Flink       |Data Analyst/Manager - Last Mile Planning (m/f/d)|Data Analyst       |Berlin, Germany       |111202.0       |
|993951  |SIXT        |(Senior) Data Analyst (m/w/d)|Senior Data Analyst|Rostock, Germany      |111175.0       |
|634495  |TeamViewer  |(Senior) Data Analyst / Data Engineer (all genders)|Senior Data Analyst|Göppingen, Germany    |111175.0       |
|221741  |Wolt        |(Senior) Data Analyst, Support domain|Senior Data Analyst|Berlin, Germany       |111175.0       |
|774732  |Grover      |(Senior) People Data Analyst (m/w/x)|Data Analyst       |Germany               |111175.0       |
|1344481 |Magno IT Recruitment|4295 Senior Data Analyst|Senior Data Analyst|Utrecht, Netherlands  |111175.0       |

### Learnings
 - **Best-paying roles** are around 200k and are concentrated within one enterprise in Germany. These are highly technical and senior roles as Research Engineers.
 - **Germany** seem to have the highest concentration of high-paying roles with 13 of the 20 roles in top 20. The 7 remaining roles were in the Netherlands. Larger metropolis are where these roles are most likely to be located as well. 
 - **Data analyst** titles can reasonably expect to earn around 110-120k within companies across a variety of different industries (e.g. delivery services, banking, IT,  media and entertainment) 

## 3 - More generally, what are the top skills across all data analysts and business analysts roles?
To gain a wider perspective on the skills required to increase the likelihood to land a job as a data analyst or business analyst, it would be interesting to look at the top 5 most requested roles across all jobs (across the chosen geographies of Germany, Netherlands and Switzerland).

To get a more comprehensive picture, roles without salary information are also included in this analysis.

### SQL
```SQL
    SELECT
        skills AS skill_name,
        COUNT(*) AS skill_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_country LIKE '%Switzerland%'
        OR job_country LIKE '%Germany%'
        OR job_country LIKE '%Netherlands%')
    GROUP BY 
        skill_name
    ORDER BY 
        skill_count DESC
    LIMIT 5
```
### Results
|skill_name|skill_count|
|----------|-----------|
|sql       |8017       |
|python    |6123       |
|excel     |3642       |
|tableau   |3627       |
|power bi  |3150       |

### Learnings
- **Data programming languages** are the most widely requested skills across the job postings in the geographies of interest. **SQL and Python** are far ahead of any other hard skill when it comes to the number of jobs requesting them.
- **Excel** is still a highly demanded skill due to its versatility and ease of use across a variety of use cases. Spreadsheet skills are still very much relevant.
- **Data visualisation** softwares are again quite in demand and could give an edge to any job seekers in additon to data analysis / querying skills.

## 4 - What is the skill leading to a higher average salary? 
Now that the skills most in request for data and business analyst roles have been identified, let's look at the average salary commanded by each of the skills listed in the job postings to identify the most lucrative ones and if they match with the most requested ones.

Looking at all available postings in Germany, the Netherlands and Switzerland, we have calculated the average yearly salary associated to each skill.

## SQL
```SQL
    SELECT
        skills AS skill_name,
        ROUND(AVG(salary_year_avg), 0) AS yearly_salary,
        COUNT(*) AS skill_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_title_short LIKE '%Data Analyst%' 
        OR job_title_short LIKE '%Business Analyst')
        AND
        (job_country LIKE '%Switzerland%'
        OR job_country LIKE '%Germany%'
        OR job_country LIKE '%Netherlands%')
        AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skill_name
    HAVING
        COUNT(*) > 5
    ORDER BY 
        yearly_salary DESC
    ;
```

## Results
|skill_name|yearly_salary|skill_count|
|----------|-------------|-----------|
|spark     |113885       |14         |
|aws       |101250       |6          |
|sap       |100770       |7          |
|tableau   |98946        |28         |
|python    |96612        |36         |
|looker    |96024        |13         |
|go        |95167        |12         |
|power bi  |93943        |16         |
|sql       |93164        |53         |
|r         |89404        |18         |
|excel     |84747        |21         |

*The count of jobs is here much lower than at step 3 as all postings without any salary information were removed.*


## Learnings
- **Data engineering software**, such as spark, and **cloud computing software**, such as AWS, are the most lucrative skills to possess. ERP softare with SAP seems to always command a slight salary premium.
- **Data visualiation** skills are slightly more lucrative than data programming skills, showcasing the value of being able to transpose complex sets of data into user-friendly reports and dashboards.

## 5 - What are the skills required by the highest paying jobs?
To complete this short analysis, let's now look at the skills required to land one of the top 20 best paying job and if this is in line with all the other jobs out on the market (the results of questions 3 and 4). Let's look at the 10 most requested skills amongst the top 20 best paying jobs across Germany, the Netherlands and Switzerland.

### SQL
```sql
    WITH top_20_paying_jobs AS (
        SELECT
            job_id,
            name AS company_name,
            job_title,
            job_title_short,
            job_location,
            salary_year_avg
        FROM
            job_postings_fact
        LEFT JOIN company_dim
            ON job_postings_fact.company_id = company_dim.company_id
        WHERE
            (job_title_short LIKE '%Data Analyst%' 
            OR job_title_short LIKE '%Business Analyst')
            AND
            (job_country LIKE '%Switzerland%'
            OR job_country LIKE '%Germany%'
            OR job_country LIKE '%Netherlands%')
            AND
            salary_year_avg IS NOT NULL
        ORDER BY
            salary_year_avg DESC
        LIMIT 20
    )

    SELECT 
        skills AS skills_name,
        COUNT(*)
    FROM top_20_paying_jobs
    INNER JOIN
        skills_job_dim
        ON top_20_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
        skills_name
    ORDER BY
        COUNT(*) DESC
    ;
```
### Results

|skills_name|count|
|-----------|-----|
|sql        |8    |
|python     |7    |
|tableau    |6    |
|spark      |5    |
|go         |4    |
|looker     |4    |
|r          |4    |
|excel      |3    |
|gcp        |2    |
|power bi   |2    |


### Learnings
- **Programming** is a highley-demanded skill, with 8 roles requesting SQL knowledge and 7 requiring familiarity with Python. R is slighlty less popular with only 4 roles marking it as a requirement.
- **Data visualition and business intelligence** software are also in demand with tableau being demanded by 6 roles. Only 2 job postings demanded Power BI knowledge, showing a clear favourite amongst the main BI software.
- **Data engineering and machine learning** is also somewhat prevalent with 5 roles requesting spark know-how.

# Conclusions
### Main insight
It seems that the best paying roles in Europe for data analyst and business analyst are mostly prevalent in the Germanic and Dutch regions, although closely followed by Iberic peninsula countries (Spain and Portugal). When looking at the salaries in comparison with the average living cost across the countries, it would be interesting to compare where one is better off, as the slightly lower salaries in the latin countries may be more than compensated by lower costs.

Without any surprise, data programming skills are the most in demand for the type of roles, with skills such as sql and python highly requested. Job seekers looking to increase their likelihood of hiring in this domain should definitely focus on improving these key skills, and should not neglect data visualisation skills (tableau) to add an edge to their skills portfolio. 

The average salary in the observed regions for these analysts roles is slightly under 100k per year. Having familiarity with highly specialised software such as spark or the aws suite of products is a good method to increase the chances of getting a higher pay.

When looking at the top paying-jobs, these also require a command of data programming, highlighting the importance of these skills at all levels of jobs across these markets.

### What I learned
In addition to the learnings related to the analysis and query of the database, this project allowed to significantly develop my data analysis skills. Here are my top 3 takeaways:

1. **SQL**: I significantly improved my SQL skills. Starting as a beginner, I am now familiar with a variety of clauses and complex operations to analyse large dataset in a flexible manner.
2. **Tools**: I learned the basics of multiple tools, from database provider, to code editor, to software used to verison control my code and then publish it for access by curious readers.
3. **Analytical sense**: this course allowed me to renew with data-driven problem-solving methodology and approaches. Since completing my studies, this has been a breath of fresh air and a good example on how to structure the solution to a seemingly complex problem with a very large dataset.   

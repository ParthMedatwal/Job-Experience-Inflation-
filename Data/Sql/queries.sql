-- Entry-Level Job Experience Inflation Analysis
-- Author: Parth Medatwal
-- Dataset: jobs_enriched.csv
-- Database: SQLite

-- Q1: Total jobs and entry-level jobs
SELECT
    COUNT(*) AS total_jobs,
    SUM(is_entry_level) AS entry_level_jobs
FROM jobs;

-- Q2: % of entry-level jobs requiring 3+ years of experience
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN min_experience_years >= 3 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_entry_requires_3plus
FROM jobs
WHERE is_entry_level = 1
  AND min_experience_years IS NOT NULL;

-- Q3: Experience distribution for entry-level jobs
SELECT
    experience_bucket,
    COUNT(*) AS job_count
FROM jobs
WHERE is_entry_level = 1
  AND min_experience_years IS NOT NULL
GROUP BY experience_bucket
ORDER BY job_count DESC;

-- Q4: Transparency of experience requirements
SELECT
    CASE
        WHEN min_experience_years IS NULL THEN 'Not specified'
        ELSE 'Specified'
    END AS experience_disclosure,
    COUNT(*) AS job_count
FROM jobs
WHERE is_entry_level = 1
GROUP BY experience_disclosure;

-- Q5: Entry-level job titles requiring 4+ years
SELECT
    job_title,
    COUNT(*) AS postings
FROM jobs
WHERE is_entry_level = 1
  AND min_experience_years >= 4
GROUP BY job_title
ORDER BY postings DESC
LIMIT 15;

-- Q6: Locations with highest average experience requirements
SELECT
    location,
    ROUND(AVG(min_experience_years), 2) AS avg_required_years,
    COUNT(*) AS postings
FROM jobs
WHERE is_entry_level = 1
  AND min_experience_years IS NOT NULL
GROUP BY location
HAVING postings >= 20
ORDER BY avg_required_years DESC
LIMIT 15;

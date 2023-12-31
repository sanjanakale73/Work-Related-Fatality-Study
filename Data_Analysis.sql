-- 1. What is the number of reported incidents?
SELECT count(incident_date) FROM `fatalities_cleaned`;

-- 2. What is the year-to-year change in the number of fatal incidents?
SELECT current_year, fatalities_count, (LAG(fatalities_count) OVER (ORDER BY current_year)) as previous_year, 
ROUND((fatalities_count - LAG(fatalities_count) OVER (ORDER BY current_year)) / LAG(fatalities_count) OVER (ORDER BY current_year) * 100) as yeartoyear
FROM
    (
        SELECT
        YEAR(incident_date) AS current_year,
        COUNT(*) AS fatalities_count
        FROM fatalities_cleaned
        WHERE YEAR(incident_date) <> 2022
        GROUP BY YEAR(incident_date)
    ) t;
    
-- 3. What is the number of fatalities that received a citation?
select citation, count(*) as n_fatalities
from fatalities_cleaned
group by citation;

-- 4. What day of the week has the most fatalities, and what is the overall percentage?
SELECT
    day_of_week,
    total_fatalities,
    ROUND(total_fatalities / total_fatalities_sum * 100, 2) AS percentage
FROM
    (
    SELECT
        day_of_week,
        COUNT(*) AS total_fatalities,
        (SELECT COUNT(*) FROM fatalities_cleaned) AS total_fatalities_sum
    FROM
        fatalities_cleaned
    GROUP BY
        day_of_week
    ) t
order by total_fatalities desc;

-- 5. What is the number of fatalities involving welding?
SELECT count(*) as no_fatalities
FROM fatalities_cleaned
where description like '%weld%';

-- 6. What are the last 5 fatalities during welding?
SELECT * FROM `fatalities_cleaned` 
where description like '%weld%'
order by incident_date desc
limit 5;

-- 7. Which are the top 5 states with the most fatal incidents?
SELECT state, count(*) as no FROM `fatalities_cleaned`
group by state
order by no DESC
LIMIT 5;

-- 8. What are the top 5 states that had the most workplace fatalities from stabbings?
SELECT state, count(*) as no FROM `fatalities_cleaned`
where lower(description) like '%stabb%'
group by state
order by no DESC
LIMIT 5;

-- 9. What are the top 10 states that had the most workplace fatalities from shootings?
SELECT state, count(*) as no_fatalities FROM `fatalities_cleaned`
where lower(description) like '%shot%'
group by state
order by no_fatalities DESC
LIMIT 10;

-- 10. What is the total number of shooting deaths per year?
SELECT year(incident_date), count(*) as no_fatalities FROM `fatalities_cleaned`
where lower(description) like '%shot%'
group by year(incident_date)
order by no_fatalities DESC;

-- Contest Leaderboard --

SELECT 
    m.hacker_id
    ,m.name
    ,SUM(m.score) AS total_score 
FROM(
    SELECT 
        h1.hacker_id
        ,h1.name
        ,s.challenge_id
        ,MAX(s.score) AS score
    FROM 
        hackers h1
    INNER JOIN 
        submissions s
    USING(
        hacker_id
    )
    GROUP BY 
        1,2,3 AS m
JOIN 
    hackers h2
USING 
    (hacker_id)
GROUP BY 
   1,2
HAVING
    SUM(m.score) > 0
ORDER BY
    total_score DESC 
    ,m.hacker_id;

-- Draw The Triangle 1 --

SELECT 
    REPEAT(
        '* '
        ,@NUMBER := @NUMBER - 1) 
FROM 
  information_schema.tables 
  ,(
    SELECT 
        @NUMBER:=21) t 
LIMIT 
    20;

-- Draw The Triangle 2 --

SELECT 
    REPEAT(
        '* '
        ,@NUMBER := @NUMBER + 1) 
FROM 
  information_schema.tables 
  ,(
    SELECT 
        @NUMBER:=0) t 
LIMIT 
    20;

-- The Report --

SELECT 
    CASE 
        WHEN 
            g.grade < 8 
        THEN NULL 
        ELSE s.name 
    END AS less_than_eight
    ,g.grade, s.marks
FROM 
    students s
    ,grades g
WHERE 
    s.marks >= g.min_mark 
    AND s.marks <= g.max_mark 
ORDER BY 
    g.grade DESC
    ,s.name;

-- Population Census --

SELECT 
    SUM(ci.population)
FROM 
    city ci
JOIN 
    country co
ON 
    ci.countrycode = co.code
WHERE 
    LOWER(co.continent) LIKE 'asia'

-- New Companies --

SELECT 
    c.company_code
    ,c.founder
    ,COUNT(DISTINCT l.lead_manager_code)
    ,COUNT(DISTINCT s.senior_manager_code)
    ,COUNT(DISTINCT m.manager_code)
    ,COUNT(DISTINCT e.employee_code)
FROM 
    company c
JOIN 
    lead_manager l
USING
    (company_code)
JOIN 
    senior_manager s
USING
    (company_code)
JOIN 
    manager m
USING
    (company_code)
JOIN 
    employee e
USING
    (company_code)
GROUP BY 
    c.company_code
    ,c.founder
ORDER BY 
    c.company_code ASC

-- Weather Observation Station 20 --

SELECT 
    ROUND(lats.lat_n,4)
FROM (
    SELECT 
        lat_n, 
        NTILE(2) OVER
        (
        ORDER BY 
            lat_n) as med
        FROM 
            station
        ) lats
WHERE 
    med = 1
ORDER BY 
    lat_n DESC
LIMIT 
    1;

-- Binary Tree Nodes --

SELECT 
    N
    ,CASE
        WHEN P IS NULL
        THEN 'Root'
        WHEN (select count(*) from BST where P = B.N) > 0
        THEN 'Inner'
        ELSE 'Leaf'
    END
FROM 
    BST b
ORDER BY 
    N;

-- Type of Triangle --

SELECT 
    CASE
        WHEN A + B <= C 
            OR A + C <= B 
            OR B + C <= A 
        THEN 'Not A Triangle'
        WHEN A = B 
            AND B = C 
        THEN 'Equilateral'
        WHEN A = B 
            OR B = C 
            OR A = C 
        THEN 'Isosceles'
        ELSE 'Scalene'
    END
FROM 
    TRIANGLES;

-- Weather Observation Station 19 --

SELECT 
    ROUND(SQRT(POWER(MAX(LAT_N) - MIN(LAT_N), 2) + POWER(MAX(LONG_W) - MIN(LONG_W), 2)), 4)
FROM station

-- Top Earners --

SELECT 
    (months*salary) sumsal
    ,COUNT(*)
FROM 
    employee
GROUP BY 
    sumsal
ORDER BY 
    sumsal DESC
LIMIT 
    1

-- The Blunder --

SELECT 
    ROUND(CEIL(AVG(salary)),0) - ROUND(AVG(REPLACE(salary,'0','')),0)
FROM 
    employees

-- Ollivander's Inventory --

SELECT 
    w.id
    ,p.age
    ,w.coins_needed
    ,w.power
FROM 
    wands w
JOIN 
    wands_property p
USING 
    (code)
WHERE 
    w.coins_needed = (
        SELECT 
            min(coins_needed)
        FROM 
            wands w2 
        JOIN 
            wands_property p2 
        USING 
            (code)
        WHERE 
            p2.is_evil = 0 
            AND p.age = p2.age 
            AND w.power = w2.power
    )
ORDER BY 
    w.power DESC
    ,p.age DESC

-- Yelp: Top Businesses With Most Reviews --

SELECT
    name
    ,review_count
FROM
    yelp_business
ORDER BY
    2 DESC
LIMIT
    5

-- City of Los Angeles: Churro Activity Date --

SELECT
    activity_date
    ,pe_description
FROM
    los_angeles_restaurant_health_inspections
WHERE
    facility_name ilike 'street churros'

-- Lyft: Driver Wages --

SELECT
    * 
FROM
    lyft_drivers
WHERE
    yearly_salary <= 30000
    OR yearly_salary >= 70000

-- Spotify: Top Ranked Songs --

SELECT
    trackname
    ,SUM(position)
FROM
    spotify_worldwide_daily_song_ranking
WHERE
    position = 1
GROUP BY
    1
ORDER BY
    2 DESC

-- City of San Francisco: Number of violations

SELECT
    DATE_PART('year',inspection_date) as year
    ,COUNT(inspection_id) n_inspections
FROM
    sf_restaurant_health_violations
WHERE
    LOWER(business_name) like '%roxanne cafe%'
--   AND violation_id IS NOT NULL
GROUP BY
    1
ORDER BY
    1

-- Salesforce: Highest Target Under Manager --

SELECT
    first_name, last_name, max(target)
FROM
    salesforce_employees
WHERE
    manager_id = 13
GROUP BY
    1,2
ORDER BY
    3 desc
LIMIT
    3

-- Yelp: Top Cool Votes --

SELECT
    business_name,review_text
FROM
    yelp_reviews
GROUP BY
    1,2
HAVING
    sum(cool) > 9

-- Amazon: Order Details --

SELECT
    c.first_name
    ,o.order_date
    ,o.order_details
    ,o.total_order_cost
FROM
    customers c
JOIN
    orders o
ON
    c.id = o.cust_id
WHERE
    LOWER(first_name) in('jill','eva')

-- Airbnb: Number Of Bathrooms And Bedrooms --

SELECT
    city
    ,property_type
    ,avg(bedrooms) as avg_bedrooms
    ,avg(bathrooms) as avg_bathrooms
FROM
    airbnb_search_details
GROUP BY
    1,2

-- Doordash: Workers With The Highest Salaries --

SELECT
    t.worker_title as best_paid_title
    ,w.salary
FROM
    worker w
JOIN
    title t
ON
    w.worker_id = t.worker_ref_id
GROUP BY
    1,2
ORDER BY
    2 desc
LIMIT
    2

-- Dropbox: Salaries Differences --

SELECT 
    MAX(salary) FILTER (WHERE d.department like 'marketing')
    -
    MAX(salary) FILTER (WHERE d.department like 'engineering')
FROM
    db_employee e
JOIN
    db_dept d
ON
    e.department_id = d.id;
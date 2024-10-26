select * from employee;
select * from department;

UPDATE employee
SET hire_date = STR_TO_DATE(hire_date, '%m/%d/%Y');


-- 1) Find the employee who has been with the company the longest.
SELECT first_name,
       last_name,
        TIMESTAMPDIFF(YEAR, hire_date, CURRENT_DATE) AS years_since_hired,
       TIMESTAMPDIFF(MONTH, hire_date, CURRENT_DATE) % 12 AS remaining_months_since_hired,
       TIMESTAMPDIFF(day, hire_date, CURRENT_DATE) % 365 AS remaining_days_since_hired,
       DATEDIFF(CURRENT_DATE, hire_date) AS num_of_days_since_hired
FROM employee
ORDER BY num_of_days_since_hired DESC
LIMIT 5;

-- 2) List all employees who work in a city different from their department's main location.
select e.first_name, e.last_name, d.location_city
from employee e
join department d
on e.id = d.id
where location_city not like 'Cleveland';

-- 3)List departments and the number of employees in each city.
select count(e.id) as number_of_employees, d.department, d.location_city
from employee e
join department d
on e.id = d.id
group by d.department, d.location_city
order by number_of_employees desc;

-- 4) Rank employees based on their hire date (seniority) within each department.
select e.id, DATEDIFF(CURRENT_DATE, e.hire_date) AS num_of_days_since_hired, d.department,
rank() over(partition by d.department order by DATEDIFF(CURRENT_DATE, e.hire_date) desc) AS ranks
from employee e 
join department d
on e.id = d.id;

-- 5) Find employees who are in the top 5 highest earners in the company.
select e.first_name, e.last_name, d.salary
from employee e
join department d
on e.id = d.id
order by d.salary desc
limit 5;


-- 6) Classify employees based on their salary levels into three categories: Low, Medium, and High. 
-- Below 60k, Low, between 60k and 90k Medium, above 90k High.
select e.first_name, e.last_name, d.salary,
case 
    when CAST(REPLACE(REPLACE(d.salary, '$', ''), ',', '') AS unsigned) < 60000 then 'Low'
    when CAST(REPLACE(REPLACE(d.salary, '$', ''), ',', '') AS unsigned) between 60000 and 90000 then 'Medium'
    else 'High'
end as salary_category
from employee e 
join department d
on e.id = d.id;


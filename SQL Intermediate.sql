-- joins
select dem.employee_id, age, occupation
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

-- outter joins
select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

-- self join
select sal1.employee_id as emp_santa,
sal1.first_name as first_name_santa,
sal1.last_name as last_name_santa,
sal2.employee_id as emp_name,
sal2.first_name as first_name_emp,
sal2.last_name as last_name_emp
from employee_salary as sal1
join employee_salary as sal2
	on sal1.employee_id +1 = sal2.employee_id
;



-- joining multiple tables together
select *
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
join parks_departments as pd
	on sal.dept_id = pd.department_id
;

select * from parks_departments;


-- unions
select first_name, last_name
from employee_demographics
union all
select first_name, last_name
from employee_salary
;

select first_name, last_name, 'Old Man' as label
from employee_demographics
where age > 40 and gender = 'male'
UNION select first_name, last_name, 'Old Lady' as label
from employee_demographics
where age > 40 and gender = 'female'
union
select first_name, last_name, 'Highest Paid Employee' as label
from employee_salary
where salary > 70000
order by first_name, last_name
;



-- string functions
select length('skyfall');

select first_name, length(first_name) as len
from employee_demographics
order by len
;

select upper('sky');
select lower('SKY');

select first_name, upper(first_name) as cap
from employee_demographics;

select rtrim('              sky              ') as word;

select first_name, 
left(first_name,4),
right(first_name,4),
substring(first_name,3,2),
birth_date, substring(birth_date,6,2) as birth_mmonth
from employee_demographics
;


select first_name, replace(first_name, 'a', 'z')
from employee_demographics
;

select locate('x', 'Alexander');

select first_name, locate('An', first_name)
from employee_demographics
;

select first_name, last_name,
concat(first_name, '   ', last_name)
from employee_demographics
;

-- case statements
select first_name,
last_name, age,
case
	when age <= 30 then 'Young' 
    when age between 31 and 50 then 'Old'
    when age >=50 then "On Death's Door"
end as Age_Bracket
from employee_demographics
;

-- Pay Increase Bonus
-- <5000 = 5%
-- <7000 = 7%
-- Finance = 10%

select first_name, last_name, salary,
case
	when salary <50000 then salary * 1.05
    when salary >50000 then salary * 1.07
end as new_salary,
case
	when dept_id=6 then salary * .10
end as bonus
from employee_salary
;

-- subquerries
select * from employee_demographics
where employee_id in
	(select employee_id
    from employee_salary where dept_id=1)
;

select first_name, salary,
(select avg(salary) from employee_salary)
from employee_salary
;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender
;

select gender, avg(max_age)
from
(select gender,
avg(age) as avg_age, 
max(age) as max_age, 
min(age) as min_age, 
count(age)
from employee_demographics
group by gender) as agg_table
group by gender
;


-- window function
select gender, avg(salary) as avg_salary
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
group by gender
;

select gender, avg(salary) over(partition by gender)
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
;

select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.employee_id) as running_total
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
;


select dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) as row_num,
rank() over(partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) as rank_num
from employee_demographics as dem
join employee_salary as sal
on dem.employee_id = sal.employee_id
;
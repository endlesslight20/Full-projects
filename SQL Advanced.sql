-- CTEs common table sepressions
 with cte_example as
(select gender, avg(salary) as avg_sal, max(salary) as max_sal, min(salary) as min_sal, count(salary) as count_Sal
 from employee_demographics as dem
 join employee_salary as sal
 on dem.employee_id = sal.employee_id
 group by gender)
 
 select *
 from cte_example
 ;
 
  with cte_example (geender, avg_sal, max_sal, min_sal, count_sal) as
(select gender, avg(salary), max(salary), min(salary), count(salary)
 from employee_demographics as dem
 join employee_salary as sal
 on dem.employee_id = sal.employee_id
 group by gender)
 
 select *
 from cte_example
 ;
 
 
  with cte_example as
(select employee_id, gender, birth_date
 from employee_demographics as dem
where birth_date > '1985-01-01'
 ),
 cte_example2 as 
 (select employee_id, salary
 from employee_salary
 where salary > 50000
 )
 select *
 from cte_example
 join cte_example2
 on cte_example.employee_id=cte_example2.employee_id
 ;
 
-- temp tables
create temporary table temp_table
(first_namne varchar(50),
last_name varchar(50),
favourite_movie varchar(100)
); 



insert into temp_table
values
('alex', 'freeberg', 'lord of the rings: the two towers')
;

select *
from temp_table
;

select *
from employee_salary
;

create temporary table salary_over_50k
select * 
from employee_salary
where salary >= 50000;

select * 
from salary_over_50k;
 
 
 -- stored procedures
 
 create procedure large_salaries()
 select  *
 from employee_salary
 where salary >= 50000
 ;
 
 call large_salaries();
 
delimiter $$
create procedure large_salaries2()
begin
	 select  *
	 from employee_salary
	 where salary >= 50000;
	  select  *
	 from employee_salary
	 where salary >= 10000;
end $$
delimiter ;
 
 call large_salaries2();
 
 call new_procedure();
 
 
delimiter $$
create procedure large_salaries3(p_employee_id int)
begin
	 select  salary
	 from employee_salary
     where employee_id = p_employee_id
     ;
end $$
delimiter ;
 
call large_salaries3(1);


-- triggers and events


insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values
(13, 'John Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

select *
from employee_salary;

-- events
select *
from employee_demographics;

delimiter $$
create event delete_retiree
on schedule every 30 second
do
begin
delete
from employee_demographics
where age >=60
end
delimiter ;

-- data cleaning
select *
from world_layoff.layoffs;

-- STEPS FOR CLEANING
-- 1. remove duplicates
-- 2. stamdadise the data
-- 3. NULL or BLANK values
-- 4. remove unnessary columns or rows

CREATE TABLE layoffs
like layoffs_staging;

insert layoffs
select *
from layoffs_staging;
 
 select *
 from layoffs;
 
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;
 
with duplicate_cte as(
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging)
select *
from duplicate_cte
where row_num > 1 ;
 
 select *
from layoffs_staging
where company = 'casper';
;
 
 with duplicate_cte as(
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging)
delete
from duplicate_cte
where row_num > 1 ;
 
 select *
 from layoffs_staging2;
 
 insert into layoffs_staging2
 select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;
 
 select *
 from layoffs_staging2
 where row_num=2;
 
  delete
 from layoffs_staging2
 where row_num>1;
 
  select *
 from layoffs_staging2
 where row_num > 1;
 
 -- standardise date
 select distinct company, trim(company)
 from layoffs_staging2;
 
 select distinct industry, trim(industry)
 from layoffs_staging2
 order by 1;
 
 update layoffs_staging2
 set company = trim(company);
 
  select *
 from layoffs_staging2
 where industry like 'crypto%';
 
 update layoffs_staging2
 set industry = 'crypto'
 where industry like 'crypto%';
 
 select distinct country
 from layoffs_staging2
 where country like 'united states%';
 
 update layoffs_staging2
 set country = trim(trailing '.' from country)
 where country like 'united states%';
 
 select `date`
  from layoffs_staging2;
 
 update layoffs_staging2
 set `date` = str_to_date(`date`, '%m/%d/%Y');
 
 alter table layoffs_staging2
 modify column `date` date;

 select *
 from layoffs_staging2
 where industry is null
 or industry =''; 
 
 select *
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 select *
 from layoffs_staging2 t1
 join layoffs_staging2 t2
 on t1.company = t2.company
 where t1.industry is null
 and t2.industry is not null;
 
 update layoffs_staging2
 set industry = null
 where industry = ' ';
 
 
 delete
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 
  select *
 from layoffs_staging2;
 
 alter table layoffs_staging2
 drop column row_num;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
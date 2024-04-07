-- Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.
create database employee;
use employee;

create table emp_record_table(emp_id varchar(20), first_name varchar(20), last_name varchar(20), gender char, role varchar(30), dept varchar(20), exp float, country varchar(20), continent varchar(20), salary float,
emp_rating int, manager_id varchar(20), proj_id varchar(20));

create table proj_table(proj_id varchar(20), proj_name varchar(50), domain varchar(20),start_date date, closure_date date, dev_qtr varchar(20), status varchar(20));

create table data_science_team(emp_id varchar(20), first_name varchar(20), last_name varchar(20), gender char, role varchar(30), dept varchar(20), exp float, country varchar(20), continent varchar(20));

-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
select emp_id, first_name, last_name, gender, dept from emp_record_table;

-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is less than two
select emp_id, first_name, last_name, gender, dept as department from emp_record_table where emp_rating < 2;

-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is greater than four
select emp_id, first_name, last_name, gender, dept as department from emp_record_table where emp_rating > 4;

-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is between two and four
select emp_id, first_name, last_name, gender, dept as department from emp_record_table where emp_rating between 2 and 4;

-- Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
select concat(first_name,' ',last_name) as name from emp_record_table where dept = 'finance';

-- Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President). ///////////
select m.emp_id, m.first_name, m.last_name, m.role, m.exp, count(e.emp_id) as 'emp_count' from emp_record_table m inner join emp_record_table e on m.emp_id = e.manager_id group by e.emp_id order by e.emp_id;

-- Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
select emp_id, first_name, last_name, dept from emp_record_table where dept = 'healthcare' union select emp_id, first_name, last_name, dept from emp_record_table where dept = 'finance' order by dept, emp_id;

-- Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
select m.emp_id, m.first_name, m.last_name, m.role, m.dept, m.emp_rating, max(m.emp_rating) over(partition by m.dept) as 'max_dept_rating' from emp_record_table m order by dept;

-- Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table. ///////////
select emp_id, first_name, last_name, role, max(salary), min(salary) from emp_record_table
where role in('PRESIDENT','LEAD DATA SCIENTIST','SENIOR DATA SCIENTIST','MANAGER','ASSOCIATE DATA SCIENTIST','JUNIOR DATA SCIENTIST') group by role;

-- Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
select emp_id, first_name, last_name, exp, rank() over(order by exp) exp_rank from emp_record_table;

-- Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
create view emp_in_various_countries as select emp_id, first_name, last_name, salary from emp_record_table where salary > 6000;
select*from  emp_in_various_countries;

-- Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
select emp_id, first_name, last_name, exp from emp_record_table where emp_id in(select manager_id from emp_record_table);

-- Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
Delimiter &&
create procedure exp_details()
BEGIN
select emp_id, first_name, last_name, exp from emp_record_table where exp > 3;
END &&
call exp_details();

-- Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
Delimiter &&
create function emp_role(exp int)
 returns varchar(30) deterministic
begin
 declare emp_role varchar(30);
 if (exp>12 and 16) then
 set emp_role='Manager';
 elseif (exp>10 and 12) then
 set emp_role='Lead Data Scientist';
 elseif (exp>5 and 10) then
 set emp_role='Senior Data Scientist';
 elseif (exp>2 and 5) then
 set emp_role='Junior Data Scientist';
 end if;
 return (emp_role);
 end&&
 select exp, emp_role(exp) from data_science_team;
 
 
 
 -- Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
 create index firstname on emp_record_table(first_name);
 select*from emp_record_table where first_name = 'Eric';
 show index from emp_record_table;

-- Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
update emp_record_table set salary =(select salary +(select salary*0.05*emp_rating));
select*from emp_record_table; 

-- Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
select emp_id, first_name, last_name, country, continent, salary,
avg(salary) over(partition by country) avg_salary_in_country,
avg(salary) over(partition by continent) avg_salary_in_continent from emp_record_table;





























-- Table Schemata
CREATE TABLE departments(
	dept_no VARCHAR(30) PRIMARY KEY,
	dept_name VARCHAR(30) NOT NULL

);


CREATE TABLE department_emp(
	employee_no VARCHAR(30),
	dept_no VARCHAR(30),
	from_date VARCHAR(30) NOT NULL,
	to_date VARCHAR(30) NOT NULL,
	PRIMARY KEY (employee_no, dept_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)

);

CREATE TABLE department_manager(
	dept_no VARCHAR(30),
	employee_no VARCHAR(30),
	from_date VARCHAR(30) NOT NULL,
	to_date VARCHAR(30) NOT NULL,
	PRIMARY KEY (dept_no, employee_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)

);

CREATE TABLE employees(
	employee_no VARCHAR(30) PRIMARY KEY,
	birth_date VARCHAR(30) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	gender VARCHAR(30) NOT NULL,
	hire_date VARCHAR(30) NOT NULL

);

CREATE TABLE salaries(
	employee_no VARCHAR(30) NOT NULL,
	salaries VARCHAR(30) NOT NULL,
	from_date VARCHAR(30) NOT NULL,
	to_date VARCHAR(30) NOT NULL,
	FOREIGN KEY (employee_no) REFERENCES employees(employee_no)

);

CREATE TABLE titles(
	employee_no VARCHAR(30) NOT NULL,
	title VARCHAR(30) NOT NULL,
	from_date VARCHAR(30) NOT NULL,
	to_date VARCHAR(30) NOT NULL,
	FOREIGN KEY (employee_no) REFERENCES employees(employee_no)

);

-- import csvs into pgAdmin

-- Queries

-- create view of emoloyee no, last name, first name, gender, salary
CREATE VIEW employees_salary AS
	SELECT e.employee_no, e.last_name, e.first_name, e.gender, s.salaries
	FROM employees e, salaries s 
	WHERE e.employee_no = s.employee_no;

SELECT * FROM employees_salary

-- list employees hired in 1986

CREATE VIEW eighties_employees AS
	SELECT *
	FROM employees
	WHERE hire_date > '1986-01-01' AND hire_date < '1986-12-31';

SELECT * FROM eighties_employees

-- list the manager of each department with: department number, 
-- department name, the manager's employee number, last name, 
-- first name, and start and end employment dates.

CREATE VIEW manager_view AS
	SELECT dm.dept_no, d.dept_name, dm.employee_no, e.last_name, e.first_name, e.hire_date, s.to_date
	FROM departments d, department_manager dm, employees e, salaries s
	WHERE dm.dept_no = d.dept_no AND dm.employee_no = e.employee_no AND e.employee_no = s.employee_no;

SELECT * FROM manager_view

-- List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.

CREATE VIEW dept_employees AS
	SELECT de.employee_no, de.dept_no, d.dept_name
	FROM department_emp de, departments d
	WHERE de.dept_no = d.dept_no;

CREATE VIEW dept_emp_concat AS
	SELECT de.employee_no, e.first_name, e.last_name, de.dept_name
	FROM dept_employees de, employees e
	WHERE de.employee_no = e.employee_no;

SELECT * FROM dept_emp_concat

-- List all employees whose first name is "Hercules" and last names begin with "B."

CREATE VIEW hercules_b AS
	SELECT *
	FROM employees
	WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

SELECT * FROM hercules_b

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT * 
FROM dept_emp_concat 
WHERE dept_name = 'Sales';

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT * 
FROM dept_emp_concat 
WHERE dept_name = 'Sales' OR dept_name = 'Development';

-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT first_name, COUNT(first_name) AS "employee count"
FROM employees
GROUP BY first_name
ORDER BY "employee count" DESC;

-- BONUS - PANDAS: Create a histogram to visualize the most common salary ranges for employees.
-- BONUS - PANDAS: Create a bar chart of average salary by title.


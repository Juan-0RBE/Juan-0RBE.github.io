-- Traer nombre del empleado, y traer nombre del departamento, cuando es el departamento 80
SELECT *
FROM EMPLOYEES INNER JOIN DEPARTMENTS 
ON EMPLOYEES.department_id=DEPARTMENTS.department_id
WHERE DEPARTMENTS.department_id = 80;

-- Traer todos los empleados y todos los departamentos
SELECT first_name, department_name
FROM EMPLOYEES LEFT JOIN DEPARTMENTS 
ON EMPLOYEES.department_id=DEPARTMENTS.department_id AND EMPLOYEES.department_id IS NULL;


SELECT first_name, department_name
FROM EMPLOYEES FULL OUTER JOIN DEPARTMENTS 
ON EMPLOYEES.department_id=DEPARTMENTS.department_id;


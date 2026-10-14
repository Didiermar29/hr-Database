CREATE OR REPLACE PACKAGE BODY pkg_bonus AS

    c_sales_dept CONSTANT departments.department_name%TYPE := 'Sales';

    FUNCTION calc_bonus(p_employee_id IN employees.employee_id%TYPE)
        RETURN NUMBER
    IS
        v_salary employees.salary%TYPE;
        v_dept   departments.department_name%TYPE;
    BEGIN
        SELECT e.salary, d.department_name
          INTO v_salary, v_dept
          FROM employees e
          JOIN departments d ON d.department_id = e.department_id
         WHERE e.employee_id = p_employee_id;

        RETURN v_salary * CASE WHEN v_dept = c_sales_dept THEN 0.10 ELSE 0.05 END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END calc_bonus;

    PROCEDURE generate_year_bonus(p_year IN NUMBER) IS
    BEGIN
        MERGE INTO employee_bonus b
        USING (
            SELECT e.employee_id,
                   CASE
                       WHEN d.department_name IS NULL THEN 0
                       WHEN d.department_name = c_sales_dept THEN e.salary * 0.10
                       ELSE e.salary * 0.05
                   END AS bonus_amount
              FROM employees e
              LEFT JOIN departments d ON d.department_id = e.department_id
        ) s
           ON (b.employee_id = s.employee_id AND b.bonus_year = p_year)
         WHEN MATCHED THEN
              UPDATE SET b.bonus_amount = s.bonus_amount
         WHEN NOT MATCHED THEN
              INSERT (employee_id, bonus_year, bonus_amount)
              VALUES (s.employee_id, p_year, s.bonus_amount);
        COMMIT;
    END generate_year_bonus;

END pkg_bonus;
/

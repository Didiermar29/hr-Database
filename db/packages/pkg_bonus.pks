CREATE OR REPLACE PACKAGE pkg_bonus AS
    FUNCTION calc_bonus(p_employee_id IN employees.employee_id%TYPE)
        RETURN NUMBER;

    PROCEDURE generate_year_bonus(p_year IN NUMBER);
END pkg_bonus;
/

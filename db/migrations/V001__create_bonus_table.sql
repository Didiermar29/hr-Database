CREATE TABLE employee_bonus (
    bonus_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id  NUMBER NOT NULL REFERENCES employees(employee_id),
    bonus_year   NUMBER(4) NOT NULL,
    bonus_amount NUMBER(12,2) NOT NULL,
    created_at   DATE DEFAULT SYSDATE,
    CONSTRAINT uq_bonus UNIQUE (employee_id, bonus_year)
);

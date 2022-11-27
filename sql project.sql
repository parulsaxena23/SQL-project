use employee;
select * from emp_record_table ;
select * from proj_table ;
select * from data_science_team ;
select EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT from emp_record_table;

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT from emp_record_table
where (EMP_RATING<2 );

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT from emp_record_table
where (EMP_RATING>4 );

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT from emp_record_table
where (EMP_RATING >2 and EMP_RATING <4 );

select EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT
 from emp_record_table
where (EMP_RATING <2 or EMP_RATING >4 or (EMP_RATING >2 and EMP_RATING <4 ));

alter table emp_record_table 
add NAME varchar(40) generated always as(concat (FIRST_NAME,' ',LAST_NAME) );
select NAME from emp_record_table;

select m.EMP_ID, m.FIRST_NAME, m.EXP, m.DEPT, count(e.EMP_ID) as EMP_REPORTING
from emp_record_table m
inner join emp_record_table e
 on m.EMP_ID= e.MANAGER_ID
and e.EMP_ID != e.MANAGER_ID 
where m.ROLE in ("PRESIDENT","MANAGER","LEAD DATA SCIENTIST", "JUNIOR DATA SCIENTIST","SENIOR DATA SCIENTIST","ASSOCIATE DATA SCIENTIST")
group by m.EMP_ID;

SELECT m.EMP_ID, m.FIRST_NAME, m.DEPT from emp_record_table m 
where DEPT= "HEALTHCARE"
union
SELECT e.EMP_ID, e.FIRST_NAME, e.DEPT from emp_record_table e
where DEPT= "FINANCE";

SELECT e.EMP_ID, e.FIRST_NAME, e.ROLE, e.DEPT, e.EMP_RATING,
 (max(e.EMP_RATING)  over (partition by DEPT)) as max_emp_rating
 from emp_record_table e
 order by DEPT;

select ROLE,
max(SALARY) over(partition by ROLE) max_salary, 
min(SALARY) over(partition by ROLE) min_salary
from emp_record_table;

select EMP_ID,FIRST_NAME,GENDER,DEPT,EXP, 
rank()over(order by EXP)emp_exp_ranking, 
dense_rank() over(order by EXP)emp_denserank
from emp_record_table;

create or replace view emp_view as 
select EMP_ID,FIRST_NAME,LAST_NAME,DEPT,COUNTRY,SALARY
from emp_record_table
where SALARY>6000 
order by COUNTRY;

select * from emp_view;

select e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.EXP
from emp_record_table e
where e.EMP_ID in
(select m.EMP_ID from emp_record_table m where EXP>10 );
 
delimiter $$
create procedure temp_exp()
begin
select * from emp_record_table where EXP > 3;
end $$

call temp_exp();

delimiter &&
create function org_stand2(EXP int)
returns varchar(50)
DETERMINISTIC
BEGIN
    DECLARE emplevel VARCHAR(300);

    IF EXP <=2 THEN
		SET empLevel = 'JUNIOR DATA SCIENTIST';
    ELSEIF (EXP >= 2 AND 
			EXP <= 5) THEN
        SET emplevel = 'ASSOCIATE DATA SCIENTIST';
        ELSEIF (EXP >= 5 AND 
			EXP <= 10) THEN
        SET emplevel = 'SENIOR DATA SCIENTIST';
        ELSEIF (EXP >= 10 AND 
			EXP <= 12) THEN
        SET emplevel = 'LEAD DATA SCIENTIST';
    ELSEIF (EXP >= 12 AND 
			EXP <= 16) THEN
        SET emplevel = 'MANAGER';
    END IF;

	RETURN (emplevel);
END &&
DELIMITER ;

SELECT EMP_ID, FIRST_NAME,DEPT,ROLE, org_stand2(EXP) as emplevel FROM emp_record_table;


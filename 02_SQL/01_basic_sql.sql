-- 주석
/* 
block 주석 - 여러줄 주석
aaaaaa/*중간 주석입니다 */  -- 주석입니다.
/*sql문을 실행 : control + enter -- 우리가 작성한 쿼리문을 DMBS에 전송
*/


-- 사용자 계정 생성.
-- 로컬 접속 사용자 계정 
create user 'happy_noodle'@'localhost' identified by '3535';-- 로컬 접속하는 아이디입니다.

-- 대문자 소문자 상관없음, 보통 SQL 키워드는 대문자로 하긴 함 

-- 원격접속사용자 계정

create user 'happy_noodle'@'%' identified by '3535'; 
-- 등록된 사용자 계정 조회.
select user, host from mysql.user;

-- 생성한 계정에 권한 부여(모든 권한)
grant all privileges on *.* to 'happy_noodle'@'localhost';
grant all privileges on *.* to 'happy_noodle'@'%';
-- 로컬접속과 원격접속은 개별이라고 보면 됨. 그러니까 해피누들에 권한 2개 줘야함

-- grant 부여할 권한 on Database.테이블 to 계정 
 
 
 -- database 생성 
 create database testdb;
 
 
 -- 파이썬과 비슷한 결이 있다. table = class , 행 = instance
 
use testdb;

create database pokemon;

-- select 컬럼명, 컬럼명  * 모든컬럼
-- from 테이블명 

select * from emp;
-- select * from hr.emp; 아직 데이터베이스 지정 안했으면 이렇게 하면되! 

select distinct job from emp; -- 중복된 것은 하나만 조회.

select distinct job, dept_name -- distinct는 하나에만 붙일 수 있음 , 행에 같은 데이터는 중복으로 처리, 값중 하나라도 같으면 중복으로 처리하지 않음
from emp;

 # emp_id에서 조회한 것을 직원이름(별칭-alia)으로 사용자에게 전달 , as 생략가능
select emp_id as 직원ID , emp_name as 바부, hire_date as 입사일, salary 급여, dept_name "소속      부서" -- "" 하면 규칙에 안맞는 별칭.. 띄어쓰기로 인한 에러 방지
from emp;

use hr;

-- 저장도 테이블 단위로 되고있음
/*


*/

/* **************************************
연산자 
- 산술 연산자 
	- +, -, *, /, %, mod, div (몫 연산)
- 여러개 값을 합쳐 문자열로 반환
	- concat(값, 값, ...)
- 피연산자가 null인 경우 결과는 null
- 연산은 그 컬럼의 모든 값들에 일률적으로 적용된다.
- 같은 컬럼을 여러번 조회할 수 있다.
************************************** */

select emp_name, 30 "값" 
from emp; 

-- 산술 연산

select 1*352525, 1+1, 30-20, 10%4, 10 mod 4, 10 div 3 ;-- 몫만 나오는 ;
select 1+1+null ; 

-- 문자열 합치기 
select concat(100, '세', 300.2, '세'); # 문자열 합치는 것 

-- EMP 테이블에서 직원의 이름(emp_name), 급여(salary) 그리고  급여 + 1000 한 값을 조회.
select emp_name, concat('$',salary) as '급여' ,concat('$',salary +1000) as '연봉인상 후 값' from emp;

-- EMP 테이블의 업무(job)이 어떤 값들로 구성되었는지 조회 - 동일한 값은 하나씩만 조회되도록 처리
select distinct job 
from emp;

-- EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션_PCT(comm_pct), 급여에 커미션_PCT를 곱한 값을 조회.
select emp_id,
emp_name,
salary,
comm_pct,
salary * comm_pct -- 같은 행끼리 계산(컬럼간 계산) 
from emp;

-- EMP 테이블에서 급여(salary)을 연봉으로 조회. (곱하기 12)
select salary, salary * 12 
from emp;



/* *************************************
where 절을 이용한 행 선택 

주의 : mysql은 비교시 대소문자를 가리지 않는다.
      ex) select * from emp where emp_name = 'steven'; Steven 조회된다.
     대소문자 구별해서 비교하게 하려면 컬럼명 앞에 BINARY를 붙인다.
	  ex) where BINARY emp_name = 'Steven' and BINARY job_id='aD_PRES';
************************************* */
# %는 아무거나 0글자 이상
# where address like '종로_' 종로다음 아무거나 한글자 
# 아무거나 한글자;
# '%종로'
# where emp_id is null 이 맞고, where emp_id = null은 값 잘 안나옴

-- EMP 테이블에서 직원_ID(emp_id)가 110인 직원의 이름(emp_name)과 부서명(dept_name)을 조회

SELECT emp_id,
dept_name
FROM emp;
WHERE emp_id = 100;
 
-- EMP 테이블에서 'Sales' 부서에 속하지 않은 직원들의 ID(emp_id), 이름(emp_name),  부서명(dept_name)을 조회.
select emp_id, emp_name, dept_name
from emp
where dept_name !='sales'; # dept_name <>'sales';

-- EMP 테이블에서 급여(salary)가 $10,000를 초과인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id, emp_name, salary
from emp
where salary > 10000;
 
-- EMP 테이블에서 커미션비율(comm_pct)이 0.2~0.3 사이인 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
select emp_id, emp_name, comm_pct
from emp
where comm_pct between 0.2 and 0.3 ;


-- EMP 테이블에서 업무(job)가 'IT_PROG' 거나 'ST_MAN' 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select emp_id, emp_name, job
from emp
where job in ('IT_PROG', 'ST_MAN');
-- where job = 'IT_PROG' or job = 'ST_MAN';


-- EMP 테이블에서 직원 이름(emp_name)이 S로 시작하는 직원의  ID(emp_id), 이름(emp_name)을 조회.
select emp_id, emp_name
from emp
where emp_name like 's%';

-- EMP 테이블에서 직원 이름(emp_name)의 세 번째 문자가 “e”인 모든 사원의 이름을 조회
select emp_name
from emp
where emp_name like '__e%';

-- EMP 테이블에서 직원의 이름에 '%' 가 들어가는 직원의 ID(emp_id), 직원이름(emp_name) 조회
--    %나 _ 를 검색하는 값으로 사용할 경우. 
select emp_id, emp_name
from emp
where emp_name like '%!%%' escape '!';

-- EMP 테이블에서 부서명(dept_name)이 null인 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select emp_id, emp_name, dept_name
from emp
where dept_name is null; -- *dept_name = null은 틀린 쿼리 


-- EMP 테이블에서 업무(job)가 'IT_PROG'인 직원들의 모든 컬럼의 데이터를 조회. 
select * from emp
where job = 'IT_PROG';

-- EMP 테이블에서 급여(salary)가 $10,000 이상인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id, emp_name,salary
from emp
where salary >= 10000;

-- 급여(salary)가 $4,000에서 $8,000 사이에 포함된 직원들의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id, emp_name, salary
from emp
where salary between 4000 and 8000; # 4천과 8천도 포함, 
-- not between으로 하면 반대 결과를 가져올 수 있음 .. 4천과 8천 포함 

-- where salary not between 4000.1 and 7999.9 4천과 8천 포함



-- EMP 테이블에서 2004년에 입사한 직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
-- 참고: date/datatime에서 년도만 추출: year(컬럼명)
select emp_id, emp_name, hire_date
from emp
-- where hire_date between '2004-01-01' and '2004-12-31'; 
where year(hire_date) = 2004; # 연도만 추출하는 함수

select year(hire_date) from emp;
-- EMP 테이블에서 직원의 ID(emp_id)가 110, 120, 130 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회
select emp_id, emp_name, job
from emp
-- where emp_id in (110, 120, 130);
where emp_id not in(110,120,130);

-- EMP 테이블에서 'Sales' 와 'IT', 'Shipping' 부서(dept_name)가 아닌 직원들의 모든 정보를 조회.
select * 
from emp
where dept_name not in('sales', 'IT', 'shippping');

-- EMP 테이블에서 업무(job)가 'MAN'로 끝나는 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select emp_id, emp_name, job
from emp
where job like '%man';
-- not like '%man'이면 man으로 끝나지 않는 것 

-- EMP 테이블에서 커미션이 없는(comm_pct가 null인)  모든 직원의 ID(emp_id), 이름(emp_name), 급여(salary) 및 커미션비율(comm_pct)을 조회
select emp_id, emp_name, salary, comm_pct
from emp
where comm_pct is not null;

-- EMP 테이블에서 연봉(salary * 12) 이 200,000 이상인 직원들의 모든 정보를 조회.
select * 
from emp
where salary*12 >200000;

/* ******************************************
 WHERE 조건이 여러개인 경우 AND 나 OR 로 조건들을 묶어준다.
 
 AND: 두 조건이 모두 True인 행만 조회
 OR: 두 조건 중 하나이상이 True인 행을 조회
 
 연산 우선순위: AND > OR
 	where 조건1 and 조건2 or 조건3
	  1. 조건 1 and 조건2
	  2. 1결과 or 조건3
 
 or를 먼저 하려면 where 조건1 and (조건2 or 조건3)
 *******************************************/
 
-- EMP 테이블에서 'SA_REP' 업무를 담당하는 직원들 중 급여(salary)가 $9,000인 직원의 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id, emp_name, job, salary
from emp
where job = 'SA_REP' and salary = 9000;

-- EMP 테이블에서 업무(job)가 'FI_ACCOUNT' 거나 급여(salary)가 $8,000 이상인 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select emp_id, emp_name, job, salary
from emp
where not( job = 'fi_account'
or	salary>=8000) ; # a or b 를 뒤집으면 ~a and ~b로 나옴. 논리학 그대로 따라가네.


-- EMP 테이블에서  'Sales' 부서 직원 중 업무(job)가 'SA_MAN' 이고 급여가 $13,000 이하인 모든 정보를 조회
select * from emp
where dept_name ='sales'
and job = 'sa_man'
and salary <= 13000;

-- EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서(dept_name)가 'Shipping' 이고 2005년이후 입사한 
--           직원들의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date),부서(dept_name)를 조회
select *
from emp
where job like '%man%'
and dept_name = 'shipping'
and year(hire_date) >=2005;

-- EMP 테이블에서, 'Executive'나 'Shipping'  부서직원 중 급여(salary)가 6000 이상인 직원들의 모든 정보 조회. 
select *
from emp
where dept_name in ('executive', 'shipping')
and salary >= 6000 ;

-- EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 'Marketing' 이나 'Sales' 부서에 소속된 직원들의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)를 조회

select emp_id, emp_name, job, dept_name
from emp
where job like '%man%' 
and dept_name in ('marketing', 'sales');
-- and (dept_name = 'marketing' or 'sales');

-- man 들어가는 직원들 중에 salary 10000 이하이거나 2008년 이후 입사한 직원 조회 
select * from emp
where job like '%man%'
and   (salary <=10000
or year(hire_date) >= 2008);


/* *******************************************************************
order by를 이용한 정렬
- order by절은 select문의 마지막 구문으로 온다.
- order by 정렬기준컬럼 정렬방식 [, ...]
    - 정렬기준컬럼 지정 단위: 컬럼이름, 컬럼의순번(select절의 선언 순서)
     `select salary, hire_date from emp ...` 에서 salary 컬럼 기준 정렬을 설정할 경우. 
     `order by salary 또는 order by 1` 로 작성.
	 
    - 정렬방식
        - ASC : 오름차순, 기본방식(생략가능)
        - DESC : 내림차순
		
문자열 오름차순 : 숫자 -> 대문자 -> 소문자 -> 한글     
Date 오름차순 : 과거 -> 미래
null 오름차순 : null이 먼저 나온다.  GUIDE: 오라클은 반대.

ex)
order by salary asc, emp_id desc 그러면 salary로 먼저 정렬하고, emp로 2차 정렬하는거.. 
- salary로 전체 정렬을 하고 salary가 같은 행은 emp_id로 정렬.
******************************************************************* */

--  직원들의 전체 정보를 직원 ID(emp_id)가 큰 순서대로 정렬해 조회
select * 
from emp
order by emp_id desc  ;


--  직원들의 id(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 
--  업무(job) 순서대로 (A -> Z) 조회하고 업무(job)가 같은 직원들은 급여(salary)가 높은 순서대로 2차 정렬해서 조회.
select emp_id, emp_name, job, salary
from emp
-- order by job, salary desc;
order by 3,4 desc;  -- select 절의 column 순서로 지정 가능 
-- 부서명을 부서명(dept_name)의 오름차순으로 정렬해 조회하시오.
select * from emp
order by dept_name ;  -- asc 생략 가능 



-- 급여(salary)가 $5,000을 넘는 직원의 ID(emp_id), 이름(emp_name), 급여(salary)를 급여가 높은 순서부터 조회
select emp_id, emp_name, salary
from emp
where salary> 5000 -- where을 order by 보다 먼저 써야한다.
order by salary desc;



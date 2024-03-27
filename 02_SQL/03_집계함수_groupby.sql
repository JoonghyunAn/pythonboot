# select 컬럼 
# from 테이블
# where 행

/* **************************************************************************
집계(Aggregation) 함수와 GROUP BY, HAVING
************************************************************************** */

/* ******************************************************************************************
# 집계함수, 그룹함수, 다중행 함수

- 인수(argument)는 컬럼.
  - sum(): 전체합계
  - avg(): 평균
  - min(): 최소값
  - max(): 최대값
  - stddev(): 표준편차 standard deviation  # 제곱하고 루트  # 표준편차 10이면 평균으로부터 10점 .. 30이면 평균으로부터 30점 
  - variance(): 분산 # 제곱 
  - count(): 개수
        - 인수: 
            - 컬럼명: null을 제외한 값들의 개수.
            -  *: 총 행수 - null과 관계 없이 센다.
  - count(distinct 컬럼명): 고유값의 개수.
  
- count(*) 를 제외한 모든 집계함수들은 null을 제외하고 집계한다. 
	- (avg, stddev, variance는 주의)
	- avg(), variance(), stddev()은 전체 개수가 아니라 null을 제외한 값들의 평균, 분산, 표준편차값이 된다.=>avg(ifnull(컬럼, 0))
- 문자타입/일시타입: max(), min(), count()에만 사용가능 # 날짜나 시간은 가장 오래된게 min, 가장 최근이 max 
	- 문자열 컬럼의 max(): 사전식 배열에서 가장 마지막 문자열, min()은 첫번째 문자열. 
		- 특수문자 < 숫자 < 영문대문자 < 영문소문자 < 한글
        - '#' '2' 'A' 'a' '가'   -- '가' max  , '#' min 
	- 일시타입 컬럼은 오래된 값일 수록 작은 값이다.

******************************************************************************************* */

-- EMP 테이블에서 급여(salary)의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 총직원수를 조회 
select sum(salary), 
	   round(avg(salary),2) as avgsalary,
       round(stddev(salary), 2),
       variance(salary) as 'variance(salary)',
       min(salary),
       max(salary)
       
from emp;

select count(*),
	   count(emp_id) -- not null 컬럼으로 count == count(*)
from emp; # 총 행수 

-- EMP 테이블에서 가장 최근 입사일(hire_date)과 가장 오래된 입사일을 조회
select max(hire_date), min(hire_date)
from emp;

-- EMP 테이블의 부서(dept_name) 의 개수를 조회
select count(distinct dept_name)
	  ,count(distinct ifnull(dept_name, 'a')) - null 포함해서 카운트 
from emp;

-- EMP 테이블에서 job 종류의 개수 조회
select count(distinct job)
from emp;


--  커미션 비율(comm_pct)이 있는 직원의 수를 조회
select count(comm_pct)
from emp;
-- 커미션 없는사람 세기 
select count(*)
from emp
where comm_pct is null;  # select에서 is null 때리면 값 제대로 안나옴

select count(comm_pct)
from emp;

--  평균 급여(salary)를 조회. 
select avg(salary) 
from emp;

-- compm_pct 평균 
select avg(comm_pct) from emp; -- null 빼고 계산 ..합계를 35명으로 나눈 것 
select avg(ifnull(comm_pct, 0)) '전체평균' from emp; -- null을 0으로 바꾸고, 포함해서 평균 계산 


--  최고 급여액과 최저 급여액 그기고 그 둘의 차액을 출력
select max(salary), min(salary), max(salary) - min(salary)
from emp;

-- 가장 긴 직원 이름(emp_name)이 몇글자 인지 조회.
select max(char_length(emp_name))
from emp;

use hr;

-- EMP 테이블의 몇개(dept_name)의 부서가 있는지 조회. 
select count(distinct dept_name)
from emp;

select count(dept_name)
from emp;

#아래는 실행 불가함. 왜냐면 사각형 표가 아니고 왼쪽칼럼 1줄, 오른쪽칼룸 100줄 이상이 되버려서 표가 안나옴
-- select avg(salary) , salary 
-- from emp;    

/* **************
group by 절
- 특정 컬럼(들)의 값별로 행들을 나누어 집계할 때 기준컬럼을 지정하는 구문.
	- 예) 업무별 급여평균. 부서-업무별 급여 합계. 성별 나이평균
- 구문: group by 컬럼명 [, 컬럼명]
	- 컬럼: 범주형 컬럼을 사용 - 부서별 급여 평균, 성별 급여 합계
	- select의 where 절 다음에 기술한다.
	- select 절에는 group by 에서 선언한 컬럼들만 집계함수와 같이 올 수 있다.
****************/

-- 업무(job)별 급여의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 직원수를 조회
select job, sum(salary),
			avg(salary),
            max(salary),
            min(salary),
            stddev(salary),
            variance(salary),
            count(*)
            
from emp
group by job;

-- 입사연도 별 직원들의 급여 평균.
select year(hire_date) , avg(salary)
from emp
group by year(hire_date) -- 함수 처리결과를 가지고 group으로 나눠라. 
order by 1 ; #첫번쨰 컬럼 기준으로 정렬하세용

select year(hire_date), avg(salary)
from emp
group by year(hire_date)
order by 1;
-- 부서명(dept_name) 이 'Sales'이거나 'Purchasing' 인 직원들의 업무별 (job) 직원수를 조회

select job, count(*), dept_name
from emp
where dept_name in ('sales', 'purchasing')
group by job, dept_name;


select job, count(*) 
from emp
where dept_name in('sales', 'purchasing')
group by job;

-- 부서(dept_name), 업무(job) 별 최대, 평균급여(salary)를 조회.
select dept_name, job, avg(salary)
from emp
group by dept_name, job;





select dept_name ,job, avg(salary) as '평균급여' 
from emp
group by dept_name, job ;



-- 급여(salary) 범위별 직원수를 출력. 급여 범위는 10000 미만,  10000이상 두 범주.
select case when salary < 10000 then '10000미만'
     else '10000이상' end, count(*)
from emp
group by case when salary < 10000 then '10000미만' else '10000이상'end;
 



select case when salary >= 10000 then '만 이상'
			  else '만 미만' end as 급여레벨, count(*) as 직원수 # count(*) 하면 전체직원수.. 일반적인 케이스는 이렇게 시작
from emp
group by case when salary >= 10000 then '만 이상' #아래에서 작성한 case when을 위로 그대로 가져가도 됨 
			  else '만 미만' end;
-- 내가 처음 적었던 코드 group by  salary <10000, salary>= 10000;


-- 부서별(dept_name) 직원수를 조회
select dept_name, count(*)
from emp
group by dept_name;



select dept_name, count(*)
from emp
group by dept_name;

-- 업무별(job) 직원수를 조회. 직원수가 많은 것부터 정렬.
select job, count(*) 직원수
from emp
group by job
order by 2 desc;

-- 부서명(dept_name), 업무(job)별 직원수, 최고급여(salary)를 조회. 부서이름으로 오름차순 정렬.
select dept_name, job, 
	   count(*) 직원수 ,
       max(salary) "최고급여" 
from emp
group by dept_name, job
order by 1;


# 잘 배우기 위해서는 내가 찾고싶은게 있어야함. 궁금한게 있어야 한다. 

-- EMP 테이블에서 입사연도별(hire_date) 총 급여(salary)의 합계을 조회. 
-- (급여 합계는 정수부에 자리구분자 , 를 넣고 $를 붙이시오. ex: $2,000,000)
select year(hire_date), concat('$', format(sum(salary),2))
from emp
group by year(hire_Date)
order by 2 desc;

select year(hire_Date), concat('$',format(sum(salary), 2)) 급여합계

from emp
group by year(hire_Date)
order by 2 desc;

-- 같은해 입사해서 같은 업무를 한 직원들의 평균 급여(salary)을 조회
select year(hire_date), format(avg(salary),2)
from emp
group by year(hire_date)
order by 1;



select year(hire_date) 입사연도, job, avg(salary)
from emp
group by year(hire_Date), job
order by 2;


-- 부서별(dept_name) 직원수 조회하는데 부서명(dept_name)이 null인 것은 제외하고 조회.
select dept_name, count(*)
from emp
group by dept_name;


select dept_name, count(*) "직원수"
from emp 
where dept_name is not null
group by dept_name;


-- 급여 범위별 직원수를 출력. 급여 범위는 5000 미만, 5000이상 10000 미만, 10000이상 20000미만, 20000이상. 
select case when salary< 5000 then '5000미만'
			  when salary between 5000 and 9999.99 then '10000미만'
              when salary between 10000 and 19999.99 then '20000미만'
              else '20000 이상' end as '급여범위', count(*)
from emp
group by case when salary < 5000 then '5000미만'
			  when salary between 5000 and 9999.99 then '10000미만'
              when salary between 10000 and 19999.99 then '20000미만'
              else '20000 이상' end as '급여범위' 
order by 2;
              


select case when salary < 5000 then "1등급"
			  when salary between 5000 and 9999.99 then '5000~10000' # 10000을 제외시키는 방법! 
              when salary between 10000 and 19999.99 then '10000~20000'
              else '20000 이상' end as "급여범위", 
              count(*)
from emp
group by case when salary < 5000 then "5000 미만"
			  when salary between 5000 and 9999.99 then '5000~10000' # 10000을 제외시키는 방법! 
              when salary between 10000 and 19999.99 then '10000~20000'
              else '20000 이상' end as "급여범위"
order by 2;
              
              


                      
/* **************************************************************
having 절
- group by 로 나뉜 그룹을 filtering 하기 위한 조건을 정의하는 구문.
- group by 다음 order by 전에 온다.
- 구문
    having 제약조건  
		- 연산자는 where절의 연산자를 사용한다. 
		- 피연산자는 집계함수(의 결과)
		
** where절은 행을 filtering한다.
   having절은 group by 로 묶인 그룹들을 filtering한다.		
************************************************************** */

-- 직원수가 10 이상인 부서의 부서명(dept_name)과 직원수를 조회
select dept_name, count(*)
from emp
group by dept_name
having count(*) >10;



select dept_name
from emp;

-- 직원수가 10명 이상인 부서의 부서명과 그 부서 직원들의 평균 급여를 조회.
select dept_name, avg(salary) -- ,count(*)
from emp
group by dept_name
having count(*) >= 10;

-- 20명 이상이 입사한 년도와 (그 해에) 입사한 직원수를 조회.
select year(hire_date), count(hire_Date)
from emp
group by year(hire_Date)
having count(*) >= 20;


select year(hire_Date) 입사연도, count(*) 직원수
from emp
group by year(hire_date)
having count(*) >= 20;

-- 평균 급여가(salary) $5000 이상인 부서의 이름(dept_name)과 평균 급여(salary), 직원수를 조회
select dept_name, avg(salary), count(*)

select dept_name, 
	   avg(salary) "평균급여",
       count(*) 직원수
from emp
group by dept_name
having avg(salary) >= 5000;

-- 평균급여가 $5,000 이상이고 총급여가 $50,000 이상인 부서의 부서명(dept_name), 평균급여와 총급여를 조회
select dept_name,
		avg(salary) 평균급여,
        sum(salary) 총급여
from emp
group by dept_name
having avg(salary) >= 5000 and sum(salary) >=50000;

--  커미션이 있는 직원들의 입사년도별 평균 급여를 조회. 단 평균 급여가 $9,000 이상인 년도분만 조회.
select avg(salary), year(hire_date)
from emp
group by year(hire_date) 
having avg(salary) >= 9000;


# process order
-- select 컬럼선택 			(5)
-- from 테이블 선택 			(1)
-- where 조회할 행 선택(조건) 	(2)
-- group by 그룹을 나눌 기준 컬럼 (3)
-- having 집계; 기준을 선택(조건) (4)
-- order by 정렬기준 			(6)



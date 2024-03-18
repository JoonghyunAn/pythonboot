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
 
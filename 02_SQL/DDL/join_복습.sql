-- TODO: 주문 번호가 1인 주문의 주문자 이름, 주소, 우편번호, 전화번호 조회
use hr_join;

select * 
from customers c join orders o on c.cust_id = o.cust_id
where o.order_id = 1;




use hr_join;
select *
from customers c join orders o on c.cust_id = o.cust_id
where o.order_id = 1 ;

-- TODO : 주문 번호가 2인 주문의 주문일, 주문상태, 총금액, 주문고객 이름, 주문고객 이메일 주소 조회



select o.order_date, o.order_status, o.order_total,
	   c.cust_name, c.cust_email
from customers c join orders o on c.cust_id = o.cust_id
where o.order_id = 2;


-- TODO : 고객 ID가 120인 고객의 이름, 성별, 가입일과 지금까지 주문한 주문정보중 주문_ID, 주문일, 총금액을 조회


select c.cust_name, 
	if(c.gender = 'm', '남성','여성') "성별", c.join_date,
	   o.order_id, o.order_date, o.order_total
from customers c join orders o on c.cust_id = o.cust_id # 만약 주문 안했떤 고객인데 나오게 하고싶으면 left join 시키면 됨  # left join 연습해보기 
where c.cust_id = 120;

-- TODO : 고객 ID가 110인 고객의 이름, 주소, 전화번호, 그가 지금까지 주문한 주문정보중 주문_ID, 주문일, 주문상태 조회
 select c.cust_name, c.address, c.phone_number,
	    o.order_id, o.order_date, o.order_status
from customers c left join orders o on c.cust_id = o.cust_id  # outer 레프트 조인 때리면 나온다 # 왜 cust_id와 ordeR_id? cust_id가 맞음! 
where c.cust_id = 110; # 110번인 사람 존재하지만 조인테이블에서 제외되는.. 

 
 
 

-- TODO : 고객 ID가 120인 고객의 정보와 지금까지 주문한 주문정보를 모두 조회.
select *
from customers c left join orders o on c.cust_id = o.cust_id
where c.cust_id = 120;


-- TODO : '2017/11/13'(주문날짜) 에 주문된 주문의 주문고객의 고객_ID, 이름, 주문상태, 총금액을 조회
select c.cust_id, c.cust_name, o.order_status, o.order_total
from customers c join orders o on c.cust_id = o.cust_id
where o.order_date = '2017-11-13'; # 알아서 날짜 형변환 후 비교해줌 


-- TODO : 주문상세 ID가 1인 주문제품의 제품이름, 판매가격, 제품가격을 조회.
select p.product_name, o.sell_price, p.price
from order_items o join products p on o.product_id = p.product_id
where o.order_item_id = 1; 


-- TODO : 주문 ID가 4인 주문의 주문 고객의 이름, 주소, 우편번호 => customers
-- , 주문일, 주문상태, 총금액 => orders
-- , 주문 제품이름, 제조사, 제품가격,  ==> products
-- 판매가격, 제품수량을 조회. ==> order_items
select c.cust_name, c.address, c.postal_code,
	   o.order_date, o.order_status, o.order_total,
       p.product_name, p.maker, p.price,
       oi.sell_price, oi.quantity
from orders o join customers c on o.cust_id = c.cust_id 
			  join order_items oi on o.order_id = oi.order_id
              join products p on oi.proudct_id = p.product_id
              
where o.order_id = 4 
;




-- TODO : 제품 ID가 200인 제품이 2017년에 몇개 주문되었는지 조회.
select sum(oi.quantity) 주문개수합계,
	   count(*) 주문횟수
from order_items oi join orders o on oi.order_id = o.order_id 
where oi.product_id = 200 
and   year(o.order_date) = 2017;


-- TODO : 제품분류별 총 주문량을 조회
select p.category,sum(oi.quantity) 팔린개수
from products p join order_items oi on p.product_id = oi.product_id
group by p.category
order by 2  desc;




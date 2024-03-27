
import pymysql

def insert_member(name,email,tall,birthday):
    sql = "insert into customer(name,email,tall,birthday,created_at) values(%s,%s,%s,%s,now())"
    with pymysql.connect(host ='127.0.0.1', port=3306, user='happy_noodle',password ='3535', db='mydb') as conn:
        with conn.cursor() as cursor:
            result = cursor.execute(sql, [name,email,tall,birthday])
            conn.commit()
    return result

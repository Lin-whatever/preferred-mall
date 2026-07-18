import pymysql
conn = pymysql.connect(host='localhost', port=3306, user='root', password='123456', database='eshop', charset='utf8mb4')
cur = conn.cursor()
cur.execute("UPDATE product_info SET pic = CONCAT('http://localhost:8080/eshop/product_images/', id, '.jpg')")
print(f"Updated {cur.rowcount} rows")
conn.commit()
cur.close()
conn.close()
print("DATABASE UPDATED!")

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS departments;

-- 부서
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- 직원
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    hire_date DATE,
    salary INT,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

-- 상품
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price INT
);

-- 판매내역
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    product_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);


INSERT INTO departments VALUES
(10,'영업1팀'),
(20,'영업2팀'),
(30,'온라인영업'),
(40,'해외영업');


INSERT INTO employees VALUES
(101,'김민수',10,'2020-03-01',4200),
(102,'이수진',10,'2021-01-10',3900),
(103,'박준호',20,'2019-05-11',5100),
(104,'최영희',20,'2022-07-18',3700),
(105,'정우성',30,'2018-11-22',6100),
(106,'김하늘',30,'2023-02-01',3300),
(107,'강지훈',40,'2017-04-15',6800),
(108,'한소희',40,'2021-09-10',4300);


INSERT INTO products VALUES
(1,'노트북','전자',1500),
(2,'모니터','전자',400),
(3,'키보드','전자',100),
(4,'마우스','전자',80),
(5,'책상','가구',500),
(6,'의자','가구',300),
(7,'프린터','사무기기',700),
(8,'태블릿','전자',900);


INSERT INTO sales VALUES
(1,101,1,'2024-01-03',2),
(2,101,2,'2024-01-15',5),
(3,101,5,'2024-02-01',3),
(4,102,1,'2024-02-03',1),
(5,102,3,'2024-02-12',8),
(6,102,4,'2024-03-01',15),

(7,103,1,'2024-01-20',4),
(8,103,6,'2024-01-28',6),
(9,103,7,'2024-03-10',2),

(10,104,5,'2024-01-18',5),
(11,104,6,'2024-02-18',8),
(12,104,2,'2024-03-05',7),

(13,105,8,'2024-01-05',6),
(14,105,1,'2024-02-11',3),
(15,105,7,'2024-03-20',4),

(16,106,2,'2024-01-22',10),
(17,106,3,'2024-02-28',12),
(18,106,4,'2024-03-25',18),

(19,107,1,'2024-01-30',7),
(20,107,8,'2024-02-20',5),
(21,107,7,'2024-03-12',3),

(22,108,5,'2024-01-17',2),
(23,108,2,'2024-02-09',9),
(24,108,3,'2024-03-27',11);

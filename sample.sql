DROP TABLE regions;
DROP TABLE customers;
DROP TABLE employees;
DROP TABLE categories;
DROP TABLE products;
DROP TABLE orders;
DROP TABLE order_details;

CREATE TABLE regions
(
    region_id      INT PRIMARY KEY,
    region_name    VARCHAR(30)
);

CREATE TABLE customers
(
    customer_id    INT PRIMARY KEY,
    customer_name  VARCHAR(50),
    grade          VARCHAR(10),
    region_id      INT,
    FOREIGN KEY (region_id)
        REFERENCES regions(region_id)
);

CREATE TABLE employees
(
    emp_id         INT PRIMARY KEY,
    emp_name       VARCHAR(50),
    dept_name      VARCHAR(30),
    hire_date      DATE,
    salary         INT
);

CREATE TABLE categories
(
    category_id      INT PRIMARY KEY,
    category_name    VARCHAR(30)
);

CREATE TABLE products
(
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(50),
    category_id     INT,
    price           INT,

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

CREATE TABLE orders
(
    order_id        INT PRIMARY KEY,
    customer_id     INT,
    emp_id          INT,
    order_date      DATE,
    status          VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
);

CREATE TABLE order_details
(
    detail_id       INT PRIMARY KEY,
    order_id        INT,
    product_id      INT,
    quantity        INT,
    discount        DECIMAL(4,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

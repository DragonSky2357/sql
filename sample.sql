DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS regions;

CREATE TABLE regions
(
    region_id      INT             PRIMARY KEY
  , region_name    VARCHAR(30)     NOT NULL
);

CREATE TABLE categories
(
    category_id      INT             PRIMARY KEY
  , category_name    VARCHAR(30)     NOT NULL
);

CREATE TABLE employees
(
    emp_id         INT             PRIMARY KEY
  , emp_name       VARCHAR(30)     NOT NULL
  , dept_name      VARCHAR(30)     NOT NULL
  , hire_date      DATE            NOT NULL
  , salary         INT             NOT NULL
);

CREATE TABLE customers
(
    customer_id      INT             PRIMARY KEY
  , customer_name    VARCHAR(50)     NOT NULL
  , grade            VARCHAR(10)     NOT NULL
  , region_id        INT             NOT NULL

  , CONSTRAINT fk_customer_region
        FOREIGN KEY (region_id)
        REFERENCES regions (region_id)
);

CREATE TABLE products
(
    product_id        INT             PRIMARY KEY
  , product_name      VARCHAR(50)     NOT NULL
  , category_id       INT             NOT NULL
  , price             INT             NOT NULL

  , CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
);

CREATE TABLE orders
(
    order_id         INT             PRIMARY KEY
  , customer_id      INT             NOT NULL
  , emp_id           INT             NOT NULL
  , order_date       DATE            NOT NULL
  , status           VARCHAR(20)     NOT NULL

  , CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)

  , CONSTRAINT fk_order_employee
        FOREIGN KEY (emp_id)
        REFERENCES employees (emp_id)
);

CREATE TABLE order_details
(
    detail_id        INT             PRIMARY KEY
  , order_id         INT             NOT NULL
  , product_id       INT             NOT NULL
  , quantity         INT             NOT NULL
  , discount         DECIMAL(5,2)    NOT NULL

  , CONSTRAINT fk_detail_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)

  , CONSTRAINT fk_detail_product
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

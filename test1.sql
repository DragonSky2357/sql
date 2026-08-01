WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m')              AS sales_month
      , c.category_id
      , c.category_name
      , SUM(od.quantity * p.price * (1 - od.discount)) AS total_sales

    FROM orders o

    INNER JOIN order_details od
        ON o.order_id = od.order_id

    INNER JOIN products p
        ON od.product_id = p.product_id

    INNER JOIN categories c
        ON p.category_id = c.category_id

    WHERE o.status = 'COMPLETE'

    GROUP BY
        DATE_FORMAT(o.order_date,'%Y-%m')
      , c.category_id
      , c.category_name
)


SELECT
    sales_month
  , category_name
  , total_sales
  , RANK() OVER
    (
        PARTITION BY sales_month
        ORDER BY total_sales DESC
    )                                               AS month_rank
  , LAG(total_sales) OVER
    (
        PARTITION BY category_name
        ORDER BY sales_month
    )                                               AS previous_sales
  , total_sales -
    LAG(total_sales) OVER
    (
        PARTITION BY category_name
        ORDER BY sales_month
    )                                               AS sales_gap

FROM monthly_sales

ORDER BY
    sales_month
  , month_rank;

-------------------------------------------------------
SELECT
    r.region_name
  , c.customer_grade
  , SUM(od.quantity * p.price * (1 - od.discount)) AS total_sales

FROM customers c

INNER JOIN regions r
    ON c.region_id = r.region_id

INNER JOIN orders o
    ON c.customer_id = o.customer_id

INNER JOIN order_details od
    ON o.order_id = od.order_id

INNER JOIN products p
    ON od.product_id = p.product_id

WHERE o.status = 'COMPLETE'

GROUP BY
    r.region_name
  , c.customer_grade WITH ROLLUP;
-------------------------------------------------------

WITH employee_sales AS
(
    SELECT
        e.emp_id
      , e.emp_name
      , COUNT(DISTINCT o.order_id)                  AS order_count
      , SUM(od.quantity * p.price * (1 - od.discount)) AS total_sales

    FROM employees e

    LEFT JOIN orders o
        ON e.emp_id = o.emp_id

    LEFT JOIN order_details od
        ON o.order_id = od.order_id

    LEFT JOIN products p
        ON od.product_id = p.product_id

    WHERE o.status = 'COMPLETE'
       OR o.status IS NULL

    GROUP BY
        e.emp_id
      , e.emp_name
)


SELECT
    emp_id
  , emp_name
  , order_count
  , total_sales
  , DENSE_RANK() OVER
    (
        ORDER BY total_sales DESC
    )                                               AS sales_rank
  , total_sales -
    AVG(total_sales) OVER ()                        AS avg_gap

FROM employee_sales

ORDER BY
    sales_rank;
-------------------------------------------------------------------
WITH customer_order AS
(
    SELECT
        c.customer_id
      , c.customer_name
      , c.customer_grade
      , o.order_date
      , SUM(od.quantity * p.price * (1 - od.discount)) AS order_amount

    FROM customers c

    INNER JOIN orders o
        ON c.customer_id = o.customer_id

    INNER JOIN order_details od
        ON o.order_id = od.order_id

    INNER JOIN products p
        ON od.product_id = p.product_id

    WHERE c.customer_grade = 'VIP'
      AND o.status = 'COMPLETE'

    GROUP BY
        c.customer_id
      , c.customer_name
      , c.customer_grade
      , o.order_date
)


SELECT
    customer_id
  , customer_name
  , order_date
  , order_amount
  , SUM(order_amount) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_date
    )                                               AS cumulative_sales
  , LAG(order_amount) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_date
    )                                               AS previous_order

FROM customer_order

ORDER BY
    customer_id
  , order_date;

SELECT  cat.category_name
      , COUNT(DISTINCT ord.order_id) AS order_count
      , SUM(det.quantity) AS total_qty
      , SUM(det.quantity * det.unit_price) AS sales
      , ROUND(AVG(det.quantity * det.unit_price), 2) AS avg_price
FROM    orders AS ord
INNER JOIN order_details AS det
        ON ord.order_id = det.order_id
INNER JOIN products AS prd
        ON det.product_id = prd.product_id
INNER JOIN categories AS cat
        ON prd.category_id = cat.category_id
GROUP BY
        cat.category_name
HAVING
        SUM(det.quantity * det.unit_price) >= 20000
ORDER BY
        sales DESC;

-------------------------------------------------------
SELECT  reg.region_name
      , emp.emp_name
      , cat.category_name
      , SUM(det.quantity * det.unit_price) AS sales
FROM    orders AS ord
INNER JOIN employees AS emp
        ON ord.emp_id = emp.emp_id
INNER JOIN customers AS cus
        ON ord.customer_id = cus.customer_id
INNER JOIN regions AS reg
        ON cus.region_id = reg.region_id
INNER JOIN order_details AS det
        ON ord.order_id = det.order_id
INNER JOIN products AS prd
        ON det.product_id = prd.product_id
INNER JOIN categories AS cat
        ON prd.category_id = cat.category_id
GROUP BY
        reg.region_name
      , emp.emp_name
      , cat.category_name
WITH ROLLUP;
-------------------------------------------------------

SELECT  emp.dept_id
      , emp.emp_name
      , SUM(det.quantity * det.unit_price) AS sales
      , AVG(SUM(det.quantity * det.unit_price))
            OVER (
                PARTITION BY emp.dept_id
            ) AS dept_avg
      , RANK()
            OVER (
                PARTITION BY emp.dept_id
                ORDER BY SUM(det.quantity * det.unit_price) DESC
            ) AS dept_rank
      , DENSE_RANK()
            OVER (
                ORDER BY SUM(det.quantity * det.unit_price) DESC
            ) AS total_rank
      , ROUND(
            SUM(det.quantity * det.unit_price)
            / SUM(SUM(det.quantity * det.unit_price))
                OVER ()
            * 100
          , 2
        ) AS sales_ratio
FROM    orders AS ord
INNER JOIN employees AS emp
        ON ord.emp_id = emp.emp_id
INNER JOIN order_details AS det
        ON ord.order_id = det.order_id
GROUP BY
        emp.dept_id
      , emp.emp_name;
-------------------------------------------------------------------
WITH customer_sales AS
(
    SELECT  reg.region_name
          , cus.customer_id
          , cus.customer_name
          , SUM(det.quantity * det.unit_price) AS sales
    FROM    customers AS cus
    INNER JOIN regions AS reg
            ON cus.region_id = reg.region_id
    INNER JOIN orders AS ord
            ON cus.customer_id = ord.customer_id
    INNER JOIN order_details AS det
            ON ord.order_id = det.order_id
    GROUP BY
            reg.region_name
          , cus.customer_id
          , cus.customer_name
),
ranked AS
(
    SELECT  region_name
          , customer_name
          , sales
          , ROW_NUMBER()
                OVER (
                    PARTITION BY region_name
                    ORDER BY sales DESC
                ) AS rn
    FROM    customer_sales
)
SELECT  region_name
      , customer_name
      , sales
FROM    ranked
WHERE   rn <= 3
ORDER BY
        region_name
      , sales DESC;

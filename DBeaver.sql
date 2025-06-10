-- 1. Überblick: Zeilen und Kunden
SELECT
  (SELECT COUNT(*) FROM sales_multi)        AS total_transactions,
  (SELECT COUNT(DISTINCT date) FROM sales_multi) AS distinct_days,
  (SELECT COUNT(*) FROM customer)           AS distinct_customers;
-- 2. Gesamtverkäufe (Einheiten) gesamt und pro Hauptprodukt
SELECT
  SUM(units)                                               AS total_units,
  SUM(CASE WHEN product = 'product_a' THEN units END)      AS total_a,
  SUM(CASE WHEN product = 'product_b' THEN units END)      AS total_b,
  SUM(CASE WHEN product = 'product_c' THEN units END)      AS total_c
FROM sales_multi;

-- 3. Verkaufsvolumen nach Region
SELECT
  c.region,
  SUM(s.units) AS units_region
FROM sales_multi   AS s
JOIN customer     AS c USING(customer_id)
GROUP BY c.region
ORDER BY units_region DESC;

-- 4. Ø Einheiten pro Kunde je Region
SELECT
  c.region,
  ROUND(AVG(s.units), 2) AS avg_units_per_transaction
FROM sales_multi   AS s
JOIN customer     AS c USING(customer_id)
GROUP BY c.region;

-- 5. Verkaufsvolumen nach Branche (Top 10)
SELECT
  c.branch,
  SUM(s.units) AS units_branch
FROM sales_multi   AS s
JOIN customer     AS c USING(customer_id)
GROUP BY c.branch
ORDER BY units_branch DESC
LIMIT 10;

-- 6. Monatliche Gesamtverkäufe (aus sales_multi)
SELECT
  strftime('%Y-%m', date) AS month,
  SUM(units)              AS units_month
FROM sales_multi
GROUP BY month
ORDER BY month;

-- 7. Wöchentliche Gesamtverkäufe (aus sales_multi)
SELECT
  strftime('%Y-%W', date) AS year_week,
  SUM(units)              AS units_week
FROM sales_multi
GROUP BY year_week
ORDER BY year_week;

-- 8. Produktverteilung insgesamt (aus sales_multi)
SELECT
  product,
  SUM(units)                            AS units_product,
  ROUND(100.0 * SUM(units) /
    (SELECT SUM(units) FROM sales_multi), 1) || '%' AS pct_of_total
FROM sales_multi
GROUP BY product;

-- 9. Top-20 Verkaufstage (Ausreißer-Heuristik)
SELECT
  date,
  SUM(units) AS units_day
FROM sales_multi
GROUP BY date
ORDER BY units_day DESC
LIMIT 20;

-- 10. Mitarbeiterzahl vs. Gesamtverkauf je Kunde (Top 20)
SELECT
  c.customer_id,
  c.employees,
  SUM(s.units) AS total_units
FROM sales_multi   AS s
JOIN customer     AS c USING(customer_id)
GROUP BY c.customer_id
ORDER BY total_units DESC
LIMIT 20;
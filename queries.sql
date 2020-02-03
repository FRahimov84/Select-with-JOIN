-- TODO:
--  1. для каждой продажи вывести: id, сумму, имя менеджера, название товара
--  2. сосчитать, сколько (количество) продаж сделал каждый менеджер
--  3. сосчитать, на сколько (общая сумма) продал каждый менеджер
--  4. сосчитать, на сколько (общая сумма) продано каждого товара
--  5. найти топ-3 самых успешных менеджеров по общей сумме продаж
--  6. найти топ-3 самых продаваемых товаров (по количеству)
--  7. найти топ-3 самых продаваемых товаров (по сумме)
--  8. найти % на сколько каждый менеджер выполнил план по продажам
--  9. найти % на сколько выполнен план продаж по подразделениям
-- 1
select t.id, t.sum, t.manager, p.name product
from (select s.id id, (s.price * s.qty) sum, m.name manager, s.product_id
      from managers m
               JOIN sales s on m.id = s.manager_id) t
         join products p on t.product_id = p.id;

-- 2
select m.name manager, count(s.manager_id) salesCount
from managers m
         LEFT JOIN sales s on m.id = s.manager_id
group by s.manager_id;

-- 3
select m.name manager, ifnull(sum(s.price * s.qty), 0) salesSum, m.plan
from managers m
         LEFT JOIN sales s on m.id = s.manager_id
group by s.manager_id;

-- 4
select p.name product, ifnull(sum(s.price * s.qty), 0) salesSum
from products p
         LEFT JOIN sales s on p.id = s.product_id
group by s.product_id;

-- 5
select m.name manager, ifnull(sum(s.price * s.qty), 0) salesSum
from managers m
         LEFT JOIN sales s on m.id = s.manager_id
group by s.manager_id
order by salesSum desc
limit 3;

-- 6
select p.name product, ifnull(sum(s.qty), 0) totalQty
from products p
         LEFT JOIN sales s on p.id = s.product_id
group by s.product_id
order by totalQty desc
limit 3;

-- 7
select p.name product, ifnull(sum(s.price * s.qty), 0) totalSum
from products p
         LEFT JOIN sales s on p.id = s.product_id
group by s.product_id
order by totalSum desc
limit 3;

-- 8
select m.name manager, ifnull((sum(s.price * s.qty) * 100.0 / m.plan), 0) percent
from managers m
         LEFT JOIN sales s on m.id = s.manager_id
group by s.manager_id;

-- 9
SELECT ifnull(m.unit, 'boss') Unit,
       ifnull((
                  SELECT ss.total
                  FROM (
                           SELECT sum(s.qty * s.price)                                         total,
                                  (SELECT mm.unit FROM managers mm WHERE mm.id = s.manager_id) unit
                           FROM sales s
                           WHERE unit = m.unit) ss
              )
                  * 100.0 /
              (
                  SELECT sum(mm.plan)
                  FROM managers mm
                  WHERE mm.unit = m.unit
              ), 0)           percent
FROM managers m
group by Unit;
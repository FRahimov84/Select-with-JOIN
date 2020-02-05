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
      from sales s
               JOIN managers m on m.id = s.manager_id) t
         join products p on t.product_id = p.id;

-- 2
select m.name manager, ifnull(s.salesCount, 0) total
from managers m
         LEFT JOIN (select manager_id, count(manager_id) salesCount from sales group by manager_id) s
                   on m.id = s.manager_id;

-- 3
select m.name manager, ifnull(s.sum, 0) total
from managers m
         LEFT JOIN (select manager_id, sum(qty * price) sum from sales group by manager_id) s
                   on m.id = s.manager_id;

-- 4
select p.name product, ifnull(s.sum, 0) total
from products p
         LEFT JOIN (select product_id, sum(qty * price) sum from sales group by product_id) s
                   on p.id = s.product_id;

-- 5
select m.name manager, ifnull(s.sum, 0) salesSum
from managers m
         LEFT JOIN (select manager_id, sum(qty * price) sum from sales group by manager_id) s on m.id = s.manager_id
order by salesSum desc
limit 3;

-- 6
select p.name product, ifnull(s.sum, 0) totalQty
from products p
         LEFT JOIN (select product_id, sum(qty) sum from sales group by product_id) s on p.id = s.product_id
order by totalQty desc
limit 3;

-- 7
select p.name product, ifnull(s.sum, 0) totalSum
from products p
         LEFT JOIN (select product_id, sum(price * qty) sum from sales group by product_id) s on p.id = s.product_id
order by totalSum desc
limit 3;

-- 8
select m.name manager, ifnull((s.sum * 100.0 / m.plan), 0) percent
from managers m
         LEFT JOIN (select manager_id, sum(qty * price) sum from sales group by manager_id) s on m.id = s.manager_id;

-- 9
select ifnull(m.unit, 'boss') unit, ifnull(sum(s.sum) * 100.0 / sum(m.plan), 0) percent
from managers m
         LEFT JOIN (SELECT manager_id, SUM(qty * price) sum FROM sales Group By manager_id) s
                   on s.manager_id = m.id
GROUP BY m.unit;
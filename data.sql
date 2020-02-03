INSERT INTO managers
VALUES (1, 'Vasya', 'vasya', 100000, 0, NULL), -- Ctrl + D
       (2, 'Petya', 'petya', 90000, 90000, 1),
       (3, 'Vanya', 'vanya', 80000, 80000, 2),
       (4, 'Masha', 'masha', 80000, 80000, 1),
       (5, 'Dasha', 'dasha', 60000, 60000, 4),
       (6, 'Sasha', 'sasha', 40000, 40000, 5);

-- UPDATE - обновлять данные
-- UPDATE managers SET plan = 100000; -- так не делать!

-- UPDATE повысить всем план на 10000
UPDATE managers
SET plan = plan + 10000;
-- можно в update ссылаться на предыдущее значение столбца

-- сделать всем план: зарплата + 50%
-- Декларативность:
UPDATE managers
SET plan = salary * 1.5;

-- Vasya надо вернуть в 0
UPDATE managers
SET plan = 0
WHERE id = 1;
-- сравнение на равенство через =

-- Саппорт: номер телефона
-- Саппорт: Имя Фамилия, **** **** **** 3333

-- Всем, у кого зп меньше 80 000
-- Надо зарплату поднять на 5 000, а план на 15 000
-- SET plan = ..., salary = ...

UPDATE managers
SET salary = salary + 5000,
    plan   = salary * 1.5 + plan + 15000 -- берётся на основании "старого" значения
WHERE salary < 80000;

DELETE
FROM managers; -- табличка будет "чистая" (так делать не надо), сама табличка останется

INSERT INTO managers (id, name, login, salary, plan, boss_id)
VALUES (1, 'Vasya', 'vasya', 100000, 0, NULL), -- Ctrl + D
       (2, 'Petya', 'petya', 90000, 90000, 1),
       (3, 'Vanya', 'vanya', 80000, 80000, 2),
       (4, 'Masha', 'masha', 80000, 80000, 1),
       (5, 'Dasha', 'dasha', 60000, 60000, 4),
       (6, 'Sasha', 'sasha', 40000, 40000, 5);

-- что назначить всем unit = 'worker' кроме тех, у кого boss_id NULL
-- NULL - не равен ничему, даже самому себе
-- IS NULL - проверяем NULL ли
-- IS NOT NULL - не NULL ли
UPDATE managers
SET unit = 'worker'
WHERE boss_id IS NOT NULL;

SELECT 1; -- SELECT всегда возвращает табличку

SELECT 1 + 1;

SELECT id, name
FROM managers;

-- SELECT * FROM managers; -- * - всё (не использовать)
-- и пусть весь мир подождёт

SELECT id, name
FROM managers
WHERE salary > 50000;

SELECT id, name
FROM managers
WHERE NOT salary > 50000;

UPDATE managers
SET plan = plan * 1.2
WHERE id <> 1;
-- !=, <> - это одно и то же

SELECT salary - plan
FROM managers;

SELECT ABS(salary - plan)
FROM managers;

-- AS - псевдоним (diff - название вычисляемого столбца)
SELECT ABS(salary - plan) AS diff
FROM managers;
-- AS можно не писать
SELECT id manager_id, name manager_name, ABS(salary - plan) diff
FROM managers;

-- AND, OR, NOT
UPDATE managers
SET unit = 'boys'
WHERE id < 4
  AND boss_id IS NOT NULL;

UPDATE managers
SET unit = 'girls'
WHERE unit != 'boys'
  AND unit IS NOT NULL;

SELECT id, name
FROM managers
LIMIT 3;
-- постраничная выдача контента

-- TODO: выдать любых двух девочек
SELECT id, name
FROM managers
WHERE unit = 'girls'
LIMIT 2;

-- постраничная выдача данных limit - сколько оставить, offset - сколько отступить с начала
SELECT id, name
FROM managers
LIMIT 3 OFFSET 0;
-- offset + limit

-- 10 записей
-- +10 записей, offset 10
-- +10 записей, offset 20

SELECT id, name
FROM managers
ORDER BY name ASC; -- Ascending
SELECT id, name
FROM managers
ORDER BY name; -- Asc можно не писать

SELECT id, name, salary
FROM managers
ORDER BY salary; -- Asc можно не писать

SELECT id, name, salary
FROM managers
ORDER BY salary DESC; -- Asc можно не писать

SELECT id, name, salary
FROM managers
ORDER BY salary DESC, name; -- по name будет только для тех у кого одинаковая зп


INSERT INTO products(name, price, qty)
VALUES ('Big Mac', 200, 10),       -- 1
       ('Chicken Mac', 150, 15),   -- 2
       ('Cheese Burger', 100, 20), -- 3
       ('Tea', 50, 10),            -- 4
       ('Coffee', 80, 10),         -- 5
       ('Cola', 100, 20); -- 6

INSERT INTO sales(manager_id, product_id, price, qty)
VALUES (1, 1, 150, 10), -- Vasya big mac со скидкой
       (2, 2, 150, 5),  -- Petya Chicken Mac без скидки
       (3, 3, 100, 5),  -- Vanya Cheese Burger без скидки
       (4, 1, 250, 5),  -- Masha Big Mac с наценкой
       (4, 4, 100, 5),  -- Masha Tea тоже с наценкой
       (5, 5, 100, 5),  -- Dasha Coffee c наценкой
       (5, 6, 120, 10);
-- Dasha Cola c наценкой

-- TODO: Топ 3 самых высокооплачиваемых менеджера
-- TODO: Топ 3 самых дешёвых продукта

SELECT id, name, salary
FROM managers
ORDER BY salary DESC
LIMIT 3;

SELECT id, name, price
FROM products
ORDER BY price
LIMIT 3;

-- Агрегирующие + агрегирующие функции
-- count, sum, avg, min, max
SELECT count(*)
FROM managers; -- считаем кол-во строк в таблице
SELECT count(id)
FROM managers;

SELECT count(*)
FROM managers
WHERE unit = 'boys';

SELECT sum(salary)
FROM managers;

SELECT avg(salary)
FROM managers;

-- TODO: сосчитать суммарную стоимость товаров на складе
SELECT sum(qty * price)
FROM products;
-- TODO: сосчитать общую сумму всех продаж
SELECT sum(qty * price)
FROM sales;
-- TODO: сосчитать среднюю стоимость одной продажи
-- TODO: сосчитать стоимость максимальной продажи
-- TODO: сосчитать стоимость минимальной продажи
SELECT avg(qty * price), max(qty * price), min(qty * price)
FROM sales;

SELECT id, sum(salary)
FROM managers;

SELECT id, min(salary)
FROM managers;

-- когда работаете с БД обязательно нужно читать про особенности БД
UPDATE managers
SET salary = 'много'
WHERE id = 1;

SELECT sum(salary)
FROM managers;

-- MySQL 5
-- поставил ограничение: 255
-- 300 -> 255
-- Postgres - ошибка

-- группировка, join'ы и транзакции
-- TODO: вам нужны чеки, а в чеке много разных товаров

-- Чек: Яблоки 10 шт
-- Чек: Бургеры 1 шт

-- Чек (один менеджер):
---- Яблоки 10 шт
---- Бургеры 1 шт

-- 1. Только агрегирующие функции
-- 2. Столбцы по которым идёт группировка
SELECT unit, sum(salary)
FROM managers
GROUP BY unit;


SELECT unit, sum(salary)
FROM managers
GROUP BY unit
HAVING unit IS NOT NULL; -- HAVING inefficient (не использует значения агр.функций)

SELECT unit, sum(salary)
FROM managers
WHERE unit IS NOT NULL
GROUP BY unit;

SELECT unit, sum(salary)
FROM managers
GROUP BY unit
HAVING sum(salary) > 170000;

-- Многотабличные запросы
-- 1. Вложенный несвязанный подзапрос
-- 2. Вложенный связанный подзапрос
-- 3. Объединение таблици

-- TODO: сравнивать свою зп со средней зп в компании
-- 1. avg
SELECT avg(salary)
FROM managers;
-- ровно одно значение
-- 2. по каждому менеджеру
SELECT id, name, salary
FROM managers;
-- всё очень быстро!

-- 1. Вложенный SELECT должен возвращать ровно 1 строку и один столбец
-- 2. Несвязанный подзапрос
SELECT id, name, salary, (SELECT avg(salary) FROM managers)
FROM managers;

SELECT id, name, salary, salary - (SELECT avg(salary) FROM managers)
FROM managers;

SELECT id, name, salary, salary - (SELECT min(salary) FROM managers)
FROM managers;

-- TODO: то же самое: но в разрезе подразделений
-- Vasya работает в boys, salary - avg(salary) boys

SELECT id,
       name,
       salary,
       salary - (SELECT avg(salary) FROM managers WHERE unit = 'boys') difference
FROM managers
WHERE unit = 'boys';

SELECT id,
       name,
       salary,
       salary - (SELECT avg(salary) FROM managers WHERE unit = 'girls') difference
FROM managers
WHERE unit = 'girls';

-- Связанный подзапрос

-- Ctrl + Alt + L
SELECT m.id,
       m.name,
       m.salary,
       m.salary - (
           SELECT avg(mm.salary)
           FROM managers mm
           WHERE mm.unit = m.unit
       ) difference
FROM managers m;

-- TODO:
-- Продажи:
-- для каждой продажи: manager_id - хочу, чтобы подставлялось имя менеджера
SELECT s.id,
       s.price * s.qty,
       (
           SELECT m.name
           FROM managers m
           WHERE m.id = s.manager_id
       )
FROM sales s;

SELECT m.name
FROM managers m
WHERE m.id = :id;

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
--  кто не сделает до 10:30 - получит +10 запросов домой

-- TODO: командная работа (до 11:00):
--  Ускоряет вас (если вы грамотно разделяете работу) и тормозит (если не умеете разделять)
--  плюсы: на одну парту должны быть сделаны все задачи
--  минусы: 1 из 3 рандомно в конце пары сдаёт все задачи (зачёт ставится на группу)

-- JOIN
--  old style (использовать не надо)
SELECT s.id, (s.qty * s.price) total, m.name, p.name
FROM sales s,
     managers m,
     products p
WHERE s.manager_id = m.id
  AND s.product_id = p.id;

-- декартово произведение

-- 1. Несвязанные подзапросы
-- 2. JOIN*
-- 3. Связанные подзапросы*

SELECT s.id, (s.qty * s.price) total, p.name, m.name
FROM sales s
         JOIN products p ON s.product_id = p.id
         JOIN managers m ON s.manager_id = m.id
;
-- INNER JOIN

-- неправильно
SELECT sum(s.qty * s.price), m.name
FROM sales s
         JOIN managers m ON s.manager_id = m.id
GROUP BY s.manager_id
;

SELECT sum(s.qty * s.price) total, m.name
FROM sales s
         JOIN managers m ON s.manager_id = m.id
GROUP BY s.manager_id
ORDER BY total -- 1 столбец (а в SQL всё считается с 1)
LIMIT 1
;

SELECT s.manager_id, sum(s.qty * s.price) total
FROM sales s
GROUP BY s.manager_id;

SELECT m.name, st.total
FROM managers m
         JOIN (
    SELECT s.manager_id,
           sum(s.qty * s.price) total -- "создастся в памяти"
    FROM sales s
    GROUP BY s.manager_id
) st -- stats
              ON m.id = st.manager_id
;

-- OUTER: LEFT, RIGHT, FULL
SELECT m.name, ifnull(st.total, 0)
FROM managers m
         LEFT JOIN (
    SELECT s.manager_id,
           sum(s.qty * s.price) total -- "создастся в памяти"
    FROM sales s
    GROUP BY s.manager_id
) st -- stats
                   ON m.id = st.manager_id
;

SELECT m.unit, )
FROM managers m
GROUP BY m.unit;



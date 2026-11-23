-- -------------------
-- Пункт 1. Выбрать номера лабораторий, в которых проводятся 
-- занятия по информатике и информационным технологиям в бюджетных группах.
-- (Примечание: так как в базе нет признака бюджетности, выбираем все группы).
-- -------------------
SELECT DISTINCT s."lab_number"
FROM "Schedule" s
JOIN "disciplines" d ON d.discipline_id = s."discipline_id"
WHERE d.name IN ('Информатика', 'Информационные технологии');

-- -------------------
-- Пункт 2. Выбрать все дисциплины, оканчивающиеся на сочетания 
-- «логия» и «техника» и их описания.
-- -------------------
SELECT name, description
FROM "disciplines"
WHERE name LIKE '%логия' 
   OR name LIKE '%техника';

-- -------------------
-- Пункт 3. Создать таблицу, содержащую данные 1 запроса 
-- с указанием дней недели и пар, на которых в лаборатории проводятся занятия.
-- -------------------
CREATE TABLE lab_infotech_schedule AS
SELECT DISTINCT 
       s."lab_number", 
       s."day_of_week", 
       s."lesson_number",
       d.name AS discipline_name,
       s."group_number"
FROM "Schedule" s
JOIN "disciplines" d ON d.discipline_id = s."discipline_id"
WHERE d.name IN ('Информатика', 'Информационные технологии');

-- -------------------
-- Пункт 4. Добавить в созданную таблицу расписание для дисциплин 3 курса.
-- (Отбираем группы, номер которых начинается на цифру 3)
-- -------------------
INSERT INTO lab_infotech_schedule ("lab_number", "day_of_week", "lesson_number", discipline_name, "group_number")
SELECT 
       s."lab_number", 
       s."day_of_week", 
       s."lesson_number", 
       d.name, 
       s."group_number"
FROM "Schedule" s
JOIN "disciplines" d ON d.discipline_id = s."discipline_id"
WHERE s."group_number" LIKE '3%';

-- -------------------
-- Пункт 5. Изменить расписание таким образом, 
-- чтобы все 2 пары проводились на 5 паре.
-- -------------------
UPDATE lab_infotech_schedule
SET "lesson_number" = 5
WHERE "lesson_number" = 2;

-- -------------------
-- Пункт 6. Из созданной таблицы удалить все записи 
-- для дисциплин «математика», «информатика» и «физика».
-- -------------------
DELETE FROM lab_infotech_schedule
WHERE discipline_name IN ('Математика', 'Информатика', 'Физика');

-- -------------------
-- Пункт 7. Посчитать, сколько раз в неделю проводятся 
-- занятия по каждой дисциплине.
-- -------------------
SELECT discipline_name, COUNT(*) AS lessons_per_week
FROM lab_infotech_schedule
GROUP BY discipline_name
ORDER BY discipline_name;
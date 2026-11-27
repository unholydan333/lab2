
-- 1 Выбрать номера лабораторий
SELECT DISTINCT s.lab_number
FROM Schedule AS s
JOIN Disciplines AS d
    ON d.discipline_id = s.discipline_id
WHERE d.name IN ('Информатика', 'Информационные технологии')
  AND s.group_number IN ('ИТ-21', 'ИТ-22')
ORDER BY s.lab_number;


-- 2 Выбрать дисциплины, оканчивающиеся на «логия» и «техника»
SELECT name, description
FROM Disciplines
WHERE name LIKE '%логия'
   OR name LIKE '%техника'
ORDER BY name;


-- 3 Создать таблицу с данными первого запроса
CREATE TABLE lab_infotech_schedule AS
SELECT DISTINCT
    s.lab_number,
    s.day_of_week,
    s.lesson_number,
    d.name AS discipline_name,
    s.group_number
FROM Schedule AS s
JOIN Disciplines AS d
    ON d.discipline_id = s.discipline_id
WHERE d.name IN ('Информатика', 'Информационные технологии')
  AND s.group_number IN ('ИТ-21', 'ИТ-22');


-- 4 Добавить расписание дисциплин третьего курса
INSERT INTO lab_infotech_schedule
    (lab_number, day_of_week, lesson_number, discipline_name, group_number)
SELECT DISTINCT
    s.lab_number,
    s.day_of_week,
    s.lesson_number,
    d.name,
    s.group_number
FROM Schedule AS s
JOIN Disciplines AS d
    ON d.discipline_id = s.discipline_id
WHERE s.group_number IN ('ИТ-21', 'ИТ-22')
AND NOT EXISTS (
    SELECT 1
    FROM lab_infotech_schedule AS t
    WHERE t.lab_number = s.lab_number
      AND t.day_of_week = s.day_of_week
      AND t.lesson_number = s.lesson_number
      AND t.discipline_name = d.name
      AND t.group_number = s.group_number
);


-- 5 Перенести вторые пары на пятые
UPDATE lab_infotech_schedule
SET lesson_number = 5
WHERE lesson_number = 2;


-- 6 Удалить математику, информатику и физику
DELETE FROM lab_infotech_schedule
WHERE discipline_name IN ('Математика', 'Информатика', 'Физика');


-- 7 Посчитать количество занятий по каждой дисциплине
SELECT
    discipline_name,
    COUNT(*) AS lessons_per_week
FROM lab_infotech_schedule
GROUP BY discipline_name
ORDER BY discipline_name;

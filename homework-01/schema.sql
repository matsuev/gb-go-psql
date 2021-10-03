/*
 * База для хранения результатов комплексной олимпиады для школьников Красноярской Летней Школы (КЛШ).
 *
 * Олимпиада состоит из N предметных этапов (stage) поделенных на M научных направлений (department).
 * Каждый школьник (student) за 3 часа должен пройти произвольное (по выбору школьника) количество этапов.
 * Максимальное время проходжения одного этапа - 15 минут.
 *
 * На каждом этапе школьнику предлагается комплект из K задач (task) различных уровней сложности (level).
 * Решение задач проверяется учителем (teacher) непосредственно на этапе.
 *
 * За решение каждой задачи школьник набирает баллы (менше, либо равные максимально возможной оценке за
 * уровень сложности задачи).
 *
 * В итоговом протоколе (result) фиксируются:
 * -- идентификатор школьника
 * -- идентификатор проверяющего учителя
 * -- идентификатор задачи
 * -- количество набранных баллов
 * -- время начала решения
 * -- время окончания решения
 *
 */

\c golangdb

-- Таблица школьников

DROP TABLE IF EXISTS students CASCADE;
CREATE TABLE students (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор школьника
   lname VARCHAR(50) NOT NULL,            -- Фамилия школьника
   fname VARCHAR(50) NOT NULL,            -- Имя школьника
   email VARCHAR(100) UNIQUE NOT NULL     -- Контактный адрес электронной почты
);

-- Таблица учителей

DROP TABLE IF EXISTS teachers CASCADE;
CREATE TABLE teachers (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор учителя
   lname VARCHAR(50) NOT NULL,            -- Фамилия учителя
   fname VARCHAR(50) NOT NULL,            -- Имя учителя
   email VARCHAR(100) UNIQUE NOT NULL     -- Контактный адрес электронной почты
);

-- Таблица научных направлений

DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE departments (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор научного направления
   name VARCHAR(50),                      -- Название направления
   description TEXT                       -- Описание тематики направления
);

-- Таблица предметных этапов

DROP TABLE IF EXISTS stages CASCADE;
CREATE TABLE stages (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор этапа
   departmentId INT NOT NULL,         -- Идентификатор направления
   name VARCHAR(250) NOT NULL,            -- Название этапа
   description TEXT,                      -- Описание тематики этапа
   FOREIGN KEY (departmentId) REFERENCES departments (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Таблица уровней сложности задач

DROP TABLE IF EXISTS levels CASCADE;
CREATE TABLE levels (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор уровня сложности
   name VARCHAR(100) NOT NULL,            -- Название уровня сложности
   max_grade INT NOT NULL             -- Максимально возможная оценка
);

-- Таблица задач
DROP TABLE IF EXISTS tasks CASCADE;
CREATE TABLE tasks (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор задачи
   levelId INT NOT NULL,              -- Идентификатор уровня сложности
   stageId INT NOT NULL,              -- Идентификатор предметного этапа
   title TEXT NOT NULL,                   -- Заголовок задачи
   content TEXT,                          -- Текст задачи
   comments TEXT,                         -- Комментарии для проверяющего учителя
   FOREIGN KEY (levelId) REFERENCES levels (id) ON UPDATE CASCADE ON DELETE RESTRICT,
   FOREIGN KEY (stageId) REFERENCES stages (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Таблица результатов

DROP TABLE IF EXISTS results CASCADE;
CREATE TABLE results (
   id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,   -- Идентификатор результата
   studentId INT NOT NULL,            -- Идентификатор школьника
   teacherId INT NOT NULL,            -- Идентификатор проверяющего учителя
   taskId INT NOT NULL,               -- Идентификатор задачи
   grade INT NOT NULL,                -- Оценка
   started_at TIMESTAMP NOT NULL,         -- Время начала решения задачи
   finished_at TIMESTAMP NOT NULL,        -- Время окончания решения задачи
   FOREIGN KEY (studentId) REFERENCES students (id) ON UPDATE CASCADE ON DELETE RESTRICT,
   FOREIGN KEY (teacherId) REFERENCES teachers (id) ON UPDATE CASCADE ON DELETE RESTRICT,
   FOREIGN KEY (taskId) REFERENCES tasks (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

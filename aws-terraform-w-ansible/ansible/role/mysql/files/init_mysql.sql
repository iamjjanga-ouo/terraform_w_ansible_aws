CREATE DATABASE IF NOT EXISTS `free_board` CHARACTER SET utf8 COLLATE utf8_general_ci;
USE free_board;

CREATE TABLE IF NOT EXISTS `board` (
    `num` int NOT NULL,
    `title` varchar(50) NOT NULL,
    `writer` varchar(50) NOT NULL,
    `views` int NOT NULL,
    `context` varchar(200) NOT NULL
);

INSERT INTO `board` (num, title, writer, views, context) 
    SELECT * FROM (SELECT '1', 'title_1', 'Hong gil dong', '10', 'Hello') AS tmp
    WHERE NOT EXISTS (
        SELECT num FROM `board` WHERE num = '1'
    ) LIMIT 1;
INSERT INTO `board` (num, title, writer, views, context) 
    SELECT * FROM (SELECT '2', 'title_2', 'Kim Do Hyung', '7', 'This is test!') AS tmp
    WHERE NOT EXISTS (
        SELECT num FROM `board` WHERE num = '2'
    ) LIMIT 1;
INSERT INTO `board` (num, title, writer, views, context) 
    SELECT * FROM (SELECT '3', 'title_333', 'Lee Si hyung', '17', '') AS tmp
    WHERE NOT EXISTS (
        SELECT num FROM `board` WHERE num = '3'
    ) LIMIT 1;
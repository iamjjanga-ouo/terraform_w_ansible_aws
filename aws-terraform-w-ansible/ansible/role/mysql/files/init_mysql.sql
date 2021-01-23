CREATE DATABASE `free_board` CHARACTER SET utf8 COLLATE utf8_general_ci;
USE free_board;

CREATE TABLE `board` (
    `num` int NOT NULL,
    `title` varchar(50) NOT NULL,
    `writer` varchar(50) NOT NULL,
    `views` int NOT NULL,
    `context` varchar(200) NOT NULL
);

INSERT INTO `board` (`num`, `title`, `writer`, `views`, `context`) VALUES ('1', 'title_1', 'Hong gil dong', '10', 'Hello');
INSERT INTO `board` (`num`, `title`, `writer`, `views`, `context`) VALUES ('2', 'title_2', 'Kim Do Hyung', '7', 'This is test!');
INSERT INTO `board` (`num`, `title`, `writer`, `views`, `context`) VALUES ('3', 'title_333', 'Lee Si hyung', '17', '');
CREATE DATABASE IF NOT EXISTS `phpchat`;

-- Sirve para evitar errores en versiones y poder importar la base de datos
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION; -- Evita el autocommit y permite que se puedan hacer varias consultas
SET time_zone = "+00:00";

-- Creación de la tabla canal
DROP TABLE IF EXISTS `channel`;
CREATE TABLE `channel` (  
    id int(11) NOT NULL,
    sender int(11) DEFAULT NULL,
    receiver int(11) DEFAULT NULL,
    group_id int(11) DEFAULT NULL,
    message_id int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; -- InnoDB es un motor de almacenamiento de datos que permite acelerar el proceso de consultas y mejorar el rendimiento mientras que utf8mb4 es una codificación de caracteres que permite almacenar caracteres con tamaño mayor a 4 bytes

-- Creación de la tabla comentario
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (  
    id int(11) NOT NULL,
    comment_owner int(11) DEFAULT NULL,
    post_id int(11) DEFAULT NULL,
    comment_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    comment_edit_date timestamp NULL DEFAULT NULL,
    comment_text text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; --Timestamp es mas ligero y preciso y es variable dependiendo de la zona horaria mientras que datetime es constante

-- Creación de la tabla like
CREATE TABLE `likes` (  
    id int(11) NOT NULL,
    post_id int(11) DEFAULT NULL,
    user_id int(11) DEFAULT NULL,
    like_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla message
CREATE TABLE `message` (  
    id int(11) NOT NULL,
    message_creator int(11) DEFAULT NULL,
    message text DEFAULT NULL,
    create_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    is_reply int(11) DEFAULT NULL,
    reply_to int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla destinatario
CREATE TABLE `message_receiver` (  
    id int(11) NOT NULL,
    receiver_id int(11) DEFAULT NULL,
    message_id int(11) DEFAULT NULL,
    is_read tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- -- Creación de la tabla post
CREATE TABLE `post` (  
    id int(11) NOT NULL,
    post_owner int(11) DEFAULT NULL,
    post_visibility int(11) NOT NULL DEFAULT 0,
    post_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    post_edit_date timestamp NULL DEFAULT NULL,
    text_content text DEFAULT NULL,
    picture_media text DEFAULT NULL,
    video_media text DEFAULT NULL,
    post_place int(11) DEFAULT 1,
    is_shared int(11) DEFAULT 0,
    post_shared_id int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla Post_place
CREATE TABLE `post_place` (  
    id int(11) NOT NULL,
    post_place varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertando datos de la tabla post_place
INSERT INTO `post_place` (`id`, `post_place`) VALUES
(1, 'timeline'),
(2, 'grupo');

-- Creación de la tabla post_visibility
CREATE TABLE `post_visibility` (  
    id int(11) NOT NULL,
    visibility varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertando datos de la tabla post_visibility
INSERT INTO `post_visibility` (`id`, `visibility`) VALUES
(1, 'publico'),
(2, 'amigos'),
(3, 'privado');

-- ---------------------------------------------------------------------
-- -- Creación de la tabla sesión de usuario
CREATE TABLE `users_session` (
    id int(11) NOT NULL,
    user_id int(11) DEFAULT NULL,
    hash varchar(64) DEFAULT NULL -- Token de sesión
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla seguidores
CREATE TABLE `user_follow` (  
    id int(11) NOT NULL,
    follower_id int(11) DEFAULT NULL,
    followed_id int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla información de usuario
CREATE TABLE `user_info` (  
    id int(11) NOT NULL,
    username varchar(20) DEFAULT NULL,
    password varchar(64) DEFAULT NULL,
    sal varchar(64) DEFAULT NULL,
    name varchar(50) DEFAULT NULL,
    lastname varchar(50) DEFAULT NULL,
    joined timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    user_type int(11) DEFAULT NULL,
    email varchar(255) DEFAULT '',
    bio varchar(800) DEFAULT NULL,
    picture text DEFAULT NULL,
    portada text DEFAULT NULL,
    private int(11) DEFAULT -1,
    last_active_update timestamp NULL DEFAULT null

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla user_metadata
CREATE TABLE `user_metadata` (  
    id int(11) NOT NULL,
    label varchar(200) DEFAULT NULL,
    content varchar(200) DEFAULT NULL,
    user_id int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla Relación de usuario
CREATE TABLE `user_relation` (  
    id int(11) NOT NULL,
    `from` int(11) NOT NULL,
    `to` int(11) NOT NULL,
    `status` int(11) DEFAULT NULL,
    since timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de la tabla user_type
CREATE TABLE `user_type` (  
    id int(11) NOT NULL,
    type_name varchar(30) DEFAULT NULL,
    permission text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertando datos de la tabla user_type
INSERT INTO `user_type` (`id`, `type_name`, `permission`) VALUES
(1, 'Usuario', null),
(2, 'Admin', '{\"admin\":1}');

-- Creación de la tabla notificaciones de mensajes
CREATE TABLE `message_notifier` (
    message_id int(11) DEFAULT NULL,
    receiver_id int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Establecer indices de las tablas
ALTER TABLE `channel`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_index` (`post_id`,`user_id`);

ALTER TABLE `message`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `message_receiver`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message_id` (`message_id`);

ALTER TABLE `post`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_post_place` (`post_place`);

ALTER TABLE `post_place`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `post_visibility`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `users_session`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `user_follow`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `follow_unique` (`follower_id`,`followed_id`);

ALTER TABLE `user_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

ALTER TABLE `user_metadata`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_label_UK` (`label`,`user_id`);

ALTER TABLE `user_relation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQUE_RELATION` (`from`,`to`,`status`);

ALTER TABLE `user_type`
  ADD PRIMARY KEY (`id`);

-- Establecer los autoincrementos de las tablas
ALTER TABLE `channel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `message_receiver`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `post`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `post_place`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `post_visibility`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `users_session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `user_follow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `user_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `user_metadata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `user_relation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `user_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- Establecer las claves foráneas de las tablas
ALTER TABLE `message_receiver`
    ADD CONSTRAINT `message_receiver_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `message` (`id`) ON DELETE SET NULL;

-- ibfk significa "inbound foreign key"
-- inbound significa "hacia adentro"

ALTER TABLE `post`
    ADD CONSTRAINT `fk_post_place` FOREIGN KEY (`post_place`) REFERENCES `post_place` (`id`);

COMMIT; -- Un commit es necesario para que se ejecute el script

DELIMITER $$ -- Un DELIMITER sirve para delimitar el inicio de una función

-- Procedure para obtener los datos de un usuario
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `sp_get_discussions`(IN `user_id` INT) 
BEGIN SELECT MAX (M.id) 
AS mid, M.message_creator 
AS message_creator, MR.receiver_id 
AS message_receiver, M.create_date 
AS message_date, MR.is_read 
AS is_read FROM message 
AS M INNER JOIN message_receiver AS MR ON M.id = MR.message_id 
WHERE M.message_creator = user_id OR MR.receiver_id = user_id 
GROUP BY M.message_creator, MR.receiver_id
ORDER BY mid DESC;

END$$ 

DELIMITER ; -- Un definer es una función que se ejecuta antes de cada query, un procedure es una función que se ejecuta después de cada query

-- sp_get_discussions significa que es un procedimiento almacenado
-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Tiempo de generación: 18-05-2026 a las 00:24:46
-- Versión del servidor: 8.0.43
-- Versión de PHP: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `figurineitout`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `moderator`
--

CREATE TABLE `moderator` (
  `id_moderator` int NOT NULL,
  `id_user` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `object`
--

CREATE TABLE `object` (
  `id_object` int NOT NULL,
  `name` varchar(250) NOT NULL,
  `route` varchar(250) NOT NULL,
  `creation_date` datetime DEFAULT NULL,
  `id_party` int NOT NULL,
  `id_player` int NOT NULL,
  `id_moderator` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `party`
--

CREATE TABLE `party` (
  `id_party` int NOT NULL,
  `started_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `playedparty`
--

CREATE TABLE `playedparty` (
  `id_played` int NOT NULL,
  `id_player` int NOT NULL,
  `id_party` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `player`
--

CREATE TABLE `player` (
  `id_player` int NOT NULL,
  `id_user` int NOT NULL,
  `bannedby` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `id_user` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `password` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `moderator`
--
ALTER TABLE `moderator`
  ADD PRIMARY KEY (`id_moderator`,`id_user`),
  ADD UNIQUE KEY `user` (`id_user`),
  ADD UNIQUE KEY `id_user` (`id_user`) USING BTREE;

--
-- Indices de la tabla `object`
--
ALTER TABLE `object`
  ADD PRIMARY KEY (`id_object`),
  ADD KEY `id_party` (`id_party`);

--
-- Indices de la tabla `party`
--
ALTER TABLE `party`
  ADD PRIMARY KEY (`id_party`);

--
-- Indices de la tabla `playedparty`
--
ALTER TABLE `playedparty`
  ADD PRIMARY KEY (`id_played`),
  ADD UNIQUE KEY `playedparty_id_party_id_player_unique` (`id_player`,`id_party`),
  ADD KEY `id_party` (`id_party`),
  ADD KEY `id_player` (`id_player`) USING BTREE;

--
-- Indices de la tabla `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`id_player`,`id_user`),
  ADD UNIQUE KEY `user` (`id_user`),
  ADD UNIQUE KEY `id_user` (`id_user`) USING BTREE;

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`,`name`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `moderator`
--
ALTER TABLE `moderator`
  MODIFY `id_moderator` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `object`
--
ALTER TABLE `object`
  MODIFY `id_object` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `party`
--
ALTER TABLE `party`
  MODIFY `id_party` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `playedparty`
--
ALTER TABLE `playedparty`
  MODIFY `id_played` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `player`
--
ALTER TABLE `player`
  MODIFY `id_player` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `object`
--
ALTER TABLE `object`
  ADD CONSTRAINT `object_ibfk_1` FOREIGN KEY (`id_party`) REFERENCES `party` (`id_party`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `playedparty`
--
ALTER TABLE `playedparty`
  ADD CONSTRAINT `playedparty_ibfk_1` FOREIGN KEY (`id_player`) REFERENCES `player` (`id_player`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `playedparty_ibfk_2` FOREIGN KEY (`id_party`) REFERENCES `party` (`id_party`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `player`
--
ALTER TABLE `player`
  ADD CONSTRAINT `player_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

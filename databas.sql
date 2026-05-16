-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Värd: 127.0.0.1
-- Tid vid skapande: 16 maj 2026 kl 18:44
-- Serverversion: 10.4.32-MariaDB
-- PHP-version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databas: `betygsgrundande`
--

-- --------------------------------------------------------

--
-- Tabellstruktur `posts`
--

CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellstruktur `threads`
--

CREATE TABLE `threads` (
  `user_id` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumpning av Data i tabell `threads`
--

INSERT INTO `threads` (`user_id`, `title`, `thread_id`, `created_at`) VALUES
(12, 'Hur programmerar man?', 6, '0000-00-00 00:00:00'),
(12, 'Är milo bra på golf?', 7, '0000-00-00 00:00:00'),
(12, 'Är neo bra på att fiska?', 8, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Tabellstruktur `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(11) NOT NULL,
  `username` varchar(11) NOT NULL,
  `password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumpning av Data i tabell `users`
--

INSERT INTO `users` (`user_id`, `name`, `username`, `password`) VALUES
(1, 'milo', 'milos', 'hej'),
(2, 'neo', 'neos', 'hallå'),
(4, '', 'hejj', 'scrypt:32768:8:1$HAfWHM4Eyeegx20m$3f76a8e2b0437bef60e5c9237500b27fbf41e6e8431172e8a4f5bcd5ca303542290e45dd396ffa40f67eb958218a965cb4d693408a9b73adf96bb04adb154d38'),
(5, '', 'william', 'scrypt:32768:8:1$P0T6hQ1n1TNOqXeo$d3fc77e4db7fc18b18f7a0fbaa3a148b18f2b3054d5a61cf46bf18c4dd225b270b93e9c5ecd5befae9d2da57213cac326ccc77205ae84def85d3ec232932bc5e'),
(6, '', 'oliver', 'scrypt:32768:8:1$UC4LZ07DCwRKkZz8$8c529f0f48f564614bd79d0ece8c23ec8aee6c39ab2f358ac9b9b6ca36e801954f11533d7c192a44c99935002844d21c6da1e63b5fdc121ad5a52ec661b2808d'),
(7, '', 'oliver1', 'scrypt:32768:8:1$fcuU6QNfXI3tbwJY$ac9b071bff9f1493eb59064c45f944de87b30ef6dedbddaa1e71b216020bb909a6b2f87d9f3a9757518f1544cbcaedb68b5043c07cb509bf46e6b188bc0ed5f8'),
(8, '', 'william1', 'scrypt:32768:8:1$Kpq1VDQ4sGX4ifEo$cb4f11e20b3c295f89adccb95244989b1e0ca3eb5859317c91a1ac822c5804645cdd61c8805731cdce684f3208676a525723f38df058fe23ce075c575ba4f1b1'),
(9, '', 'Milo', 'scrypt:32768:8:1$y1MBVmK6WfzH8HQU$d23741242889d0c12523e0d68c8cff646985405848ce7a938b7a569feefbb38c09e9ed680b53d0dd0108839d4d945a5ba3d8a9fac668ad07e01c1a54b43cd2ef'),
(10, '', 'Arvid', 'scrypt:32768:8:1$Lnabp1E7T7DcmThP$0f3e9c0d4297db2577129a06c32d61470a10955f9a5a70302863224926e9fde63883e2e7b4847651c851563906e3028c17a6a8e84d021ed6b7d79cc0cb13ba83'),
(11, '', 'Milo1', 'scrypt:32768:8:1$flmbF8zGqQ8Y9N7p$4fdb3d702c8e7583a7be65947b3ea5fad7fd35ce929201a6529d10927316edf1026c22bad32f2927a95ffe33fc1adefea0ce8df6c9b35077f6a4072cd619dd73'),
(12, '', 'hejsan', 'scrypt:32768:8:1$tsKwVUUYFFcZv9um$115a6d1266f38f082308fec5bef05a3fb160dfe028b3df8f771d5067b73f94ddcd32fe785e790a6948a43e59c0949ee976ee4ab0845365ebc349caa7a956166a');

--
-- Index för dumpade tabeller
--

--
-- Index för tabell `threads`
--
ALTER TABLE `threads`
  ADD PRIMARY KEY (`thread_id`);

--
-- Index för tabell `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT för dumpade tabeller
--

--
-- AUTO_INCREMENT för tabell `threads`
--
ALTER TABLE `threads`
  MODIFY `thread_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT för tabell `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

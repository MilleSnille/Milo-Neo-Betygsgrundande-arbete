-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Värd: 127.0.0.1
-- Tid vid skapande: 18 maj 2026 kl 22:15
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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumpning av Data i tabell `posts`
--

INSERT INTO `posts` (`post_id`, `thread_id`, `user_id`, `content`, `created_at`) VALUES
(6, 6, 12, 'vet inte', '2026-05-17 15:57:54'),
(7, 6, 12, 'ingen aning', '2026-05-17 16:04:19'),
(8, 6, 13, 'jag vet inte', '2026-05-18 09:54:08'),
(12, 10, 17, 'Joj', '2026-05-18 10:36:07'),
(14, 14, 18, 'HOJ', '2026-05-18 11:35:02'),
(15, 18, 20, 'joj', '2026-05-18 12:32:46'),
(16, 17, 20, 'jojh', '2026-05-18 12:32:57'),
(20, 19, 20, 'HOlle', '2026-05-18 12:47:11'),
(23, 22, 17, 'Ja han är jätteduktig', '2026-05-18 20:13:59'),
(24, 23, 17, 'nej han brukar inte få så mycket fisk', '2026-05-18 20:14:12');

-- --------------------------------------------------------

--
-- Tabellstruktur `threads`
--

CREATE TABLE `threads` (
  `user_id` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumpning av Data i tabell `threads`
--

INSERT INTO `threads` (`user_id`, `title`, `thread_id`, `created_at`) VALUES
(12, 'hur får man mycket fisk på kroken?', 9, '2026-05-17 15:59:07'),
(13, 'vilken är den bästa maträtten?', 10, '2026-05-17 16:29:28'),
(5, 'Bello', 11, '2026-05-18 11:13:44'),
(17, 'geh', 12, '2026-05-18 11:22:45'),
(5, 'jub', 13, '2026-05-18 11:27:54'),
(17, 'lol', 14, '2026-05-18 11:32:07'),
(17, 'noå', 15, '2026-05-18 11:32:13'),
(17, 'noa', 16, '2026-05-18 11:32:18'),
(5, 'y', 17, '2026-05-18 11:32:22'),
(17, 'blabla', 18, '2026-05-18 11:32:32'),
(20, 'JOLLE', 19, '2026-05-18 12:47:05'),
(22, 'Hejl', 20, '2026-05-18 13:17:17'),
(23, 'hur programmerar man?', 21, '2026-05-18 20:12:38'),
(17, 'Är milo bra på golf?', 22, '2026-05-18 20:13:35'),
(17, 'Är neo bra på att fiska?', 23, '2026-05-18 20:13:43');

-- --------------------------------------------------------

--
-- Tabellstruktur `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(11) NOT NULL,
  `username` varchar(11) NOT NULL,
  `password` varchar(250) NOT NULL,
  `role` varchar(20) DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumpning av Data i tabell `users`
--

INSERT INTO `users` (`user_id`, `name`, `username`, `password`, `role`) VALUES
(1, 'milo', 'milos', 'hej', 'user'),
(2, 'neo', 'neos', 'hallå', 'user'),
(4, '', 'hejj', 'scrypt:32768:8:1$HAfWHM4Eyeegx20m$3f76a8e2b0437bef60e5c9237500b27fbf41e6e8431172e8a4f5bcd5ca303542290e45dd396ffa40f67eb958218a965cb4d693408a9b73adf96bb04adb154d38', 'user'),
(5, '', 'william', 'scrypt:32768:8:1$P0T6hQ1n1TNOqXeo$d3fc77e4db7fc18b18f7a0fbaa3a148b18f2b3054d5a61cf46bf18c4dd225b270b93e9c5ecd5befae9d2da57213cac326ccc77205ae84def85d3ec232932bc5e', 'user'),
(6, '', 'oliver', 'scrypt:32768:8:1$UC4LZ07DCwRKkZz8$8c529f0f48f564614bd79d0ece8c23ec8aee6c39ab2f358ac9b9b6ca36e801954f11533d7c192a44c99935002844d21c6da1e63b5fdc121ad5a52ec661b2808d', 'user'),
(7, '', 'oliver1', 'scrypt:32768:8:1$fcuU6QNfXI3tbwJY$ac9b071bff9f1493eb59064c45f944de87b30ef6dedbddaa1e71b216020bb909a6b2f87d9f3a9757518f1544cbcaedb68b5043c07cb509bf46e6b188bc0ed5f8', 'user'),
(8, '', 'william1', 'scrypt:32768:8:1$Kpq1VDQ4sGX4ifEo$cb4f11e20b3c295f89adccb95244989b1e0ca3eb5859317c91a1ac822c5804645cdd61c8805731cdce684f3208676a525723f38df058fe23ce075c575ba4f1b1', 'user'),
(9, '', 'Milo', 'scrypt:32768:8:1$y1MBVmK6WfzH8HQU$d23741242889d0c12523e0d68c8cff646985405848ce7a938b7a569feefbb38c09e9ed680b53d0dd0108839d4d945a5ba3d8a9fac668ad07e01c1a54b43cd2ef', 'admin'),
(10, '', 'Arvid', 'scrypt:32768:8:1$Lnabp1E7T7DcmThP$0f3e9c0d4297db2577129a06c32d61470a10955f9a5a70302863224926e9fde63883e2e7b4847651c851563906e3028c17a6a8e84d021ed6b7d79cc0cb13ba83', 'user'),
(11, '', 'Milo1', 'scrypt:32768:8:1$flmbF8zGqQ8Y9N7p$4fdb3d702c8e7583a7be65947b3ea5fad7fd35ce929201a6529d10927316edf1026c22bad32f2927a95ffe33fc1adefea0ce8df6c9b35077f6a4072cd619dd73', 'user'),
(12, '', 'hejsan', 'scrypt:32768:8:1$tsKwVUUYFFcZv9um$115a6d1266f38f082308fec5bef05a3fb160dfe028b3df8f771d5067b73f94ddcd32fe785e790a6948a43e59c0949ee976ee4ab0845365ebc349caa7a956166a', 'user'),
(13, '', 'milos3', 'scrypt:32768:8:1$zWk3lFOlKIbvxq0f$9f052ab0f417cf43684f687306aaa4037d7f385d79667809a82e54cec545a14e44110d2522ff1ab121421bdfe9f3fd36b4020858d3b3810a8c7013d55d13fd3f', 'user'),
(14, '', 'Hej', 'scrypt:32768:8:1$7IAKcsTxiMIZwl5w$655c7d59a07f392be5d89d17cff7f3983978ad40faff6e27b6f8c7fafbf6c07f66511cd32439d9f956b25274f18fa76a9e122b4a03a18111c0ad27ce59b3c8b5', 'user'),
(15, '', 'Hoj', 'scrypt:32768:8:1$MaYZd4QeI2rEicTL$6ca91c842491997e7b01a8ad09d6347aaa218e62cfbcbbc33eebbf556f2f6f830e5621be8c59e6547214c2147e127ca8ca78e23295d9db361c01c1e3d54ed4f2', 'user'),
(16, '', 'Loj', 'scrypt:32768:8:1$mWPedL97HCErm6oc$bff885599c4b33b1a5cfb3336d02b814c8d9ed34d1a38c91b59608152323b8191f875c398b9d463d100c216f44bf5a6ddb02e68d743c8cb3d5b437b4e4bbedb0', 'user'),
(17, '', 'Bon', 'scrypt:32768:8:1$Eg2zEuRrnZ8siV3P$37baeacacfe95ba9f6e53c80a4f904d6959c7fcf0937e2e5a4afba690d103bea41216173e167ab32b676e23a8995856d33c28813cc81339b126f8e4aaa81888c', 'user'),
(18, '', 'charles', 'scrypt:32768:8:1$xmnrNU3lfrzNDOxg$936beb8f5a16d664d90dd1f2fcd9768141f0aa6b9441fee4298854ed86966a8345635a0064488ad849b95202dcaed6052796351adf44f910072fe8ce62f059f7', 'user'),
(19, '', 'william2', 'scrypt:32768:8:1$am5eJF57n4sC0PIQ$86297996fe5cc7f562d66af58bcbfff7533fade60e9ecdd4a50b3aafe6371c78f0a11c40059ae088319496e31ffb147882ee9d10d7f690b3cba8b6bb4b5a108f', 'user'),
(20, '', 'william3', 'scrypt:32768:8:1$P6SWIRsom3TF9IQG$3b9acd6ed850e706645f33738d1e6274ba06449d9fbcc96052126c4dca6385710f6aff6eecd3d10dd4cd4d0ee0b347e41e863a14cd99c7cd33d9b7a53e74408a', 'user'),
(21, '', 'milo5', 'scrypt:32768:8:1$AZxfZqaWzqObtLKu$5b2ab96eebeae848a3de290dc8122e035dba1cb6bc630550d0088125f31ffd4f8bd3461db326d9b59a94d02199deb90c22ccec391f3126f2947327cd4e469e43', 'user'),
(22, '', 'Jak', 'scrypt:32768:8:1$R2oioth1NvP30aYv$71af17ac2bc4e3d080f97aa7eac82c9405321a471db56eeaa45168999dd42c1c6c72e6c54634f84a9ee912dc81cb09cdc43b10086bbfbe72e1803a925e9bf781', 'user'),
(23, '', 'milo4', 'scrypt:32768:8:1$IBMXLYOpGPn2Ljt0$0b93023284fce4e423730d49c895313620f4b5faeffbe3a7b12cf68682410713fcb2ded73388ca024e8dddb817785a479a253aca084f4daa2e8390f3ed5571af', 'user');

--
-- Index för dumpade tabeller
--

--
-- Index för tabell `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`);

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
-- AUTO_INCREMENT för tabell `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT för tabell `threads`
--
ALTER TABLE `threads`
  MODIFY `thread_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT för tabell `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 3.5.2
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2013 年 03 月 17 日 15:10
-- 服务器版本: 5.5.25a
-- PHP 版本: 5.4.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `bulkmail`
--
DROP DATABASE `bulkmail`;
CREATE DATABASE `bulkmail` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `bulkmail`;

-- --------------------------------------------------------

--
-- 表的结构 `tb_user`
--
-- 创建时间: 2013 年 03 月 17 日 06:20
--

CREATE TABLE IF NOT EXISTS `tb_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `passwd` varchar(32) NOT NULL,
  `import_jobs` int(11) DEFAULT NULL,
  `send_jobs` int(11) DEFAULT NULL,
  `import_jobs_id` int(11) DEFAULT NULL,
  `send_jobs_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `tb_user`
--

INSERT INTO `tb_user` (`id`, `username`, `passwd`, `import_jobs`, `send_jobs`, `import_jobs_id`, `send_jobs_id`) VALUES
(1, 'admin', '96e79218965eb72c92a549dd5a330112', NULL, NULL, NULL, NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

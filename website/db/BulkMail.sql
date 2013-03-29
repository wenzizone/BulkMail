-- phpMyAdmin SQL Dump
-- version 3.5.7
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2013 年 03 月 29 日 16:36
-- 服务器版本: 5.1.61-log
-- PHP 版本: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `BulkMail`
--

-- --------------------------------------------------------

--
-- 表的结构 `tb_file`
--
-- 创建时间: 2013 年 03 月 29 日 07:13
--

DROP TABLE IF EXISTS `tb_file`;
CREATE TABLE IF NOT EXISTS `tb_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(45) DEFAULT NULL,
  `originname` varchar(45) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `file_hash` varchar(32) DEFAULT NULL,
  `info` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `tb_file`
--

INSERT INTO `tb_file` (`id`, `filename`, `originname`, `user_id`, `file_hash`, `info`) VALUES
(1, 'uploads/849f16bf6ebb299586130c9dbb447bd9.txt', 'testmail.txt', 1, '849f16bf6ebb299586130c9dbb447bd9', '测试使用邮箱');

-- --------------------------------------------------------

--
-- 表的结构 `tb_import_jobs`
--
-- 创建时间: 2013 年 03 月 22 日 03:36
--

DROP TABLE IF EXISTS `tb_import_jobs`;
CREATE TABLE IF NOT EXISTS `tb_import_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `starttime` datetime DEFAULT NULL,
  `finishtime` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `tb_import_jobs`
--

INSERT INTO `tb_import_jobs` (`id`, `file_id`, `status`, `starttime`, `finishtime`, `user_id`) VALUES
(1, 1, 'finished', '2013-03-29 16:16:59', '2013-03-29 16:21:35', 1);

-- --------------------------------------------------------

--
-- 表的结构 `tb_send_jobs`
--
-- 创建时间: 2013 年 03 月 22 日 03:36
--

DROP TABLE IF EXISTS `tb_send_jobs`;
CREATE TABLE IF NOT EXISTS `tb_send_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `starttime` datetime DEFAULT NULL,
  `finishtime` datetime DEFAULT NULL,
  `emaillist` varchar(45) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `tb_tablename`
--
-- 创建时间: 2013 年 03 月 28 日 05:36
--

DROP TABLE IF EXISTS `tb_tablename`;
CREATE TABLE IF NOT EXISTS `tb_tablename` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tablename` varchar(45) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `tb_tablename`
--

INSERT INTO `tb_tablename` (`id`, `tablename`, `user_id`) VALUES
(1, '849f16bf6ebb299586130c9dbb447bd9', 1);

-- --------------------------------------------------------

--
-- 表的结构 `tb_user`
--
-- 创建时间: 2013 年 03 月 22 日 03:36
--

DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE IF NOT EXISTS `tb_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `passwd` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `tb_user`
--

INSERT INTO `tb_user` (`id`, `username`, `passwd`) VALUES
(1, 'admin', '96e79218965eb72c92a549dd5a330112');

-- --------------------------------------------------------

--
-- 表的结构 `tb_user_profile`
--
-- 创建时间: 2013 年 03 月 22 日 09:02
--

DROP TABLE IF EXISTS `tb_user_profile`;
CREATE TABLE IF NOT EXISTS `tb_user_profile` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `company` varchar(45) DEFAULT NULL,
  `mobile_phone` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

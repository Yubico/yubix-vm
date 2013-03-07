-- MySQL dump 10.13  Distrib 5.5.29, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: ykksm
-- ------------------------------------------------------
-- Server version	5.5.29-0ubuntu0.12.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `yubikeys`
--

DROP TABLE IF EXISTS `yubikeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yubikeys` (
  `serialnr` int(11) NOT NULL,
  `publicname` varchar(16) NOT NULL,
  `created` varchar(24) NOT NULL,
  `internalname` varchar(12) NOT NULL,
  `aeskey` varchar(32) NOT NULL,
  `lockcode` varchar(12) NOT NULL,
  `creator` varchar(8) NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  `hardware` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`publicname`),
  UNIQUE KEY `publicname` (`publicname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yubikeys`
--

LOCK TABLES `yubikeys` WRITE;
/*!40000 ALTER TABLE `yubikeys` DISABLE KEYS */;
INSERT INTO `yubikeys` VALUES (1,'cccccccccccb','2013-01-28T14:39:38','78a773f45609','18355d9678fa224120cb8c2ea6ef8746','03e08a323dfb','C5B8D4EA',1,1),(2,'cccccccccccd','2013-01-28T14:39:38','aca438e6cbb6','2cc95299612e8396cb341a48d01e3e72','994e9f43ed0f','C5B8D4EA',1,1),(3,'ccccccccccce','2013-01-28T14:39:38','b49c89017f84','cfbc4cb0503d647923831e03fcaf33b4','2040a4e1a3fd','C5B8D4EA',1,1),(4,'cccccccccccf','2013-01-28T14:39:38','c0a10d6ed93f','844e83de63dc3619d539d101928d78f9','951bc51163f8','C5B8D4EA',1,1),(5,'cccccccccccg','2013-01-28T14:39:38','5397b4766e20','4176bd7d2b7cd90dd457c23634b2dbb6','db929ddea794','C5B8D4EA',1,1);
/*!40000 ALTER TABLE `yubikeys` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-07  0:57:11

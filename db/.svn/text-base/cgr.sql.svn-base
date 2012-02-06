-- MySQL dump 10.12
--
-- Host: localhost    Database: cgr
-- ------------------------------------------------------
-- Server version	5.1.19-beta

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
-- Table structure for table `cleaning_categories`
--

DROP TABLE IF EXISTS `cleaning_categories`;
CREATE TABLE `cleaning_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cleaning_categories`
--

LOCK TABLES `cleaning_categories` WRITE;
/*!40000 ALTER TABLE `cleaning_categories` DISABLE KEYS */;
INSERT INTO `cleaning_categories` VALUES (1,'Laundry'),(2,'Tablecloths'),(3,'Dry Cleaning'),(4,'Blankets'),(5,'Other'),(6,'Sheets'),(7,'Wash/Fold Laundry');
/*!40000 ALTER TABLE `cleaning_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cleaning_category_items`
--

DROP TABLE IF EXISTS `cleaning_category_items`;
CREATE TABLE `cleaning_category_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cleaning_category_id` int(11) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cleaning_category_items`
--

LOCK TABLES `cleaning_category_items` WRITE;
/*!40000 ALTER TABLE `cleaning_category_items` DISABLE KEYS */;
INSERT INTO `cleaning_category_items` VALUES (1,1,'Shirt',1.99),(2,1,'Shirt (fold)',2.75),(3,1,'Blouse',2.25),(4,1,'Blouse (pressed)',3.75),(5,1,'Pants',6.99),(6,1,'Jeans',6.99),(7,1,'Short',5.99),(8,1,'Polo',5.75),(9,1,'Tuxedo Shirt',3.99),(10,2,'Small',11.99),(11,2,'Medium',18.99),(12,2,'Large',29.99),(13,3,'Blouse',6.99),(14,3,'Blazer/Suit Coat',8.99),(15,3,'Long Coat',18.99),(16,3,'Dress',9.99),(17,3,'Jacket',11.99),(18,3,'Leather Jacket',40),(19,3,'Jump Suit',14.99),(20,3,'Pants/Slacks',6.99),(21,3,'Shirt',6.99),(22,3,'Shorts',5.99),(23,3,'Pleats (extra, each',0.25),(24,3,'Sweater',9.99),(25,3,'Tie',4.99),(26,3,'Tuxedo',14.99),(27,3,'Vest',5.5),(28,3,'Suit',15.99),(29,4,'Twin/Full',15.99),(30,4,'Queen/King',17.99),(31,4,'Twin/Full Dacron',26.99),(32,4,'Twin/Full Down',35.99),(33,4,'Queen/King Dacron',30.99),(34,4,'Queen/King Down',40.99),(35,5,'Pillow',16.99),(36,5,'Napkins',2.5),(37,5,'Linen, Silk Rayon, Lined (extra)',0.75),(38,6,'Regular (each)',6.99),(39,6,'Contour (each)',7.99),(40,6,'Satin (each)',18.99),(41,7,'Wash and fold',2.99);
/*!40000 ALTER TABLE `cleaning_category_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(128) NOT NULL,
  `last_name` varchar(128) NOT NULL,
  `email_address` varchar(128) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `address1` varchar(256) NOT NULL,
  `address2` varchar(256) DEFAULT NULL,
  `city` varchar(128) NOT NULL,
  `state` varchar(32) NOT NULL,
  `zip` varchar(16) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `alternate_phone` varchar(32) DEFAULT NULL,
  `birthday` varchar(32) DEFAULT NULL,
  `referred_by` varchar(128) DEFAULT NULL,
  `shirt_laundry` varchar(256) DEFAULT NULL,
  `dry_cleaning` varchar(256) DEFAULT NULL,
  `laundry` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email_address` (`email_address`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'tim','swetonic','swetonic@gmail.com',NULL,'420 NW 45th Street','','Seattle','WA','98107','206-390-9719','','10-23-1967','anne','very clean','dry and clean','dirty'),(2,'tim','swetonic','swetonic2@gmail.com',NULL,'420 NW 45th Street','','Seattle','WA','98107','206-706-9337','','10-23-1967','anne','very clean','dry and clean','dirty');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-06-18  2:26:10

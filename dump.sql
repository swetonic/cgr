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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'anne','harrison'),(2,'tim','akfvhlayc');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cleaning_categories`
--

DROP TABLE IF EXISTS `cleaning_categories`;
CREATE TABLE `cleaning_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cleaning_categories`
--

LOCK TABLES `cleaning_categories` WRITE;
/*!40000 ALTER TABLE `cleaning_categories` DISABLE KEYS */;
INSERT INTO `cleaning_categories` VALUES (1,'Laundry'),(2,'Tablecloths'),(3,'Dry Cleaning'),(4,'Blankets'),(5,'Other'),(6,'Sheets'),(7,'Wash/Fold Laundry'),(8,'Alterations');
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
  `delivery_price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cleaning_category_items`
--

LOCK TABLES `cleaning_category_items` WRITE;
/*!40000 ALTER TABLE `cleaning_category_items` DISABLE KEYS */;
INSERT INTO `cleaning_category_items` VALUES (1,1,'Shirt',1.5,1.99),(2,1,'Shirt (fold)',2.5,2.75),(3,1,'Blouse',2,2.25),(4,1,'Blouse (pressed)',3.5,3.75),(5,1,'Pants',5.5,6.99),(6,1,'Jeans',5.5,6.99),(7,1,'Short',5.5,5.99),(8,1,'Polo',5.5,5.75),(9,1,'Tuxedo Shirt',3,3.99),(10,2,'Small',10,11.99),(11,2,'Medium',18,18.99),(12,2,'Large',30,29.99),(13,3,'Blouse',5.5,6.99),(14,3,'Blazer/Suit Coat',5.5,8.99),(15,3,'Long Coat',15,18.99),(16,3,'Dress',8.5,9.99),(17,3,'Jacket',10,11.99),(18,3,'Leather Jacket',40,40),(19,3,'Jump Suit',11,14.99),(20,3,'Pants/Slacks',5.5,6.99),(21,3,'Shirt',5.5,6.99),(22,3,'Shorts',5,5.99),(23,3,'Pleats (extra, each',0.25,0.25),(24,3,'Sweater',8,9.99),(25,3,'Tie',3,4.99),(26,3,'Tuxedo',12.5,14.99),(27,3,'Vest',5.5,5.5),(28,3,'Suit',11,15.99),(29,4,'Twin/Full',15,15.99),(30,4,'Queen/King',17,17.99),(31,4,'Twin/Full Dacron',25,26.99),(32,4,'Twin/Full Down',35,35.99),(33,4,'Queen/King Dacron',30,30.99),(34,4,'Queen/King Down',40,40.99),(35,5,'Pillow',14,16.99),(36,5,'Napkins',2.5,2.5),(37,5,'Linen, Silk Rayon, Lined (extra)',0.75,0.75),(38,6,'Regular (each)',5.5,6.99),(39,6,'Contour (each)',5.5,7.99),(40,6,'Satin (each)',15,18.99),(41,7,'Wash and fold',2.99,2.99),(42,8,'Custom',0,0),(43,8,'Skirt Hem',10,10),(44,8,'Pants Hem',10,10);
/*!40000 ALTER TABLE `cleaning_category_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `no_perc_points`
--

DROP TABLE IF EXISTS `no_perc_points`;
CREATE TABLE `no_perc_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `points` int(11) DEFAULT '0',
  `reason` varchar(64) DEFAULT '',
  `order_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `no_perc_points`
--

LOCK TABLES `no_perc_points` WRITE;
/*!40000 ALTER TABLE `no_perc_points` DISABLE KEYS */;
INSERT INTO `no_perc_points` VALUES (1,1,3,'order',NULL),(2,1,55,'order',35),(3,1,133,'order',36),(4,2,289,'order',37),(5,3,38,'order',38),(6,3,37,'order',39);
/*!40000 ALTER TABLE `no_perc_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `cleaning_category_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `unit_price` float DEFAULT NULL,
  `discount` float DEFAULT '1',
  `admin_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (23,14,1,1,'','2009-07-06 03:19:01','2009-07-06 03:22:36',1.99,0.9,1),(24,14,13,2,'','2009-07-06 03:19:01','2009-07-06 03:22:36',6.99,0.9,1),(25,15,16,3,'','2009-07-06 18:57:11','2009-07-06 18:57:11',9.99,1,1),(26,15,13,2,'','2009-07-06 18:57:11','2009-07-06 18:57:11',6.99,1,1),(27,15,1,1,'','2009-07-06 18:57:11','2009-07-06 18:57:11',1.99,1,1),(28,16,1,11,'','2009-07-06 19:02:04','2009-07-06 19:02:04',1.99,1,1),(29,17,16,1,'','2009-07-06 19:22:48','2009-07-21 18:37:57',9.99,0.5,1),(30,17,28,1,'','2009-07-06 19:22:48','2009-07-21 18:37:57',15.99,0.5,1),(31,18,28,1,'','2009-07-06 19:43:53','2009-07-06 19:43:53',15.99,1,1),(32,19,28,2,'','2009-07-06 19:45:31','2009-07-06 23:23:14',15.99,0.9,1),(33,20,28,2,'','2009-07-06 22:36:35','2009-07-06 22:36:35',15.99,0.9,1),(34,21,43,1,'','2009-07-06 22:41:00','2009-07-06 22:41:00',10,1,1),(35,21,44,1,'','2009-07-06 22:41:00','2009-07-06 22:41:00',10,1,1),(36,22,1,1,'','2009-07-06 23:07:04','2009-07-21 18:38:42',1.99,1,1),(37,23,1,12,'','2009-07-06 23:11:31','2009-07-06 23:11:31',1.99,1,1),(38,24,1,2,'','2009-07-06 23:17:04','2009-07-06 23:17:04',1.99,1,1),(39,25,28,2,'','2009-07-06 23:20:41','2009-07-06 23:20:41',15.99,1,1),(40,26,1,22,'','2009-07-06 23:21:08','2009-07-06 23:21:08',1.99,1,1),(41,27,28,2,'','2009-07-06 23:27:52','2009-07-06 23:27:52',15.99,1,1),(42,27,1,1,'','2009-07-06 23:27:52','2009-07-06 23:27:52',1.99,1,1),(43,28,1,22,'','2009-07-07 02:35:22','2009-07-07 02:35:22',1.99,1,1),(44,29,16,1,'','2009-07-07 02:41:04','2009-07-07 02:41:04',9.99,1,1),(45,29,13,2,'one blue, one yellow','2009-07-07 02:41:04','2009-07-07 02:41:04',6.99,1,1),(46,29,28,2,'','2009-07-07 02:41:04','2009-07-07 02:41:04',15.99,1,1),(47,30,1,22,'','2009-07-07 02:46:46','2009-07-07 02:46:46',1.99,1,1),(48,31,28,2,'','2009-07-07 02:48:04','2009-07-07 02:50:20',15.99,0.9,1),(49,32,28,2,'','2009-07-07 15:24:23','2009-07-07 15:35:13',15.99,0.9,1),(50,32,44,1,'','2009-07-07 15:24:23','2009-07-07 15:35:13',10,0.9,1),(51,33,10,1,'','2009-07-07 21:29:31','2009-07-07 21:29:31',10,1,1),(52,33,43,1,'','2009-07-07 21:29:31','2009-07-07 21:29:31',10,1,1),(53,34,1,2,'','2009-07-08 03:59:31','2009-07-08 03:59:31',1.5,1,1),(54,35,28,5,'','2009-07-08 04:07:00','2009-07-08 04:07:00',11,1,1),(55,36,13,22,'','2009-07-08 04:41:39','2009-07-08 04:41:39',5.5,1,1),(56,37,28,24,'','2009-07-08 21:53:09','2009-07-08 21:53:09',11,1,2),(57,38,16,4,'','2009-07-08 21:55:37','2009-07-08 21:55:37',8.5,1,2),(58,39,1,22,'','2009-07-08 21:56:40','2009-07-08 21:56:40',1.5,1,2);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `paid` tinyint(1) DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `order_receipt` varchar(256) DEFAULT NULL,
  `date_needed` varchar(128) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (14,1,1,'2009-07-06 03:19:01','2009-07-06 03:23:35','/Users/tim/Desktop/receipts/orders/order-14.pdf',NULL,1),(15,1,0,'2009-07-06 18:57:11','2009-07-06 18:57:11','/Users/tim/Desktop/receipts/orders/order-15.pdf',NULL,1),(16,2,1,'2009-07-06 19:02:04','2009-07-06 19:03:07','/Users/tim/Desktop/receipts/orders/order-16.pdf',NULL,1),(17,1,1,'2009-07-06 19:22:48','2009-07-21 18:38:11','/Users/tim/Desktop/receipts/orders/order-17.pdf',NULL,1),(18,2,1,'2009-07-06 19:43:53','2009-07-21 18:36:25','/Users/tim/Desktop/receipts/orders/order-18.pdf',NULL,1),(19,1,1,'2009-07-06 19:45:31','2009-07-06 23:23:22','/Users/tim/Desktop/receipts/orders/order-19.pdf',NULL,1),(20,2,1,'2009-07-06 22:36:35','2009-07-06 22:44:46','/Users/tim/Desktop/receipts/orders/order-20.pdf',NULL,1),(21,2,1,'2009-07-06 22:41:00','2009-07-07 03:48:51','/Users/tim/Desktop/receipts/orders/order-21.pdf',NULL,1),(22,1,1,'2009-07-06 23:07:04','2009-07-21 18:38:46','/Users/tim/Desktop/receipts/orders/order-22.pdf',NULL,1),(23,1,1,'2009-07-06 23:11:31','2009-07-21 18:39:28','/Users/tim/Desktop/receipts/orders/order-23.pdf',NULL,1),(24,1,1,'2009-07-06 23:16:58','2009-07-07 03:50:51','/Users/tim/Desktop/receipts/orders/order-24.pdf','7-7-2009',1),(25,1,1,'2009-07-06 23:20:41','2009-07-06 23:22:39','/Users/tim/Desktop/receipts/orders/order-25.pdf','',1),(26,1,1,'2009-07-06 23:21:08','2009-07-06 23:22:05','/Users/tim/Desktop/receipts/orders/order-26.pdf','7-7-2009',1),(27,1,0,'2009-07-06 23:27:52','2009-07-06 23:27:52','/Users/tim/Desktop/receipts/orders/order-27.pdf','',1),(28,1,1,'2009-07-07 02:35:22','2009-07-08 04:33:29','/Users/tim/Desktop/receipts/orders/order-28.pdf','7-7-2009',1),(29,2,1,'2009-07-07 02:41:04','2009-07-07 03:44:38','/Users/tim/Desktop/receipts/orders/order-29.pdf','',1),(30,1,1,'2009-07-07 02:46:46','2009-07-07 15:36:52','/Users/tim/Desktop/receipts/orders/order-30.pdf','',1),(31,1,1,'2009-07-07 02:48:04','2009-07-07 02:50:27','/Users/tim/Desktop/receipts/orders/order-31.pdf','',1),(32,2,1,'2009-07-07 15:24:23','2009-07-07 15:35:39','/Users/tim/Desktop/receipts/orders/order-32.pdf','',1),(33,1,1,'2009-07-07 21:29:31','2009-07-21 18:39:15','/Users/tim/Desktop/receipts/orders/order-33.pdf','',1),(34,1,1,'2009-07-08 03:59:29','2009-07-21 18:35:56','/Users/tim/Desktop/receipts/orders/order-34.pdf','',1),(35,1,1,'2009-07-08 04:06:59','2009-07-21 18:23:30','/Users/tim/Desktop/receipts/orders/order-35.pdf','',1),(36,1,1,'2009-07-08 04:41:39','2009-07-21 18:11:31','/Users/tim/Desktop/receipts/orders/order-36.pdf','',1),(37,2,1,'2009-07-08 21:53:09','2009-07-21 18:36:48','/Users/tim/Desktop/receipts/orders/order-37.pdf','',2),(38,3,1,'2009-07-08 21:55:37','2009-07-08 21:59:15','/Users/tim/Desktop/receipts/orders/order-38.pdf','',2),(39,3,1,'2009-07-08 21:56:40','2009-07-21 18:33:11','/Users/tim/Desktop/receipts/orders/order-39.pdf','',2);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `amount` float NOT NULL,
  `tax` float NOT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `payment_method` smallint(6) NOT NULL,
  `check_num` varchar(16) DEFAULT NULL,
  `payment_receipt` varchar(256) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (15,14,15.74,1.37,'2009-07-06 03:23:35','2009-07-06 03:23:35',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-14.pdf','2009-07-06 20:00:37',1),(16,16,23.97,2.08,'2009-07-06 19:03:07','2009-07-06 19:03:07',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-16.pdf','2009-07-06 20:00:37',1),(17,20,31.52,2.73,'2009-07-06 22:44:46','2009-07-06 22:44:46',4,NULL,'/Users/tim/Desktop/receipts/payments/payment-20.pdf','2009-07-06 20:00:37',1),(18,26,47.94,4.16,'2009-07-06 23:22:04','2009-07-06 23:22:05',4,NULL,'/Users/tim/Desktop/receipts/payments/payment-26.pdf','2009-07-06 20:00:37',1),(19,25,35.02,3.04,'2009-07-06 23:22:39','2009-07-06 23:22:39',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-25.pdf','2009-07-06 20:00:37',1),(20,19,31.52,2.73,'2009-07-06 23:23:22','2009-07-06 23:23:22',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-19.pdf','2009-07-06 20:00:37',1),(21,31,31.52,2.73,'2009-07-07 02:50:27','2009-07-07 02:50:27',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-31.pdf','2009-07-06 20:00:37',1),(22,29,61.27,5.32,'2009-07-07 03:44:37','2009-07-07 03:44:37',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-29.pdf','2009-07-07 03:44:37',1),(23,21,21.9,1.9,'2009-07-07 03:48:51','2009-07-07 03:48:51',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-21.pdf','2009-07-07 03:48:51',1),(24,24,4.36,0.38,'2009-07-07 03:50:51','2009-07-07 03:50:51',1,NULL,'/Users/tim/Desktop/receipts/payments/payment-24.pdf','2009-07-07 03:50:51',1),(25,32,41.37,3.59,'2009-07-07 15:35:39','2009-07-07 15:35:39',2,'125','/Users/tim/Desktop/receipts/payments/payment-32.pdf','2009-07-07 15:35:38',1),(26,30,47.94,4.16,'2009-07-07 15:36:52','2009-07-07 15:36:52',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-30.pdf','2009-07-07 15:36:52',1),(27,28,47.94,4.16,'2009-07-08 04:33:29','2009-07-08 04:33:29',1,NULL,'/Users/tim/Desktop/receipts/payments/payment-28.pdf','2009-07-08 04:33:29',1),(28,38,37.23,3.23,'2009-07-08 21:59:14','2009-07-08 21:59:15',1,NULL,'/Users/tim/Desktop/receipts/payments/payment-38.pdf','2009-07-08 21:59:14',2),(29,36,132.5,11.5,'2009-07-21 18:11:31','2009-07-21 18:11:31',1,NULL,'/Users/tim/Desktop/receipts/payments/payment-36.pdf','2009-07-21 18:11:31',1),(30,35,60.23,5.22,'2009-07-21 18:23:30','2009-07-21 18:23:30',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-35.pdf','2009-07-21 18:23:30',1),(31,39,36.13,3.14,'2009-07-21 18:33:10','2009-07-21 18:33:11',2,'122','/Users/tim/Desktop/receipts/payments/payment-39.pdf','2009-07-21 18:33:10',1),(32,34,3.29,0.29,'2009-07-21 18:35:55','2009-07-21 18:35:56',1,NULL,'/Users/tim/Desktop/receipts/payments/payment-34.pdf','2009-07-21 18:35:55',1),(33,18,17.51,1.52,'2009-07-21 18:36:25','2009-07-21 18:36:25',2,'22','/Users/tim/Desktop/receipts/payments/payment-18.pdf','2009-07-21 18:36:25',1),(34,37,289.08,25.08,'2009-07-21 18:36:48','2009-07-21 18:36:48',3,NULL,'/Users/tim/Desktop/receipts/payments/payment-37.pdf','2009-07-21 18:36:48',1),(35,17,14.22,1.23,'2009-07-21 18:38:11','2009-07-21 18:38:11',4,NULL,'/Users/tim/Desktop/receipts/payments/payment-17.pdf','2009-07-21 18:38:11',1),(36,22,2.18,0.19,'2009-07-21 18:38:46','2009-07-21 18:38:46',2,'','/Users/tim/Desktop/receipts/payments/payment-22.pdf','2009-07-21 18:38:46',1),(37,33,21.9,1.9,'2009-07-21 18:39:15','2009-07-21 18:39:15',1,NULL,'/Users/tim/Desktop/receipts/payments/payment-33.pdf','2009-07-21 18:39:15',1),(38,23,26.15,2.27,'2009-07-21 18:39:28','2009-07-21 18:39:28',4,NULL,'/Users/tim/Desktop/receipts/payments/payment-23.pdf','2009-07-21 18:39:28',1);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('1');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (1,'BAh7BzoQX2NzcmZfdG9rZW4iMWo2S3VNK0dOdFFnRUdhRUJhcktMTFNoY1pMRjJmMVFoZ1ArSnlxR2hkZGs9Og9zZXNzaW9uX2lkIiVkNzhkNDYyNjY1MWUwM2ZlNGUwMDE0NTMzMjEzNmZiOQ==--01783bf1c86c9d0ada9fe94425de8d32e454f951','BAh7CjoQX2NzcmZfdG9rZW4iMW5IQ3lxNVVmZUtNUlNkMzBqMlhDUmE4YWtQ\nSHVnMVl2dUpuK0NvSld2bDA9Og1pc19hZG1pblQ6DWFkbWluX2lkaQY6DWlz\nX2xvY2FsIgpmYWxzZToPYWRtaW5fdXNlciIJYW5uZQ==\n','2009-07-21 18:02:46','2009-07-21 21:15:15'),(2,'1c102b98a581a6f8d258c78a99fafb97','BAh7BzoQX2NzcmZfdG9rZW4iMTdxQ1dTVmZUNDl3NUk1UThqVjI5Uk8xOWhj\nYjZRbkxYRFl1SElrc2g5aEE9Og1pc19sb2NhbCIKZmFsc2U=\n','2009-07-21 21:17:01','2009-07-21 21:17:10');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
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
  `delivery_customer` tinyint(1) DEFAULT '0',
  `howd_you_hear` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email_address` (`email_address`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'tim','swetonic','swetonic@gmail.com',NULL,'420 NW 45th Street','','Seattle','WA','98107','206-390-9719','','10-23-1967','anne','very clean','dry and clean','dirty',0,NULL),(2,'tim','swetonic','swetonic2@gmail.com',NULL,'420 NW 45th Street','','Seattle','WA','98107','206-706-9337','','10-23-1967','anne','very clean','dry and clean','dirty',0,'internet'),(3,'joe','delivery ','',NULL,'','','','','','206-754-3333','','','','','','',1,'the stranger');
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

-- Dump completed on 2009-07-21 22:04:51

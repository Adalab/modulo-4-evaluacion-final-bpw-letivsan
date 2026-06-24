CREATE DATABASE  IF NOT EXISTS `leagueoflegends` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `leagueoflegends`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: leagueoflegends
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abilities`
--

DROP TABLE IF EXISTS `abilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abilities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `champion_id` int NOT NULL,
  `ability_key` enum('Passive','Q','W','E','R') NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `fk_abilites_champions_idx` (`champion_id`),
  CONSTRAINT `fk_abilites_champions` FOREIGN KEY (`champion_id`) REFERENCES `champions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abilities`
--

LOCK TABLES `abilities` WRITE;
/*!40000 ALTER TABLE `abilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `abilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `champion_classes`
--

DROP TABLE IF EXISTS `champion_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `champion_classes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `champion_classes`
--

LOCK TABLES `champion_classes` WRITE;
/*!40000 ALTER TABLE `champion_classes` DISABLE KEYS */;
/*!40000 ALTER TABLE `champion_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `champion_positions`
--

DROP TABLE IF EXISTS `champion_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `champion_positions` (
  `champion_id` int NOT NULL,
  `lane_id` int NOT NULL,
  `is_primary` tinyint DEFAULT NULL,
  PRIMARY KEY (`champion_id`,`lane_id`),
  KEY `fk_champions_has_lanes_lanes1_idx` (`lane_id`),
  KEY `fk_champions_has_lanes_champions1_idx` (`champion_id`),
  CONSTRAINT `fk_champions_has_lanes_champions1` FOREIGN KEY (`champion_id`) REFERENCES `champions` (`id`),
  CONSTRAINT `fk_champions_has_lanes_lanes1` FOREIGN KEY (`lane_id`) REFERENCES `lanes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `champion_positions`
--

LOCK TABLES `champion_positions` WRITE;
/*!40000 ALTER TABLE `champion_positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `champion_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `champions`
--

DROP TABLE IF EXISTS `champions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `champions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `riot_id` varchar(100) NOT NULL,
  `riot_key` int NOT NULL,
  `name` varchar(64) NOT NULL,
  `title` varchar(100) NOT NULL,
  `region_id` int DEFAULT NULL,
  `resource` varchar(45) DEFAULT NULL,
  `attack` int DEFAULT NULL,
  `defense` int DEFAULT NULL,
  `magic` int DEFAULT NULL,
  `difficulty` int DEFAULT NULL,
  `lore_summary` text,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `riot_id_UNIQUE` (`riot_id`),
  UNIQUE KEY `riot_key_UNIQUE` (`riot_key`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `fk_champions_regions_idx` (`region_id`),
  CONSTRAINT `fk_champions_regions` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `champions`
--

LOCK TABLES `champions` WRITE;
/*!40000 ALTER TABLE `champions` DISABLE KEYS */;
/*!40000 ALTER TABLE `champions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lanes`
--

DROP TABLE IF EXISTS `lanes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lanes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lanes`
--

LOCK TABLES `lanes` WRITE;
/*!40000 ALTER TABLE `lanes` DISABLE KEYS */;
/*!40000 ALTER TABLE `lanes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 23:19:00

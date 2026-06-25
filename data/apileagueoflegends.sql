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
  KEY `fk_abilities_champions_idx` (`champion_id`),
  CONSTRAINT `fk_abilities_champions` FOREIGN KEY (`champion_id`) REFERENCES `champions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abilities`
--

LOCK TABLES `abilities` WRITE;
/*!40000 ALTER TABLE `abilities` DISABLE KEYS */;
INSERT INTO `abilities` VALUES (1,1,'Passive','Illumination','Lux marks enemies hit by her damaging spells and can trigger the mark with her next attack.'),(2,1,'Q','Light Binding','Lux fires light that roots and damages enemy units.'),(3,1,'W','Prismatic Barrier','Lux throws her wand to shield herself and allies it touches.'),(4,1,'E','Lucent Singularity','Lux creates an area of light that slows enemies and can be detonated for damage.'),(5,1,'R','Final Spark','Lux fires a long-range beam of light that damages enemies in its path.'),(6,2,'Passive','Perseverance','Garen regenerates health when he has not recently taken damage.'),(7,2,'Q','Decisive Strike','Garen gains movement speed and empowers his next attack to silence the target.'),(8,2,'W','Courage','Garen gains defensive stats and can activate the ability for protection and tenacity.'),(9,2,'E','Judgment','Garen spins with his sword, dealing damage to nearby enemies.'),(10,2,'R','Demacian Justice','Garen calls on Demacian power to execute an enemy champion.'),(11,3,'Passive','Essence Theft','Ahri heals after killing enough minions or monsters, and heals more after champion takedowns.'),(12,3,'Q','Orb of Deception','Ahri sends out and recalls her orb, dealing magic damage outward and true damage on return.'),(13,3,'W','Fox-Fire','Ahri gains movement speed and releases fox-fires that attack nearby enemies.'),(14,3,'E','Charm','Ahri charms and damages an enemy, making it move harmlessly toward her.'),(15,3,'R','Spirit Rush','Ahri dashes and fires essence bolts, with additional recasts after takedowns.'),(16,4,'Passive','Way of the Wanderer','Yasuo gains increased critical strike chance and builds a shield while moving.'),(17,4,'Q','Steel Tempest','Yasuo thrusts forward and can create a whirlwind after stacking the ability.'),(18,4,'W','Wind Wall','Yasuo creates a moving wall that blocks enemy projectiles.'),(19,4,'E','Sweeping Blade','Yasuo dashes through a target enemy and deals damage.'),(20,4,'R','Last Breath','Yasuo blinks to an airborne enemy champion and keeps airborne enemies suspended.'),(21,5,'Passive','Hemorrhage','Darius causes enemies to bleed with attacks and damaging abilities.'),(22,5,'Q','Decimate','Darius swings his axe in a circle, damaging enemies and healing from key hits.'),(23,5,'W','Crippling Strike','Darius empowers his next attack to damage and slow the enemy.'),(24,5,'E','Apprehend','Darius pulls enemies toward him with his axe.'),(25,5,'R','Noxian Guillotine','Darius leaps to strike an enemy champion with true damage.'),(26,6,'Passive','Get Excited!','Jinx gains movement speed and attack speed after participating in certain takedowns.'),(27,6,'Q','Switcheroo!','Jinx swaps between her minigun and rocket launcher basic attacks.'),(28,6,'W','Zap!','Jinx fires a shock blast that damages, slows and reveals the first enemy hit.'),(29,6,'E','Flame Chompers!','Jinx throws snare grenades that root enemy champions who step on them.'),(30,6,'R','Super Mega Death Rocket!','Jinx fires a long-range rocket that explodes when it hits an enemy champion.');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `champion_classes`
--

LOCK TABLES `champion_classes` WRITE;
/*!40000 ALTER TABLE `champion_classes` DISABLE KEYS */;
INSERT INTO `champion_classes` VALUES (1,'Assassin','Champion focused on mobility and burst damage.'),(2,'Fighter','Champion with a balance between damage and durability.'),(3,'Mage','Champion focused on magic damage and ability-based combat.'),(4,'Marksman','Champion focused on ranged basic attacks and sustained damage.'),(5,'Support','Champion focused on utility, protection, healing or crowd control.'),(6,'Tank','Champion focused on durability, initiation and absorbing damage.');
/*!40000 ALTER TABLE `champion_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `champion_classifications`
--

DROP TABLE IF EXISTS `champion_classifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `champion_classifications` (
  `champion_id` int NOT NULL,
  `class_id` int NOT NULL,
  `is_primary` tinyint DEFAULT NULL,
  PRIMARY KEY (`champion_id`,`class_id`),
  KEY `fk_champions_has_champion_classes_champion_classes1_idx` (`class_id`),
  KEY `fk_champions_has_champion_classes_champions1_idx` (`champion_id`),
  CONSTRAINT `fk_champions_has_champion_classes_champion_classes1` FOREIGN KEY (`class_id`) REFERENCES `champion_classes` (`id`),
  CONSTRAINT `fk_champions_has_champion_classes_champions1` FOREIGN KEY (`champion_id`) REFERENCES `champions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `champion_classifications`
--

LOCK TABLES `champion_classifications` WRITE;
/*!40000 ALTER TABLE `champion_classifications` DISABLE KEYS */;
INSERT INTO `champion_classifications` VALUES (1,3,1),(1,5,0),(2,2,1),(2,6,0),(3,1,0),(3,3,1),(4,1,0),(4,2,1),(5,2,1),(5,6,0),(6,4,1);
/*!40000 ALTER TABLE `champion_classifications` ENABLE KEYS */;
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
INSERT INTO `champion_positions` VALUES (1,3,1),(1,5,0),(2,1,1),(3,3,1),(4,1,0),(4,3,1),(5,1,1),(6,4,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `champions`
--

LOCK TABLES `champions` WRITE;
/*!40000 ALTER TABLE `champions` DISABLE KEYS */;
INSERT INTO `champions` VALUES (1,'Lux',99,'Lux','the Lady of Luminosity',1,'Mana',2,4,9,5,'Luxanna Crownguard is a Demacian mage who can bend light and hides her power in a kingdom suspicious of magic.','https://ddragon.leagueoflegends.com/cdn/16.13.1/img/champion/Lux.png','2026-06-25 09:41:21','2026-06-25 09:41:21'),(2,'Garen',86,'Garen','The Might of Demacia',1,'None',7,7,1,5,'Garen is a proud warrior of the Dauntless Vanguard and a defender of Demacia.','https://ddragon.leagueoflegends.com/cdn/16.13.1/img/champion/Garen.png','2026-06-25 09:41:21','2026-06-25 09:41:21'),(3,'Ahri',103,'Ahri','the Nine-Tailed Fox',2,'Mana',3,4,8,5,'Ahri is a fox-like vastaya connected to the spirit realm who can manipulate emotions and essence.','https://ddragon.leagueoflegends.com/cdn/16.13.1/img/champion/Ahri.png','2026-06-25 09:41:21','2026-06-25 09:41:21'),(4,'Yasuo',157,'Yasuo','the Unforgiven',2,'Flow',8,4,4,10,'Yasuo is an Ionian swordsman who wields the wind and wanders his homeland after a tragic past.','https://ddragon.leagueoflegends.com/cdn/16.13.1/img/champion/Yasuo.png','2026-06-25 09:41:21','2026-06-25 09:41:21'),(5,'Darius',122,'Darius','the Hand of Noxus',3,'Mana',9,5,1,2,'Darius is one of Noxus most feared commanders and a symbol of Noxian strength.','https://ddragon.leagueoflegends.com/cdn/16.13.1/img/champion/Darius.png','2026-06-25 09:41:21','2026-06-25 09:41:21'),(6,'Jinx',222,'Jinx','the Loose Cannon',4,'Mana',9,2,4,6,'Jinx is an impulsive criminal from Zaun who brings chaos with her arsenal of weapons.','https://ddragon.leagueoflegends.com/cdn/16.13.1/img/champion/Jinx.png','2026-06-25 09:41:21','2026-06-25 09:41:21');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lanes`
--

LOCK TABLES `lanes` WRITE;
/*!40000 ALTER TABLE `lanes` DISABLE KEYS */;
INSERT INTO `lanes` VALUES (1,'Top','Solo lane usually played by fighters, tanks or duelists.'),(2,'Jungle','Map role focused on neutral monsters, objectives and ganks.'),(3,'Mid','Central lane usually played by mages, assassins or skirmishers.'),(4,'Bot','Duo lane usually played by marksmen with a support.'),(5,'Support','Role focused on vision, protection, crowd control and helping allies.');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
INSERT INTO `regions` VALUES (1,'Demacia','A proud kingdom associated with order, justice and suspicion toward magic.'),(2,'Ionia','A land connected with spiritual magic, balance and ancient traditions.'),(3,'Noxus','A powerful expansionist empire that values strength and ambition.'),(4,'Zaun','An undercity known for chemtech, invention, crime and social conflict.');
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

-- Dump completed on 2026-06-25 11:54:22

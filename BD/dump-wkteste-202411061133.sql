-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: wkteste
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente_cli`
--

DROP TABLE IF EXISTS `cliente_cli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente_cli` (
  `CLI_CDCLIENTE` int NOT NULL AUTO_INCREMENT,
  `CLI_NMCLIENTE` varchar(255) NOT NULL,
  `CLI_DSCIDADE` varchar(255) NOT NULL,
  `CLI_DSUF` char(2) NOT NULL,
  `CLI_DTCADASTRO` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CLI_USCADASTRO` varchar(255) NOT NULL,
  `CLI_DTALTERACAO` timestamp NULL DEFAULT NULL,
  `CLI_USALTERACAO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CLI_CDCLIENTE`),
  UNIQUE KEY `UCK_CDCLIENTE` (`CLI_CDCLIENTE`),
  KEY `IDX_NMCLIENTE` (`CLI_NMCLIENTE`),
  KEY `IDX_DSCIDADE` (`CLI_DSCIDADE`),
  KEY `IDX_DSUF` (`CLI_DSUF`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente_cli`
--

LOCK TABLES `cliente_cli` WRITE;
/*!40000 ALTER TABLE `cliente_cli` DISABLE KEYS */;
INSERT INTO `cliente_cli` VALUES (1,'GERALDO GENUINO','SÃO PAULO','SP','2024-11-04 02:29:51','root',NULL,NULL),(2,'JOSUÉ CONÇALVES','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(3,'MARIA DA PIEDADE','UBERLANDIA','MG','2024-11-04 02:35:39','root',NULL,NULL),(4,'JUVENAL JUVENCIO','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(5,'VALENTINA CORAJOSA','RIO DE JANEIRO','RJ','2024-11-04 02:35:39','root',NULL,NULL),(6,'JOÃO MARIA','BLUMENAU','SC','2024-11-04 02:35:39','root',NULL,NULL),(7,'MARIA JOÃO','BLUMENAU','SC','2024-11-04 02:35:39','root',NULL,NULL),(8,'EVERALDO EVARISTO','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(9,'RONIELSO RUSTICO','BELÉM','PR','2024-11-04 02:35:39','root',NULL,NULL),(10,'YURI ALBERTO','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(11,'FAGNER AÇOUGUEIRO','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(12,'XAROPINHO DORFLEX','CURITIBA','PA','2024-11-04 02:35:39','root',NULL,NULL),(13,'RENATO ARAGÃO','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(14,'RAPHAEL VEIGA','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(15,'ANITA CALDERON','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(16,'EVITTA PERON','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(17,'ALEXANDRE COLUNAS','GOIÂNIA','GO','2024-11-04 02:35:39','root',NULL,NULL),(18,'RONALDO CAIADO','GOIANIA','GO','2024-11-04 02:35:39','root',NULL,NULL),(19,'MAIKE HOT-DOG','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(20,'CONSTANCE NUÑES','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL),(21,'ROSANGELA FLORES','SÃO PAULO','SP','2024-11-04 02:35:39','root',NULL,NULL);
/*!40000 ALTER TABLE `cliente_cli` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `INS_CLIENTE_CLI` BEFORE INSERT ON `cliente_cli` FOR EACH ROW BEGIN
    -- Preenche CLI_DTCADASTRO com a data e hora atual
    SET NEW.CLI_DTCADASTRO = NOW();
    
    -- Preenche CLI_USCADASTRO com o usuário da variável de sessão
    SET NEW.CLI_USCADASTRO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `UPD_CLIENTE_CLI` BEFORE UPDATE ON `cliente_cli` FOR EACH ROW BEGIN
    -- Preenche CLI_DTALTERACAO com a data e hora atual
    SET NEW.CLI_DTALTERACAO = NOW();
    
    -- Preenche CLI_USALTERACAO com o usuário da variável de sessão
    SET NEW.CLI_USALTERACAO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `itempedido_ite`
--

DROP TABLE IF EXISTS `itempedido_ite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itempedido_ite` (
  `ITE_SEQ` int NOT NULL AUTO_INCREMENT,
  `PED_NRPEDIDO` int NOT NULL,
  `PRO_CDPRODUTO` int NOT NULL,
  `ITE_QTDE` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `ITE_VLUNITARIO` decimal(15,4) NOT NULL,
  `ITE_VLTOTAL` decimal(15,4) GENERATED ALWAYS AS ((`ITE_QTDE` * `ITE_VLUNITARIO`)) STORED,
  `ITE_DTCADASTRO` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ITE_USCADASTRO` varchar(255) NOT NULL,
  `ITE_DTALTERACAO` timestamp NULL DEFAULT NULL,
  `ITE_USALTERACAO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ITE_SEQ`,`PED_NRPEDIDO`),
  UNIQUE KEY `UCK_ITE_SEQ` (`ITE_SEQ`,`PED_NRPEDIDO`),
  KEY `IDX_ITEMPEDIDO_PED_NRPEDIDO` (`PED_NRPEDIDO`),
  KEY `IDX_ITEMPEDIDO_PRO_CDPRODUTO` (`PRO_CDPRODUTO`),
  CONSTRAINT `FRK_ITEMPEDIDO_PEDIDO` FOREIGN KEY (`PED_NRPEDIDO`) REFERENCES `pedido_ped` (`PED_NRPEDIDO`),
  CONSTRAINT `FRK_ITEMPEDIDO_PRODUTO` FOREIGN KEY (`PRO_CDPRODUTO`) REFERENCES `produto_pro` (`PRO_CDPRODUTO`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itempedido_ite`
--

LOCK TABLES `itempedido_ite` WRITE;
/*!40000 ALTER TABLE `itempedido_ite` DISABLE KEYS */;
INSERT INTO `itempedido_ite` (`ITE_SEQ`, `PED_NRPEDIDO`, `PRO_CDPRODUTO`, `ITE_QTDE`, `ITE_VLUNITARIO`, `ITE_DTCADASTRO`, `ITE_USCADASTRO`, `ITE_DTALTERACAO`, `ITE_USALTERACAO`) VALUES (1,7,1,10.0000,15.5000,'2024-11-06 04:00:29','developer',NULL,NULL),(1,9,5,10.0000,6.5000,'2024-11-06 04:24:51','developer',NULL,NULL),(1,10,1,15.0000,17.5000,'2024-11-06 14:07:00','developer',NULL,NULL),(1,12,7,15.0000,19.9000,'2024-11-06 14:11:23','developer',NULL,NULL),(1,13,15,50.0000,1.5000,'2024-11-06 14:24:10','developer',NULL,NULL),(2,7,2,10.0000,60.0000,'2024-11-06 04:00:29','developer',NULL,NULL),(2,9,10,10.0000,4.9700,'2024-11-06 04:24:51','developer',NULL,NULL),(2,10,2,10.0000,62.9000,'2024-11-06 14:07:00','developer',NULL,NULL),(2,12,9,10.0000,75.9000,'2024-11-06 14:11:23','developer',NULL,NULL),(2,13,16,50.0000,1.5000,'2024-11-06 14:24:10','developer',NULL,NULL),(3,7,3,10.0000,65.0000,'2024-11-06 04:00:29','developer',NULL,NULL),(3,9,15,1000.0000,15.0000,'2024-11-06 04:24:51','developer',NULL,NULL),(3,13,17,50.0000,1.5000,'2024-11-06 14:24:10','developer',NULL,NULL),(4,7,4,50.0000,25.9000,'2024-11-06 04:00:29','developer',NULL,NULL);
/*!40000 ALTER TABLE `itempedido_ite` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `INS_ITEMPEDIDO_ITE` BEFORE INSERT ON `itempedido_ite` FOR EACH ROW BEGIN
    SET NEW.ITE_DTCADASTRO = NOW();
    SET NEW.ITE_USCADASTRO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `UPD_ITEMPEDIDO_ITE` BEFORE UPDATE ON `itempedido_ite` FOR EACH ROW BEGIN
    SET NEW.ITE_DTALTERACAO = NOW();
    SET NEW.ITE_USALTERACAO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedido_ped`
--

DROP TABLE IF EXISTS `pedido_ped`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_ped` (
  `PED_NRPEDIDO` int NOT NULL AUTO_INCREMENT,
  `PED_DTEMISSAO` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CLI_CDCLIENTE` int NOT NULL,
  `PED_VLTOTAL` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `PED_DTCADASTRO` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PED_USCADASTRO` varchar(255) NOT NULL,
  `PED_DTALTERACAO` timestamp NULL DEFAULT NULL,
  `PED_USALTERACAO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PED_NRPEDIDO`),
  UNIQUE KEY `UCK_NRPEDIDO` (`PED_NRPEDIDO`),
  KEY `IDX_PEDIDO_CLI_CDCLIENTE` (`CLI_CDCLIENTE`),
  KEY `IDX_PEDIDO_DTEMISSAO` (`PED_DTEMISSAO`),
  CONSTRAINT `FRK_PEDIDO_CLIENTE` FOREIGN KEY (`CLI_CDCLIENTE`) REFERENCES `cliente_cli` (`CLI_CDCLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_ped`
--

LOCK TABLES `pedido_ped` WRITE;
/*!40000 ALTER TABLE `pedido_ped` DISABLE KEYS */;
INSERT INTO `pedido_ped` VALUES (7,'2024-11-06 03:37:06',1,2700.0000,'2024-11-06 03:37:40','developer','2024-11-06 04:00:29','developer'),(9,'2024-11-06 04:24:14',5,15114.7000,'2024-11-06 04:24:51','developer',NULL,NULL),(10,'2024-11-06 14:05:56',5,891.5000,'2024-11-06 14:07:00','developer',NULL,NULL),(12,'2024-11-06 14:11:03',9,1057.5000,'2024-11-06 14:11:23','developer',NULL,NULL),(13,'2024-11-06 14:23:35',8,225.0000,'2024-11-06 14:24:10','developer',NULL,NULL);
/*!40000 ALTER TABLE `pedido_ped` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `INS_PEDIDO_PED` BEFORE INSERT ON `pedido_ped` FOR EACH ROW BEGIN
    SET NEW.PED_DTCADASTRO = NOW();
    SET NEW.PED_USCADASTRO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `UPD_PEDIDO_PED` BEFORE UPDATE ON `pedido_ped` FOR EACH ROW BEGIN
    SET NEW.PED_DTALTERACAO = NOW();
    SET NEW.PED_USALTERACAO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `produto_pro`
--

DROP TABLE IF EXISTS `produto_pro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_pro` (
  `PRO_CDPRODUTO` int NOT NULL AUTO_INCREMENT,
  `PRO_NMPRODUTO` varchar(255) NOT NULL,
  `PRO_VLUNITARIO` decimal(15,4) NOT NULL,
  `PRO_DTCADASTRO` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `PRO_USCADASTRO` varchar(255) NOT NULL,
  `PRO_DTALTERACAO` timestamp NULL DEFAULT NULL,
  `PRO_USALTERACAO` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PRO_CDPRODUTO`),
  UNIQUE KEY `UCK_CDPRODUTO` (`PRO_CDPRODUTO`),
  KEY `IDX_NMPRODUTO` (`PRO_NMPRODUTO`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_pro`
--

LOCK TABLES `produto_pro` WRITE;
/*!40000 ALTER TABLE `produto_pro` DISABLE KEYS */;
INSERT INTO `produto_pro` VALUES (1,'BANDEIROLA',15.5000,'2024-11-04 02:44:38','root',NULL,NULL),(2,'PILHA RECARREGÁVEL',50.9000,'2024-11-04 02:49:53','root',NULL,NULL),(3,'FONES BLUETOTH NÃO ORIGINAIS',19.9000,'2024-11-04 02:49:53','root',NULL,NULL),(4,'MOUSE SEM FIO',25.9000,'2024-11-04 02:49:53','root',NULL,NULL),(5,'FITA DUPLA FACE',5.9000,'2024-11-04 02:49:53','root',NULL,NULL),(6,'LIVRETO DE ANOTAÇÕES',9.9000,'2024-11-04 02:49:53','root',NULL,NULL),(7,'REFIL FICHARIO',19.9000,'2024-11-04 02:49:53','root',NULL,NULL),(8,'PENDRIVE 36GB',20.5000,'2024-11-04 02:49:53','root',NULL,NULL),(9,'CARTÃO DE MEMORIA 64GB',75.9000,'2024-11-04 02:49:53','root',NULL,NULL),(10,'ANEL DE BORRACHA',5.5000,'2024-11-04 02:49:53','root',NULL,NULL),(11,'ADAPTADOR USB-C',19.9000,'2024-11-04 02:49:53','root',NULL,NULL),(12,'CORDÃO PARA CRACHÁ',5.9000,'2024-11-04 02:49:53','root',NULL,NULL),(13,'DVD-RW DUPLA GRAVAÇÃO',5.9000,'2024-11-04 02:49:53','root',NULL,NULL),(14,'CANETA ESFEROGRÁFICA PRETA',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(15,'CANETA ESFEROGRÁFICA AZUL',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(16,'CANETA ESFEROGRÁFICA VERMELHA',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(17,'CANETA ESFEROGRÁFICA VERDE',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(18,'CANETA ESFEROGRÁFICA ROSA',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(19,'CANETA ESFEROGRÁFICA ROXA',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(20,'CANETA ESFEROGRÁFICA LARANJA',1.5000,'2024-11-04 02:49:53','root',NULL,NULL),(21,'CANETA MARCA TEXTO',3.5000,'2024-11-04 02:49:53','root',NULL,NULL);
/*!40000 ALTER TABLE `produto_pro` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `INS_PRODUTO_PRO` BEFORE INSERT ON `produto_pro` FOR EACH ROW BEGIN
    -- Preenche PRO_DTCADASTRO com a data e hora atual
    SET NEW.PRO_DTCADASTRO = NOW();
    
    -- Preenche PRO_USCADASTRO com o usuário da variável de sessão
    SET NEW.PRO_USCADASTRO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`developer`@`%`*/ /*!50003 TRIGGER `UPD_PRODUTO_PRO` BEFORE UPDATE ON `produto_pro` FOR EACH ROW BEGIN
    -- Preenche PRO_DTALTERACAO com a data e hora atual
    SET NEW.PRO_DTALTERACAO = NOW();
    
    -- Preenche PRO_USALTERACAO com o usuário da variável de sessão
    SET NEW.PRO_USALTERACAO = @USERNAME;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sequence_table`
--

DROP TABLE IF EXISTS `sequence_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequence_table` (
  `SEQ_NAME` varchar(50) NOT NULL,
  `SEQ_VALUE` int NOT NULL,
  PRIMARY KEY (`SEQ_NAME`),
  UNIQUE KEY `UCK_SEQ_NAME` (`SEQ_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequence_table`
--

LOCK TABLES `sequence_table` WRITE;
/*!40000 ALTER TABLE `sequence_table` DISABLE KEYS */;
INSERT INTO `sequence_table` VALUES ('CLIENTE_CLI_SEQ',21),('PEDIDO_PED_SEQ',13),('PRODUTO_PRO_SEQ',21);
/*!40000 ALTER TABLE `sequence_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'wkteste'
--

--
-- Dumping routines for database 'wkteste'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetNextSequenceValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`developer`@`%` PROCEDURE `GetNextSequenceValue`(IN pSEQ_NAME VARCHAR(30), OUT next_val INT)
BEGIN
    -- Atualiza e obtém o próximo valor da sequência
    UPDATE SEQUENCE_TABLE SET SEQ_VALUE = SEQ_VALUE + 1 WHERE SEQ_NAME = pSEQ_NAME;/*'CLIENTE_CLI_SEQ'*/
    SELECT SEQ_VALUE INTO next_val FROM SEQUENCE_TABLE WHERE SEQ_NAME = pSEQ_NAME;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-06 11:33:43

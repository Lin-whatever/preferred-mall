Warning: Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 5.6.24, for Win64 (x86_64)
--
-- Host: localhost    Database: eshop
-- ------------------------------------------------------
-- Server version	5.6.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(50) NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) NOT NULL COMMENT '收货人电话',
  `province` varchar(50) NOT NULL COMMENT '省',
  `city` varchar(50) NOT NULL COMMENT '市',
  `district` varchar(50) NOT NULL COMMENT '区',
  `detail_address` varchar(255) NOT NULL COMMENT '详细地址',
  `postal_code` varchar(10) DEFAULT NULL COMMENT '邮政编码',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否为默认地址，1是，0否',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1有效，0无效',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;

/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_info`
--

DROP TABLE IF EXISTS `admin_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_info` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_info`
--

LOCK TABLES `admin_info` WRITE;
/*!40000 ALTER TABLE `admin_info` DISABLE KEYS */;
INSERT INTO `admin_info` VALUES (1,'admin','123456');
/*!40000 ALTER TABLE `admin_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `product_code` varchar(16) NOT NULL COMMENT '商品编码',
  `quantity` int(11) NOT NULL DEFAULT '1' COMMENT '数量',
  `selected` tinyint(1) DEFAULT '1' COMMENT '是否选中，1选中，0未选中',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_code`),
  KEY `product_code` (`product_code`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_code`) REFERENCES `product_info` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;

/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `product_code` varchar(16) NOT NULL COMMENT '商品编码',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_code`),
  KEY `product_code` (`product_code`),
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`product_code`) REFERENCES `product_info` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='商品收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;

/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `functions`
--

DROP TABLE IF EXISTS `functions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `functions` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL COMMENT '功能菜单',
  `parentid` int(4) DEFAULT NULL,
  `url` varchar(50) DEFAULT NULL,
  `isleaf` bit(1) DEFAULT NULL,
  `nodeorder` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `functions`
--

LOCK TABLES `functions` WRITE;
/*!40000 ALTER TABLE `functions` DISABLE KEYS */;
INSERT INTO `functions` VALUES (1,'电子商城管理后台',0,NULL,'\0',0),(2,'商品管理',1,NULL,'\0',1),(3,'商品列表',2,'productlist.jsp','',1),(4,'商品类型列表',2,'typelist.jsp','',2),(5,'订单管理',1,NULL,'\0',2),(6,'查询订单',5,'searchorder.jsp','',1),(7,'创建订单',5,'createorder.jsp','',2),(8,'用户管理',1,NULL,'\0',3),(9,'用户列表',8,'userlist.jsp','',1),(11,'退出系统',1,NULL,'',1);
/*!40000 ALTER TABLE `functions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `idcard`
--

DROP TABLE IF EXISTS `idcard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `idcard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cno` varchar(18) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idcard`
--

LOCK TABLES `idcard` WRITE;
/*!40000 ALTER TABLE `idcard` DISABLE KEYS */;
INSERT INTO `idcard` VALUES (1,'320100197001010001'),(2,'320100197001010002'),(3,'320100197001010003');
/*!40000 ALTER TABLE `idcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_detail` (
  `id` int(4) NOT NULL AUTO_INCREMENT COMMENT '订单明细id',
  `oid` int(4) DEFAULT NULL COMMENT '订单id',
  `pid` int(4) DEFAULT NULL COMMENT '产品id',
  `num` int(4) DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `oid` (`oid`),
  KEY `idx_oid_pid` (`oid`,`pid`),
  CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`oid`) REFERENCES `order_info` (`id`),
  CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `product_info` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,1,1);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail_copy1`
--

DROP TABLE IF EXISTS `order_detail_copy1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_detail_copy1` (
  `id` int(4) NOT NULL AUTO_INCREMENT COMMENT '订单明细id',
  `oid` int(4) DEFAULT NULL COMMENT '订单id',
  `pid` int(4) DEFAULT NULL COMMENT '产品id',
  `num` int(4) DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `oid` (`oid`),
  KEY `idx_oid_pid` (`oid`,`pid`),
  CONSTRAINT `order_detail_copy1_ibfk_1` FOREIGN KEY (`oid`) REFERENCES `order_info` (`id`),
  CONSTRAINT `order_detail_copy1_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `product_info` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail_copy1`
--

LOCK TABLES `order_detail_copy1` WRITE;
/*!40000 ALTER TABLE `order_detail_copy1` DISABLE KEYS */;
INSERT INTO `order_detail_copy1` VALUES (1,1,1,1),(2,1,2,1),(3,2,4,1),(4,2,5,1),(5,2,8,1),(7,6,1,1),(8,7,2,1);
/*!40000 ALTER TABLE `order_detail_copy1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_info` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `order_code` varchar(100) DEFAULT NULL,
  `uid` int(4) DEFAULT NULL,
  `status` varchar(20) DEFAULT '未付款',
  `ordertime` datetime DEFAULT NULL,
  `orderprice` decimal(8,2) DEFAULT NULL,
  `orderCode` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orderCode` (`orderCode`),
  KEY `uid` (`uid`),
  KEY `idx_status` (`status`),
  KEY `idx_orderTime` (`ordertime`),
  CONSTRAINT `order_info_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user_info` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_info`
--

LOCK TABLES `order_info` WRITE;
/*!40000 ALTER TABLE `order_info` DISABLE KEYS */;
INSERT INTO `order_info` VALUES (1,1,'已完成','2025-01-01 10:00:00',6488);
/*!40000 ALTER TABLE `order_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` varchar(2) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`),
  CONSTRAINT `person_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `idcard` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'张三',22,'男',1),(2,'李四',21,'女',2),(3,'王五',22,'男',3);
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `powers`
--

DROP TABLE IF EXISTS `powers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powers` (
  `aid` int(4) NOT NULL,
  `fid` int(4) NOT NULL,
  PRIMARY KEY (`aid`,`fid`),
  KEY `fid` (`fid`),
  KEY `aid` (`aid`),
  CONSTRAINT `powers_ibfk_1` FOREIGN KEY (`aid`) REFERENCES `admin_info` (`id`),
  CONSTRAINT `powers_ibfk_2` FOREIGN KEY (`fid`) REFERENCES `functions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `powers`
--

LOCK TABLES `powers` WRITE;
/*!40000 ALTER TABLE `powers` DISABLE KEYS */;
INSERT INTO `powers` VALUES (1,1),(1,2),(2,2),(3,2),(1,3),(2,3),(1,4),(2,4),(3,4),(1,5),(1,6),(1,7),(1,8),(1,9),(3,9),(1,11),(3,11);
/*!40000 ALTER TABLE `powers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_info`
--

DROP TABLE IF EXISTS `product_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_info` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `code` varchar(16) DEFAULT NULL COMMENT '商品编号',
  `name` varchar(255) DEFAULT NULL COMMENT '商品名称',
  `tid` int(4) DEFAULT NULL COMMENT '商品类别',
  `brand` varchar(20) DEFAULT NULL COMMENT '商品品牌',
  `pic` varchar(255) DEFAULT NULL COMMENT '商品图片',
  `num` int(4) unsigned zerofill DEFAULT NULL COMMENT '商品库存',
  `price` decimal(10,0) unsigned zerofill DEFAULT NULL COMMENT '商品小图',
  `intro` longtext COMMENT '商品简介',
  `status` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`code`),
  KEY `tid` (`tid`),
  KEY `idx_name` (`name`),
  KEY `idx_brand` (`brand`),
  KEY `idx_status` (`status`),
  KEY `idx_price` (`price`),
  CONSTRAINT `product_info_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_info`
--

LOCK TABLES `product_info` WRITE;
/*!40000 ALTER TABLE `product_info` DISABLE KEYS */;
INSERT INTO `product_info` VALUES (1,'1378538','AppleMJVE2CH/A',1,'APPLE','AppleMJVE2CH.png',0997,0000006488,'Apple MacBook Air 13.3英寸笔记本电脑 银色(Core i5 处理器/4GB内存/128GB SSD闪存 MJVE2CH/A)',1),(2,'1309456','ThinkPadE450C(20EH0001CD)',1,'ThinkPad','2.png',0096,0000004199,'联想（ThinkPad） 轻薄系列E450C(20EH0001CD)14英寸笔记本电脑(i5-4210U 4G 500G 2G独显 Win8.1)',1),(3,'1999938','联想小新300经典版',1,'联想（Lenovo）','3.png',0099,0000004399,'联想（Lenovo）小新300经典版 14英寸超薄笔记本电脑（i7-6500U 4G 500G 2G独显 全高清屏 Win10）黑色',1),(4,'1466274','华硕FX50JX',1,'华硕（ASUS）','4.png',0100,0000004799,'华硕（ASUS）飞行堡垒FX50J 15.6英寸游戏笔记本电脑（i5-4200H 4G 7200转500G GTX950M 2G独显 全高清）',1),(5,'1981672','华硕FL5800',1,'华硕（ASUS）','5.png',0099,0000004999,'华硕（ASUS）FL5800 15.6英寸笔记本电脑 （i7-5500U 4G 128G SSD+1TB 2G独显 蓝牙 Win10 黑色）',1),(6,'1904696','联想G50-70M',1,'联想（Lenovo）','6.png',0012,0000003499,'联想（Lenovo）G50-70M 15.6英寸笔记本电脑（i5-4210U 4G 500G GT820M 2G独显 DVD刻录 Win8.1）金属黑',1),(7,'751624','美的BCD-206TM(E)',2,' 美的（Midea）','7.png',0100,0000001298,'美的(Midea) BCD-206TM(E) 206升 三门冰箱 节能保鲜 闪白银',1),(8,'977433','美的BCD-516WKM(E)',2,' 美的（Midea）','8.png',0100,0000003199,'美的(Midea) BCD-516WKM(E) 516升 对开门冰箱 风冷无霜 电脑控温 纤薄设计 节能静音 （泰坦银）',1),(9,'1143562','海尔BCD-216SDN',2,' 海尔（Haier）','9.png',0100,0000001699,'海尔（Haier）BCD-216SDN 216升 三门冰箱 电脑控温 中门 宽幅变温 大冷冻能力低能耗更省钱',1),(10,'1560207','海尔BCD-258WDPM',2,' 海尔（Haier）','10.png',0100,0000002699,'海尔（Haier）BCD-258WDPM 258升 风冷无霜三门冰箱 除菌 3D立体环绕风不风干 中门5℃~-18℃变温室',1),(11,'1721668','海信（Hisense）BCD-559WT/Q',2,' 海信（Hisense）','11.png',0100,0000003499,'海信（Hisense）BCD-559WT/Q 559升 金色电脑风冷节能对开门冰箱',1),(12,'823125','海信BCD-211TD/E',2,' 海信（Hisense）','12.png',0100,0000001699,'海信（Hisense） BCD-211TD/E 211升 电脑三门冰箱 （亮金刚）',1),(13,'100001','iPhone 15 Pro',5,'Apple','13.png',0049,0000007999,'最新款iPhone手机',1),(14,'100002','MacBook Air M2',1,'Apple','14.png',0029,0000008999,'轻薄便携笔记本电脑',1),(15,'100003','ThinkPad X1',1,'Lenovo','15.png',0025,0000012999,'商务办公笔记本电脑',1),(16,'100004','海尔智能冰箱',2,'Haier','16.png',0015,0000004599,'节能静音智能冰箱',1),(17,'100005','索尼4K电视',3,'Sony','17.png',0020,0000006999,'超高清4K智能电视',1);
/*!40000 ALTER TABLE `product_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `product_code` varchar(16) NOT NULL COMMENT '商品编码',
  `rating` int(11) NOT NULL DEFAULT '5' COMMENT '评分（1-5星）',
  `comment` text COMMENT '评价内容',
  `images` varchar(500) DEFAULT NULL COMMENT '评价图片，多个用逗号分隔',
  `is_anonymous` tinyint(1) DEFAULT '0' COMMENT '是否匿名，0不匿名，1匿名',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1显示，0隐藏',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_code` (`product_code`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_code`) REFERENCES `product_info` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='商品评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,'1466274',4,'性价比很高，推荐购买！',NULL,1,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(2,2,'1466274',5,'商品质量很好，非常满意！',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(3,4,'1466274',5,'性价比很高，推荐购买！',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(4,6,'1466274',1,'商品质量很好，非常满意！',NULL,1,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(5,26,'1466274',5,'性价比很高，推荐购买！',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(6,6,'1143562',5,'商品质量很好，非常满意！',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(7,27,'1143562',5,'物流很快，包装完好。',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(8,1,'100004',2,'物流很快，包装完好。',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(9,2,'100004',5,'物流很快，包装完好。',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(10,26,'100004',5,'商品质量很好，非常满意！',NULL,0,1,'2025-12-11 08:12:37','2025-12-11 08:12:37'),(11,25,'1378538',5,'不如鸡哥',NULL,0,1,'2026-07-18 17:18:55','2026-07-18 17:18:55'),(12,25,'1378538',5,'猛超鸡哥',NULL,1,1,'2026-07-18 17:19:23','2026-07-18 17:19:23');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type`
--

DROP TABLE IF EXISTS `type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `type` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type`
--

LOCK TABLES `type` WRITE;
/*!40000 ALTER TABLE `type` DISABLE KEYS */;
INSERT INTO `type` VALUES (1,'电脑'),(2,'冰箱'),(3,'电视机'),(4,'洗衣机'),(5,'数码相机'),(13,'书籍');
/*!40000 ALTER TABLE `type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_info` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `userName` varchar(16) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `realName` varchar(8) DEFAULT NULL,
  `sex` varchar(4) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `regDate` date DEFAULT NULL,
  `status` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_userName` (`userName`),
  KEY `idx_email` (`email`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info`
--

LOCK TABLES `user_info` WRITE;
/*!40000 ALTER TABLE `user_info` DISABLE KEYS */;
INSERT INTO `user_info` VALUES
(1,'john','123456','John','M','','demo@example.com','2025-01-01',1),
(2,'mary','123456','Mary','F','','mary@example.com','2025-01-02',1),
(3,'bob','123456','Bob','M','','bob@example.com','2025-01-03',1);
/*!40000 ALTER TABLE `user_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-18 23:03:36

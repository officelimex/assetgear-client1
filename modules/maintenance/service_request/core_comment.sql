/*
 Navicat Premium Data Transfer

 Source Server         : db_local
 Source Server Type    : MySQL
 Source Server Version : 50617
 Source Host           : localhost:3306
 Source Schema         : assetgear

 Target Server Type    : MySQL
 Target Server Version : 50617
 File Encoding         : 65001

 Date: 06/08/2019 12:23:12
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for core_comment
-- ----------------------------
DROP TABLE IF EXISTS `core_comment`;
CREATE TABLE `core_comment`  (
  `CommentId` int(11) NOT NULL AUTO_INCREMENT,
  `PK` int(11) NULL DEFAULT NULL,
  `Table` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `Comments` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `CommentByUserId` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`CommentId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

SET FOREIGN_KEY_CHECKS = 1;

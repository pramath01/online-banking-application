-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: bank3
-- ------------------------------------------------------
-- Server version	8.0.42


--
-- Table structure for table `authorization_completed`
--

DROP TABLE IF EXISTS `authorization_completed`;
CREATE TABLE `authorization_completed` (
  `auth_id` int NOT NULL AUTO_INCREMENT,
  `internal_userID` int DEFAULT NULL,
  `external_userID` int DEFAULT NULL,
  `auth_Type` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `authorization_pending`
--

DROP TABLE IF EXISTS `authorization_pending`;
CREATE TABLE `authorization_pending` (
  `auth_id` int NOT NULL AUTO_INCREMENT,
  `internal_userID` int DEFAULT NULL,
  `external_userID` int DEFAULT NULL,
  `auth_Type` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `authorized_merchants_users`
--

DROP TABLE IF EXISTS `authorized_merchants_users`;
CREATE TABLE `authorized_merchants_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `external_user_id` int NOT NULL COMMENT 'The ID of the customer doing the authorizing.',
  `merchant_id` int NOT NULL COMMENT 'The ID of the merchant being authorized.',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_merchant_authorization` (`external_user_id`,`merchant_id`),
  KEY `merchant_id` (`merchant_id`),
  CONSTRAINT `authorized_merchants_users_ibfk_1` FOREIGN KEY (`external_user_id`) REFERENCES `external_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `authorized_merchants_users_ibfk_2` FOREIGN KEY (`merchant_id`) REFERENCES `external_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `bank_accounts`
--

DROP TABLE IF EXISTS `bank_accounts`;
CREATE TABLE `bank_accounts` (
  `account_number` bigint NOT NULL AUTO_INCREMENT,
  `external_users_id` int NOT NULL,
  `account_type` varchar(50) NOT NULL COMMENT 'e.g., SAVINGS, CHECKINGS',
  `balance` decimal(19,4) NOT NULL DEFAULT '0.0000',
  `hold` decimal(19,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`account_number`),
  KEY `external_users_id` (`external_users_id`),
  CONSTRAINT `bank_accounts_ibfk_1` FOREIGN KEY (`external_users_id`) REFERENCES `external_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;





--
-- Table structure for table `credit_card_account_details`
--

DROP TABLE IF EXISTS `credit_card_account_details`;

CREATE TABLE `credit_card_account_details` (
  `credit_card_no` bigint NOT NULL,
  `account_number` bigint NOT NULL,
  `interest` decimal(10,2) DEFAULT NULL,
  `available_balance` decimal(19,4) DEFAULT NULL,
  `last_bill_amount` decimal(19,4) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `apr` decimal(5,2) DEFAULT NULL,
  `cycle_date` date DEFAULT NULL,
  `current_due_amt` decimal(19,4) DEFAULT NULL,
  `credit_limit` decimal(19,4) DEFAULT NULL,
  `payment` decimal(19,4) DEFAULT NULL,
  PRIMARY KEY (`credit_card_no`),
  KEY `account_number` (`account_number`),
  CONSTRAINT `credit_card_account_details_ibfk_1` FOREIGN KEY (`account_number`) REFERENCES `bank_accounts` (`account_number`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `external_log`
--

DROP TABLE IF EXISTS `external_log`;

CREATE TABLE `external_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `userid` int DEFAULT NULL,
  `activity` varchar(255) DEFAULT NULL,
  `details` text,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `external_request_completed`
--

DROP TABLE IF EXISTS `external_request_completed`;

CREATE TABLE `external_request_completed` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requesterid` int DEFAULT NULL,
  `approver` varchar(255) DEFAULT NULL,
  `request_type` varchar(100) DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT NULL,
  `timestamp_created` timestamp NULL DEFAULT NULL,
  `current_value` varchar(255) DEFAULT NULL,
  `requested_value` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `timestamp_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `external_request_pending`
--

DROP TABLE IF EXISTS `external_request_pending`;

CREATE TABLE `external_request_pending` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requesterid` int DEFAULT NULL,
  `approver` varchar(255) DEFAULT NULL COMMENT 'Can be an internal user ID or role name',
  `request_type` varchar(100) DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT 'PENDING',
  `timestamp_created` timestamp NULL DEFAULT NULL,
  `current_value` varchar(255) DEFAULT NULL,
  `requested_value` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `timestamp_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `requesterid` (`requesterid`),
  CONSTRAINT `external_request_pending_ibfk_1` FOREIGN KEY (`requesterid`) REFERENCES `external_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `external_users`
--

DROP TABLE IF EXISTS `external_users`;

CREATE TABLE `external_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `phone` bigint DEFAULT NULL,
  `date_of_birth` varchar(255) DEFAULT NULL,
  `ssn` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_external_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `internal_log`
--

DROP TABLE IF EXISTS `internal_log`;

CREATE TABLE `internal_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `userid` int DEFAULT NULL,
  `activity` varchar(255) DEFAULT NULL,
  `details` text,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `internal_request_completed`
--

DROP TABLE IF EXISTS `internal_request_completed`;

CREATE TABLE `internal_request_completed` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requesterid` int DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `request_type` varchar(100) DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT NULL COMMENT 'e.g., APPROVED, REJECTED',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `internal_request_pending`
--

DROP TABLE IF EXISTS `internal_request_pending`;

CREATE TABLE `internal_request_pending` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requesterid` int DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `request_type` varchar(100) DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT 'PENDING',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `requesterid` (`requesterid`),
  CONSTRAINT `internal_request_pending_ibfk_1` FOREIGN KEY (`requesterid`) REFERENCES `internal_user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `internal_user`
--

DROP TABLE IF EXISTS `internal_user`;

CREATE TABLE `internal_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `ssn` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_internal_user_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




--
-- Table structure for table `otp_table`
--

DROP TABLE IF EXISTS `otp_table`;

CREATE TABLE `otp_table` (
  `userEmail` varchar(255) NOT NULL,
  `otp` varchar(10) NOT NULL,
  `timestamp` timestamp NOT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`userEmail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `transaction_completed`
--

DROP TABLE IF EXISTS `transaction_completed`;

CREATE TABLE `transaction_completed` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payer_id` bigint DEFAULT NULL,
  `payee_id` bigint DEFAULT NULL,
  `amount` decimal(19,4) DEFAULT NULL,
  `hashvalue` varchar(255) DEFAULT NULL,
  `transaction_type` varchar(50) DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT NULL COMMENT 'e.g., COMPLETED, FAILED, REJECTED',
  `approver` varchar(255) DEFAULT NULL,
  `critical` tinyint(1) DEFAULT '0',
  `timestamp_created` timestamp NULL DEFAULT NULL,
  `timestamp_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



--
-- Table structure for table `transaction_pending`
--

DROP TABLE IF EXISTS `transaction_pending`;

CREATE TABLE `transaction_pending` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payer_id` bigint DEFAULT NULL,
  `payee_id` bigint DEFAULT NULL,
  `amount` decimal(19,4) DEFAULT NULL,
  `hashvalue` varchar(255) DEFAULT NULL,
  `transaction_type` varchar(50) DEFAULT NULL,
  `description` text,
  `status` varchar(50) DEFAULT NULL,
  `approver` varchar(255) DEFAULT NULL,
  `critical` tinyint(1) DEFAULT '0',
  `timestamp_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `timestamp_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- Table structure for table `user_attempts`
--

DROP TABLE IF EXISTS `user_attempts`;

CREATE TABLE `user_attempts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  `lastmodified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_attempts_username` (`username`),
  CONSTRAINT `user_attempts_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `user_pending`
--

DROP TABLE IF EXISTS `user_pending`;

CREATE TABLE `user_pending` (
  `id` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `userEmail` varchar(255) DEFAULT NULL,
  `userSsn` varchar(30) DEFAULT NULL,
  `userPassword` varchar(255) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `house` varchar(50) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `userPhonenumber` varchar(30) DEFAULT NULL,
  `timeStamp_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `username` varchar(255) NOT NULL COMMENT 'Corresponds to user email or unique ID',
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL COMMENT 'e.g., ROLE_USER, ROLE_ADMIN, ROLE_MANAGER',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `accountNonExpired` tinyint(1) NOT NULL DEFAULT '1',
  `accountNonLocked` tinyint(1) NOT NULL DEFAULT '1',
  `credentialsNonExpired` tinyint(1) NOT NULL DEFAULT '1',
  `otpNonLocked` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



/*---------------------------------------------------------------------------------------------------*/
/*insert commands to access*/
 



INSERT INTO `users` VALUES ('admin@bank.com','$2a$12$g79mbj6wBwWL9Y9hcpOMVu3vRdKTw2g9a2FJIbxp1OjSHQcQsQ4vW','ROLE_ADMIN',1,1,1,1,1);
INSERT INTO `users` VALUES ('manager@bank.com','$2a$12$g79mbj6wBwWL9Y9hcpOMVu3vRdKTw2g9a2FJIbxp1OjSHQcQsQ4vW','ROLE_MANAGER',1,1,1,1,1);  



INSERT INTO `internal_user` VALUES (1,'Alice Manager','manager@bank.com','Branch Manager','100 Bank Tower','New York','NY','USA','10001','1112223333','1980-05-15','999-01-0001');
INSERT INTO `internal_user` VALUES (2,'Bob Admin','admin@bank.com','System Administrator','200 Tech Park','New York','NY','USA','10002','1112224444','1985-11-20','999-02-0002');




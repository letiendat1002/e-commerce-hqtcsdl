-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema myecommerce
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema myecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `myecommerce` ;
USE `myecommerce` ;

-- -----------------------------------------------------
-- Table `myecommerce`.`UserAccount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `myecommerce`.`UserAccount` (
  `UserID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Phone` VARCHAR(255) NOT NULL,
  `Password` VARCHAR(255) NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `Gender` VARCHAR(255) NOT NULL,
  `Role` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `phone_UNIQUE` (`Phone` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myecommerce`.`UserAddress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `myecommerce`.`UserAddress` (
  `UserAddressID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` BIGINT UNSIGNED NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`UserAddressID`),
  INDEX `fk_UserAddress_UserAccount1_idx` (`UserID` ASC) VISIBLE,
  CONSTRAINT `fk_UserAddress_User1`
    FOREIGN KEY (`UserID`)
    REFERENCES `myecommerce`.`UserAccount` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myecommerce`.`UserOrder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `myecommerce`.`UserOrder` (
  `OrderID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserID` BIGINT UNSIGNED NOT NULL,
  `AdditionalPrice` BIGINT UNSIGNED NOT NULL,
  `PaymentType` VARCHAR(255) NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `DateOrder` DATE NOT NULL,
  `Status` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_UserOrder_UserAccount_idx` (`UserID` ASC) VISIBLE,
  CONSTRAINT `fk_UserOrder_UserAccount`
    FOREIGN KEY (`UserID`)
    REFERENCES `myecommerce`.`UserAccount` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myecommerce`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `myecommerce`.`Category` (
  `CategoryID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CategoryID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myecommerce`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `myecommerce`.`Product` (
  `ProductID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CategoryID` BIGINT UNSIGNED NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `UnitPrice` BIGINT NOT NULL,
  `Quantity` INT NOT NULL,
  `Discount` INT NULL,
  `Description` LONGTEXT NOT NULL,
  PRIMARY KEY (`ProductID`),
  INDEX `fk_Product_Category1_idx` (`CategoryID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Category1`
    FOREIGN KEY (`CategoryID`)
    REFERENCES `myecommerce`.`Category` (`CategoryID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `myecommerce`.`OrderDetail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `myecommerce`.`OrderDetail` (
  `OrderDetailID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `OrderID` BIGINT UNSIGNED NOT NULL,
  `ProductID` BIGINT UNSIGNED NOT NULL,
  `PurchasePrice` BIGINT UNSIGNED NOT NULL,
  `Quantity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`OrderDetailID`),
  INDEX `fk_OrderDetail_Order1_idx` (`OrderID` ASC) VISIBLE,
  INDEX `fk_OrderDetail_Product1_idx` (`ProductID` ASC) VISIBLE,
  CONSTRAINT `fk_OrderDetail_Order1`
    FOREIGN KEY (`OrderID`)
    REFERENCES `myecommerce`.`UserOrder` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_OrderDetail_Product1`
    FOREIGN KEY (`ProductID`)
    REFERENCES `myecommerce`.`Product` (`ProductID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

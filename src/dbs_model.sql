CREATE DATABASE myecommerce;
USE myecommerce;

-- -----------------------------------------------------
-- Table myecommerce.UserAccount
-- -----------------------------------------------------
CREATE TABLE UserAccount (
  UserID BIGINT NOT NULL IDENTITY(1,1),
  Phone VARCHAR(255) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  Name VARCHAR(255) NOT NULL,
  Gender VARCHAR(255) NOT NULL,
  Role VARCHAR(255) NOT NULL,
  PRIMARY KEY (UserID)
);

CREATE UNIQUE INDEX phone_UNIQUE
ON UserAccount (Phone);

-- -----------------------------------------------------
-- Table myecommerce.UserAddress
-- -----------------------------------------------------
CREATE TABLE UserAddress (
  UserAddressID BIGINT NOT NULL IDENTITY(1,1),
  UserID BIGINT NOT NULL,
  Address VARCHAR(255) NOT NULL,
  PRIMARY KEY (UserAddressID),
  CONSTRAINT fk_UserAddress_User1
    FOREIGN KEY (UserID)
    REFERENCES UserAccount (UserID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE INDEX fk_UserAddress_UserAccount1_idx
ON UserAddress (UserID);

-- -----------------------------------------------------
-- Table myecommerce.UserOrder
-- -----------------------------------------------------
CREATE TABLE UserOrder (
  OrderID BIGINT  NOT NULL IDENTITY(1,1),
  UserID BIGINT  NOT NULL,
  AdditionalPrice BIGINT  NOT NULL,
  PaymentType VARCHAR(255) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  DateOrder DATE NOT NULL,
  Status VARCHAR(255) NOT NULL,
  PRIMARY KEY (OrderID),
  CONSTRAINT fk_UserOrder_UserAccount
    FOREIGN KEY (UserID)
    REFERENCES UserAccount (UserID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE INDEX fk_UserOrder_UserAccount_idx
ON UserOrder (UserID);

-- -----------------------------------------------------
-- Table myecommerce.Category
-- -----------------------------------------------------
CREATE TABLE Category (
  CategoryID BIGINT  NOT NULL IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (CategoryID)
);


-- -----------------------------------------------------
-- Table myecommerce.Product
-- -----------------------------------------------------
CREATE TABLE Product (
  ProductID BIGINT  NOT NULL IDENTITY(1,1),
  CategoryID BIGINT  NOT NULL,
  Name VARCHAR(255) NOT NULL,
  UnitPrice BIGINT NOT NULL,
  Quantity INT NOT NULL,
  Discount INT NULL,
  Description NVARCHAR(MAX) NOT NULL,
  PRIMARY KEY (ProductID),
  CONSTRAINT fk_Product_Category1
    FOREIGN KEY (CategoryID)
    REFERENCES Category (CategoryID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE INDEX fk_Product_Category1_idx
ON Product (CategoryID);

-- -----------------------------------------------------
-- Table myecommerce.OrderDetail
-- -----------------------------------------------------
CREATE TABLE OrderDetail (
  OrderDetailID BIGINT  NOT NULL IDENTITY(1,1),
  OrderID BIGINT  NOT NULL,
  ProductID BIGINT  NOT NULL,
  PurchasePrice BIGINT  NOT NULL,
  Quantity INT  NOT NULL,
  PRIMARY KEY (OrderDetailID),
  CONSTRAINT fk_OrderDetail_Order1
    FOREIGN KEY (OrderID)
    REFERENCES UserOrder (OrderID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_OrderDetail_Product1
    FOREIGN KEY (ProductID)
    REFERENCES Product (ProductID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE INDEX fk_OrderDetail_Order1_idx
ON OrderDetail (OrderID);

CREATE INDEX fk_OrderDetail_Product1_idx
ON OrderDetail (ProductID);
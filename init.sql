-- 1. Таблица Genres (Жанры)
CREATE TABLE Genres (
    GenreID SERIAL PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL
);

-- 2. Таблица Suppliers (Поставщики)
CREATE TABLE Suppliers (
    SupplierID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Phone VARCHAR(20) CHECK (Phone ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),
    Email VARCHAR(100) UNIQUE NOT NULL CHECK (Email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- 3. Таблица Games (Настольные игры)
CREATE TABLE Games (
    GameID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    StockQuantity INT DEFAULT 0 CHECK (StockQuantity >= 0),
    MinPlayers INT CHECK (MinPlayers > 0),
    MaxPlayers INT CHECK (MaxPlayers >= MinPlayers),
    AgeRestriction INT CHECK (AgeRestriction >= 0),
    ReleaseYear INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE SET NULL
);

-- 4. Таблица GameGenres (Связь игр и жанров)
CREATE TABLE GameGenres (
    GameID INT,
    GenreID INT,
    PRIMARY KEY (GameID, GenreID),
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE,
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID) ON DELETE CASCADE
);

-- 5. Таблица Customers (Клиенты)
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL CHECK (Email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    Phone VARCHAR(20) CHECK (Phone ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),
    RegistrationDate DATE DEFAULT CURRENT_DATE
);

-- 6. Таблица Employees (Сотрудники)
CREATE TYPE employee_position AS ENUM ('Manager', 'Salesperson', 'Warehouse', 'Support');

CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position employee_position NOT NULL,
    HireDate DATE NOT NULL
);

-- 7. Таблица PaymentMethods (Способы оплаты)
CREATE TABLE PaymentMethods (
    PaymentMethodID SERIAL PRIMARY KEY,
    MethodName VARCHAR(50) NOT NULL
);

-- 8. Таблица DeliveryMethods (Способы доставки)
CREATE TABLE DeliveryMethods (
    DeliveryMethodID SERIAL PRIMARY KEY,
    MethodName VARCHAR(50) NOT NULL
);

-- 9. Таблица Orders (Заказы)
CREATE TYPE order_status AS ENUM ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled');

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL CHECK (TotalAmount >= 0),
    Status order_status NOT NULL,
    PaymentMethodID INT,
    DeliveryMethodID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE SET NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL,
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID) ON DELETE SET NULL,
    FOREIGN KEY (DeliveryMethodID) REFERENCES DeliveryMethods(DeliveryMethodID) ON DELETE SET NULL
);

-- 10. Таблица OrderDetails (Детали заказа)
CREATE TABLE OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    GameID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- 11. Таблица Reviews (Отзывы)
CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    GameID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- 12. Таблица Shipments (Поставки)
CREATE TABLE Shipments (
    ShipmentID SERIAL PRIMARY KEY,
    SupplierID INT NOT NULL,
    ShipmentDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL CHECK (TotalCost >= 0),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE
);

-- 13. Таблица ShipmentDetails (Детали поставки)
CREATE TABLE ShipmentDetails (
    ShipmentDetailID SERIAL PRIMARY KEY,
    ShipmentID INT,
    GameID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID) ON DELETE CASCADE,
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE
);

-- 14. Таблица Promotions (Акции)
CREATE TABLE Promotions (
    PromotionID SERIAL PRIMARY KEY,
    PromotionName VARCHAR(100) NOT NULL,
    DiscountPercent DECIMAL(5, 2) NOT NULL CHECK (DiscountPercent BETWEEN 0 AND 100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CHECK (EndDate > StartDate)
);

-- 15. Таблица GamePromotions (Связь игр и акций)
CREATE TABLE GamePromotions (
    GameID INT,
    PromotionID INT,
    PRIMARY KEY (GameID, PromotionID),
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE CASCADE,
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID) ON DELETE CASCADE
);

-- Индексы для таблицы Games
CREATE INDEX idx_games_title ON Games (Title);
CREATE INDEX idx_games_price ON Games (Price);
CREATE INDEX idx_games_stockquantity ON Games (StockQuantity);

-- Индексы для таблицы Customers
CREATE INDEX idx_customers_email ON Customers (Email);
CREATE INDEX idx_customers_registrationdate ON Customers (RegistrationDate);

-- Индексы для таблицы Orders
CREATE INDEX idx_orders_orderdate ON Orders (OrderDate);
CREATE INDEX idx_orders_totalamount ON Orders (TotalAmount);

-- Индексы для таблицы Reviews
CREATE INDEX idx_reviews_rating ON Reviews (Rating);

-- Индексы для таблицы Shipments
CREATE INDEX idx_shipments_shipmentdate ON Shipments (ShipmentDate);

-- Индексы для таблицы Promotions
CREATE INDEX idx_promotions_startdate ON Promotions (StartDate);
CREATE INDEX idx_promotions_enddate ON Promotions (EndDate);

-- Композитные индексы
CREATE INDEX idx_gamepromotions_composite ON GamePromotions (GameID, PromotionID);

-- 1. Создание функции для триггера
CREATE OR REPLACE FUNCTION check_game_price()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, что цена больше 0
    IF NEW.Price <= 0 THEN
        RAISE EXCEPTION 'Price must be greater than 0. Provided value: %', NEW.Price;
    END IF;

    -- Возвращаем новую запись, если всё в порядке
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Создание триггера для таблицы Games
CREATE TRIGGER trigger_check_game_price
BEFORE INSERT OR UPDATE ON Games
FOR EACH ROW
EXECUTE FUNCTION check_game_price();
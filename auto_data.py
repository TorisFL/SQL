import os
import random
from datetime import datetime, timedelta
from time import sleep
import psycopg2

# Функция подключения к базе данных
def connect_to_db():
    retries = 5
    while retries:
        try:
            conn = psycopg2.connect(
                host=os.environ.get('PG_HOST'),
                port=os.environ.get('PG_PORT'),
                dbname=os.environ.get('PG_DB'),
                user=os.environ.get('PG_USER'),
                password=os.environ.get('PG_PASSWORD')
            )
            print("Соединение с БД установлено")
            return conn
        except psycopg2.OperationalError:
            print("Попытка подключения к БД...")
            retries -= 1
            sleep(5)
    raise Exception("БД недоступна")

# Генерация случайного email
def random_email():
    domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com']
    username = ''.join(random.choices('abcdefghijklmnopqrstuvwxyz0123456789', k=8))
    domain = random.choice(domains)
    return f"{username}@{domain}"

# Генерация случайного телефона
def random_phone():
    part1 = str(random.randint(100, 999))
    part2 = str(random.randint(100, 999))
    part3 = str(random.randint(1000, 9999))
    return f"{part1}-{part2}-{part3}"

# Генерация случайной даты
def random_date(start_date, end_date):
    start_timestamp = int(start_date.timestamp())
    end_timestamp = int(end_date.timestamp())
    random_timestamp = random.randint(start_timestamp, end_timestamp)
    return datetime.fromtimestamp(random_timestamp).date()

# Заполнение таблицы Genres
def populate_genres(cur):
    for i in range(1, 11):
        cur.execute("INSERT INTO Genres (GenreName) VALUES (%s)", (f"Genre_{i}",))

# Заполнение таблицы Suppliers
def populate_suppliers(cur):
    for i in range(1, 6):
        cur.execute("""
            INSERT INTO Suppliers (CompanyName, ContactName, Phone, Email)
            VALUES (%s, %s, %s, %s)
        """, (f"Company_{i}", f"Contact_{i}", random_phone(), random_email()))

# Заполнение таблицы Games
def populate_games(cur):
    for i in range(1, 21):
        cur.execute("""
            INSERT INTO Games (Title, Description, Price, StockQuantity, MinPlayers, MaxPlayers, AgeRestriction, ReleaseYear, SupplierID)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            f"Game_{i}",
            f"Description for Game_{i}",
            round(random.uniform(10, 100), 2),
            random.randint(0, 50),
            random.randint(1, 4),
            random.randint(5, 8),
            random.randint(0, 18),
            random.randint(1970, 2023),
            random.randint(1, 5)
        ))

# Заполнение таблицы GameGenres
def populate_gamegenres(cur):
    existing_combinations = set()
    while len(existing_combinations) < 30:  # Генерируем ровно 30 уникальных записей
        game_id = random.randint(1, 20)
        genre_id = random.randint(1, 10)
        if (game_id, genre_id) not in existing_combinations:
            cur.execute("""
                INSERT INTO GameGenres (GameID, GenreID)
                VALUES (%s, %s)
            """, (game_id, genre_id))
            existing_combinations.add((game_id, genre_id))

# Заполнение таблицы Customers
def populate_customers(cur):
    for i in range(1, 16):
        cur.execute("""
            INSERT INTO Customers (FirstName, LastName, Email, Phone, RegistrationDate)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            f"First_{i}",
            f"Last_{i}",
            random_email(),
            random_phone(),
            random_date(datetime(2020, 1, 1), datetime(2023, 12, 31))
        ))

# Заполнение таблицы Employees
def populate_employees(cur):
    positions = ['Manager', 'Salesperson', 'Warehouse', 'Support']
    for i in range(1, 11):
        cur.execute("""
            INSERT INTO Employees (FirstName, LastName, Position, HireDate)
            VALUES (%s, %s, %s, %s)
        """, (
            f"Employee_First_{i}",
            f"Employee_Last_{i}",
            random.choice(positions),
            random_date(datetime(2015, 1, 1), datetime(2023, 12, 31))
        ))

# Заполнение таблицы PaymentMethods
def populate_paymentmethods(cur):
    for i in range(1, 6):
        cur.execute("INSERT INTO PaymentMethods (MethodName) VALUES (%s)", (f"PaymentMethod_{i}",))

# Заполнение таблицы DeliveryMethods
def populate_deliverymethods(cur):
    for i in range(1, 6):
        cur.execute("INSERT INTO DeliveryMethods (MethodName) VALUES (%s)", (f"DeliveryMethod_{i}",))

# Заполнение таблицы Orders
def populate_orders(cur):
    statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled']
    for i in range(1, 21):
        cur.execute("""
            INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, TotalAmount, Status, PaymentMethodID, DeliveryMethodID)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            random.randint(1, 15),
            random.randint(1, 10),
            random_date(datetime(2022, 1, 1), datetime(2023, 12, 31)),
            round(random.uniform(50, 500), 2),
            random.choice(statuses),
            random.randint(1, 5),
            random.randint(1, 5)
        ))

# Заполнение таблицы OrderDetails
def populate_orderdetails(cur):
    for _ in range(30):
        cur.execute("""
            INSERT INTO OrderDetails (OrderID, GameID, Quantity, UnitPrice)
            VALUES (%s, %s, %s, %s)
        """, (
            random.randint(1, 20),
            random.randint(1, 20),
            random.randint(1, 5),
            round(random.uniform(10, 100), 2)
        ))

# Заполнение таблицы Reviews
def populate_reviews(cur):
    for i in range(1, 26):
        cur.execute("""
            INSERT INTO Reviews (CustomerID, GameID, Rating, Comment, ReviewDate)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            random.randint(1, 15),
            random.randint(1, 20),
            random.randint(1, 5),
            f"Comment for Review_{i}",
            random_date(datetime(2022, 1, 1), datetime(2023, 12, 31))
        ))

# Заполнение таблицы Shipments
def populate_shipments(cur):
    for i in range(1, 11):
        cur.execute("""
            INSERT INTO Shipments (SupplierID, ShipmentDate, TotalCost)
            VALUES (%s, %s, %s)
        """, (
            random.randint(1, 5),
            random_date(datetime(2022, 1, 1), datetime(2023, 12, 31)),
            round(random.uniform(100, 1000), 2)
        ))

# Заполнение таблицы ShipmentDetails
def populate_shipmentdetails(cur):
    for _ in range(15):
        cur.execute("""
            INSERT INTO ShipmentDetails (ShipmentID, GameID, Quantity)
            VALUES (%s, %s, %s)
        """, (
            random.randint(1, 10),
            random.randint(1, 20),
            random.randint(1, 10)
        ))

# Заполнение таблицы Promotions
def populate_promotions(cur):
    for i in range(1, 6):
        cur.execute("""
            INSERT INTO Promotions (PromotionName, DiscountPercent, StartDate, EndDate)
            VALUES (%s, %s, %s, %s)
        """, (
            f"Promotion_{i}",
            random.randint(10, 50),
            random_date(datetime(2022, 1, 1), datetime(2023, 6, 30)),
            random_date(datetime(2023, 7, 1), datetime(2024, 12, 31))
        ))

# Заполнение таблицы GamePromotions
def populate_gamepromotions(cur):
    existing_combinations = set()
    while len(existing_combinations) < 10:  # Генерируем ровно 10 уникальных записей
        game_id = random.randint(1, 20)
        promotion_id = random.randint(1, 5)
        if (game_id, promotion_id) not in existing_combinations:
            cur.execute("""
                INSERT INTO GamePromotions (GameID, PromotionID)
                VALUES (%s, %s)
            """, (game_id, promotion_id))
            existing_combinations.add((game_id, promotion_id))

# Основная функция
if __name__ == "__main__":
    conn = None
    try:
        conn = connect_to_db()
        cur = conn.cursor()

        # Заполнение таблиц
        populate_genres(cur)
        populate_suppliers(cur)
        populate_games(cur)
        populate_gamegenres(cur)
        populate_customers(cur)
        populate_employees(cur)
        populate_paymentmethods(cur)
        populate_deliverymethods(cur)
        populate_orders(cur)
        populate_orderdetails(cur)
        populate_reviews(cur)
        populate_shipments(cur)
        populate_shipmentdetails(cur)
        populate_promotions(cur)
        populate_gamepromotions(cur)

        # Фиксируем изменения
        conn.commit()
        print("Данные успешно вставлены в базу данных.")
    except Exception as e:
        print(f"Произошла ошибка: {e}")
        if conn:
            conn.rollback()
    finally:
        if conn:
            cur.close()
            conn.close()
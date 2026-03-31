INSERT INTO Categories (category_name) 
VALUES ('Electronics'), ('Books'), ('Home Decor');

INSERT INTO Users (first_name, last_name, email) VALUES 
('Alice', 'Smith', 'alice@email.com'),
('Bob', 'Johnson', 'bob@email.com');

INSERT INTO Products (name, price, stock_quantity, category_id) VALUES 
('iPhone 15', 799.99, 50, 1),
('SQL Guide', 29.99, 100, 2),
('Desk Lamp', 15.50, 30, 3);

INSERT INTO Orders (user_id, total_amount) 
VALUES (1, 829.98);

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES 
(1, 1, 1, 799.99),
(1, 2, 1, 29.99);
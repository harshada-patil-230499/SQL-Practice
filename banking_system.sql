-- BANK TABLE
CREATE TABLE Banks (
    bank_id INT PRIMARY KEY,
    bank_name VARCHAR(50)
);

-- CUSTOMER TABLE
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15)
);

-- ACCOUNT TABLE
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    bank_id INT,
    account_type VARCHAR(20), -- Saving / Student
    balance DECIMAL(10,2),
    threshold_limit DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (bank_id) REFERENCES Banks(bank_id)
);

-- TRANSACTIONS TABLE (PASSBOOK)
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT,
    transaction_type VARCHAR(10), -- CREDIT / DEBIT
    amount DECIMAL(10,2),
    transaction_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- LOGIN TABLE
CREATE TABLE UserLogin (
    user_id INT PRIMARY KEY,
    customer_id INT,
    username VARCHAR(50),
    password VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Banks
INSERT INTO Banks VALUES (1, 'HDFC'), (2, 'SBI'), (3, 'PNB');

-- Customers
INSERT INTO Customers VALUES 
(1, 'Harshada', 'harshada@gmail.com', '9999999999');

-- Accounts
INSERT INTO Accounts VALUES 
(101, 1, 1, 'Saving', 50000, 1000);

-- Login
INSERT INTO UserLogin VALUES 
(1, 1, 'harshada123', 'pass123');

CREATE PROCEDURE GetAccountDetails
    @username VARCHAR(50),
    @password VARCHAR(50)
AS
BEGIN
    SELECT c.name, b.bank_name, a.account_type, a.balance, a.threshold_limit
    FROM UserLogin u
    JOIN Customers c ON u.customer_id = c.customer_id
    JOIN Accounts a ON c.customer_id = a.customer_id
    JOIN Banks b ON a.bank_id = b.bank_id
    WHERE u.username = @username AND u.password = @password;
END;

CREATE PROCEDURE DoTransaction
    @account_id INT,
    @type VARCHAR(10),
    @amount DECIMAL(10,2)
AS
BEGIN
    IF @type = 'DEBIT'
    BEGIN
        UPDATE Accounts
        SET balance = balance - @amount
        WHERE account_id = @account_id;
    END
    ELSE
    BEGIN
        UPDATE Accounts
        SET balance = balance + @amount
        WHERE account_id = @account_id;
    END

    INSERT INTO Transactions (account_id, transaction_type, amount)
    VALUES (@account_id, @type, @amount);
END;

CREATE FUNCTION GetBalance (@account_id INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @bal DECIMAL(10,2);

    SELECT @bal = balance FROM Accounts WHERE account_id = @account_id;

    RETURN @bal;
END;

CREATE TRIGGER trg_MinBalance
ON Accounts
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE balance < threshold_limit
    )
    BEGIN
        PRINT 'Balance below minimum limit!';
    END
END;

CREATE VIEW PassbookView AS
SELECT 
    a.account_id,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id;

CREATE INDEX idx_account_id
ON Transactions(account_id);

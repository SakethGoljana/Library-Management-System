-- Creating the database
CREATE DATABASE library_management;
USE library_management;

-- Creating tables with various constraints
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    publication_year INT,
    isbn VARCHAR(13) UNIQUE,
    available_copies INT DEFAULT 1,
    CHECK (publication_year > 1800 AND publication_year <= YEAR(CURDATE()))
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT (CURDATE()),
    status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    loan_date DATE DEFAULT (CURDATE()),
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Inserting sample data
INSERT INTO Books (title, author, publication_year, isbn, available_copies) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, '9780743273565', 3),
('To Kill a Mockingbird', 'Harper Lee', 1960, '9780446310789', 2),
('1984', 'George Orwell', 1949, '9780451524935', 4);

INSERT INTO Members (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@email.com'),
('Jane', 'Smith', 'jane.smith@email.com'),
('Mike', 'Johnson', 'mike.j@email.com');

INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(1, 1, '2025-06-20', '2025-07-04'),
(2, 2, '2025-06-25', '2025-07-09');

-- Creating indexes for optimization
CREATE INDEX idx_book_title ON Books(title);
CREATE INDEX idx_member_email ON Members(email);

-- Creating views
CREATE VIEW ActiveLoans AS
SELECT 
    l.loan_id,
    b.title,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    l.loan_date,
    l.due_date
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL;

-- Creating stored procedure for borrowing books
DELIMITER //
CREATE PROCEDURE BorrowBook(
    IN p_member_id INT,
    IN p_book_id INT,
    IN p_days INT
)
BEGIN
    DECLARE book_count INT;
    
    -- Check if book is available
    SELECT available_copies INTO book_count 
    FROM Books 
    WHERE book_id = p_book_id;
    
    IF book_count > 0 THEN
        -- Insert loan record
        INSERT INTO Loans (book_id, member_id, loan_date, due_date)
        VALUES (p_book_id, p_member_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_days DAY));
        
        -- Update available copies
        UPDATE Books 
        SET available_copies = available_copies - 1
        WHERE book_id = p_book_id;
        
        SELECT 'Book borrowed successfully' AS message;
    ELSE
        SELECT 'Book is not available' AS message;
    END IF;
END //
DELIMITER ;

-- Creating trigger for updating book availability
DELIMITER //
CREATE TRIGGER after_loan_return
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        UPDATE Books 
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
END //
DELIMITER ;

-- Sample queries demonstrating various SQL operations

-- Simple SELECT with WHERE
SELECT * FROM Books WHERE publication_year > 1950;

-- JOIN query
SELECT 
    b.title,
    COUNT(l.loan_id) as loan_count
FROM Books b
LEFT JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title;

-- Subquery
SELECT title 
FROM Books 
WHERE book_id IN (
    SELECT book_id 
    FROM Loans 
    WHERE return_date IS NULL
);

-- Aggregate functions
SELECT 
    COUNT(*) as total_books,
    AVG(publication_year) as avg_year,
    MAX(available_copies) as max_copies
FROM Books;

-- Using the view
SELECT * FROM ActiveLoans;

-- Example of calling the stored procedure
CALL BorrowBook(1, 3, 14);

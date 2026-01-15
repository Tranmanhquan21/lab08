-- 1. Tạo CSDL
DROP DATABASE IF EXISTS ql_thu_vien;
CREATE DATABASE ql_thu_vien CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ql_thu_vien;

-- 2. Tạo bảng categories
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Tạo bảng publishers
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Tạo bảng books
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category_id INT,
    publisher_id INT,
    price DECIMAL(10, 2) CHECK (price > 0),
    published_year INT,
    stock INT CHECK (stock >= 0),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- 5. Tạo bảng members
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 6. Tạo bảng loans
-- member_id ON DELETE RESTRICT: Không cho xóa thành viên nếu họ đã từng mượn sách
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    loan_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME,
    status VARCHAR(20) DEFAULT 'BORROWED', -- BORROWED, RETURNED, OVERDUE
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT
);

-- 7. Tạo bảng loan_items
-- loan_id ON DELETE CASCADE: Xóa phiếu mượn thì xóa luôn chi tiết phiếu mượn đó
CREATE TABLE loan_items (
    loan_id INT,
    book_id INT,
    qty INT CHECK (qty > 0),
    PRIMARY KEY (loan_id, book_id),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- =============================================
-- INSERT DỮ LIỆU MẪU
-- =============================================

-- 5 Categories
INSERT INTO categories (name) VALUES 
('Science Fiction'), ('History'), ('Technology'), ('Novel'), ('Business');

-- 3 Publishers
INSERT INTO publishers (name) VALUES 
('NXB Tre'), ('NXB Kim Dong'), ('OReilly Media');

-- 15 Books
INSERT INTO books (title, category_id, publisher_id, price, published_year, stock) VALUES
('Dune', 1, 3, 150000, 2020, 10),
('Sapiens', 2, 1, 200000, 2018, 5),
('Clean Code', 3, 3, 300000, 2015, 8),
('Mat Biec', 4, 1, 90000, 2019, 20),
('Rich Dad Poor Dad', 5, 1, 120000, 2010, 15),
('Effective Java', 3, 3, 250000, 2018, 7),
('The Great Gatsby', 4, 2, 85000, 2015, 12),
('Zero to One', 5, 3, 180000, 2014, 6),
('Homo Deus', 2, 1, 210000, 2017, 4),
('Harry Potter 1', 4, 2, 150000, 2000, 10),
('Harry Potter 2', 4, 2, 160000, 2002, 10),
('Design Patterns', 3, 3, 280000, 2005, 3),
('Doraemon Collection', 4, 2, 50000, 2021, 50),
('Neuromancer', 1, 3, 140000, 1984, 5),
('History of Vietnam', 2, 1, 110000, 2010, 8);

-- 8 Members
INSERT INTO members (full_name, phone) VALUES
('Nguyen Van A', '0901111111'),
('Tran Thi B', '0902222222'),
('Le Van C', '0903333333'),
('Pham Thi D', '0904444444'),
('Hoang Van E', '0905555555'),
('Do Thi F', '0906666666'),
('Ngo Van G', '0907777777'),
('Vu Thi H', '0908888888');

-- 12 Loans (Bao gồm phiếu quá hạn và phiếu gần đây để test truy vấn)
INSERT INTO loans (member_id, loan_date, due_date, status) VALUES
(1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'BORROWED'),
(2, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 3 DAY, 'OVERDUE'), -- Quá hạn
(3, NOW() - INTERVAL 2 DAY, DATE_ADD(NOW(), INTERVAL 5 DAY), 'BORROWED'),
(1, NOW() - INTERVAL 20 DAY, NOW() - INTERVAL 13 DAY, 'RETURNED'),
(4, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'BORROWED'),
(5, NOW() - INTERVAL 5 DAY, DATE_ADD(NOW(), INTERVAL 2 DAY), 'BORROWED'),
(1, NOW() - INTERVAL 1 DAY, DATE_ADD(NOW(), INTERVAL 6 DAY), 'BORROWED'), -- A mượn nhiều
(2, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'BORROWED'),
(6, NOW() - INTERVAL 40 DAY, NOW() - INTERVAL 33 DAY, 'RETURNED'), -- Mượn lâu rồi
(7, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'BORROWED'),
(3, NOW() - INTERVAL 1 DAY, DATE_ADD(NOW(), INTERVAL 7 DAY), 'BORROWED'),
(8, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'BORROWED');

-- 25 Loan Items
INSERT INTO loan_items (loan_id, book_id, qty) VALUES
(1, 1, 1), (1, 3, 1),
(2, 2, 1), (2, 4, 2),
(3, 5, 1),
(4, 1, 1), (4, 10, 1),
(5, 6, 1), (5, 7, 1),
(6, 8, 1),
(7, 2, 1), (7, 9, 1), (7, 12, 1),
(8, 13, 5),
(9, 14, 1),
(10, 15, 1),
(11, 3, 1), (11, 4, 1),
(12, 11, 1),
(3, 10, 1), -- Thêm item
(4, 11, 1), -- Thêm item
(6, 5, 1), -- Thêm item
(8, 6, 1);
-- Q1. Liệt kê danh sách sách với tên danh mục và nhà xuất bản
SELECT b.book_id, b.title, c.name AS category_name, p.name AS publisher_name, b.price, b.stock
FROM books b
JOIN categories c ON b.category_id = c.category_id
JOIN publishers p ON b.publisher_id = p.publisher_id;

-- Q2. Thống kê số sách theo từng danh mục (hiển thị cả danh mục chưa có sách)
SELECT c.name AS category_name, COUNT(b.book_id) AS book_count
FROM categories c
LEFT JOIN books b ON c.category_id = b.category_id
GROUP BY c.category_id, c.name;

-- Q3. Danh sách phiếu mượn
SELECT l.loan_id, m.full_name AS member_name, l.loan_date, l.due_date, l.status
FROM loans l
JOIN members m ON l.member_id = m.member_id;

-- Q4. Danh sách các sách đang được mượn (status = 'BORROWED')
SELECT m.full_name AS member_name, b.title, li.qty, l.due_date
FROM loans l
JOIN loan_items li ON l.loan_id = li.loan_id
JOIN books b ON li.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.status = 'BORROWED';

-- Q5. Top 5 sách được mượn nhiều nhất
SELECT b.title, SUM(li.qty) AS total_borrowed
FROM loan_items li
JOIN books b ON li.book_id = b.book_id
GROUP BY li.book_id, b.title
ORDER BY total_borrowed DESC
LIMIT 5;

-- Q6. Thống kê số lần mượn theo từng thành viên
SELECT m.full_name AS member_name, COUNT(DISTINCT l.loan_id) AS total_loans
FROM members m
JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.full_name;

-- Q7. Tìm các sách chưa từng được mượn
SELECT b.book_id, b.title
FROM books b
LEFT JOIN loan_items li ON b.book_id = li.book_id
WHERE li.loan_id IS NULL;

-- Q8. Danh sách các phiếu mượn quá hạn (giả sử ngày hiện tại để tính)
SELECT 
    l.loan_id, 
    m.full_name, 
    l.due_date, 
    DATEDIFF(CURDATE(), l.due_date) AS days_overdue
FROM loans l
JOIN members m ON l.member_id = m.member_id
WHERE l.due_date < CURDATE() AND l.status = 'BORROWED'; -- Hoặc 'OVERDUE' tuỳ dữ liệu

-- Q9. Tổng số lượng sách mượn theo danh mục, chỉ lấy > 5
SELECT c.name AS category_name, SUM(li.qty) AS total_qty
FROM categories c
JOIN books b ON c.category_id = b.category_id
JOIN loan_items li ON b.book_id = li.book_id
GROUP BY c.category_id, c.name
HAVING total_qty >= 5;

-- Q10. Bạn đọc tích cực (mượn >= 3 phiếu trong 30 ngày gần nhất)
SELECT m.full_name, COUNT(l.loan_id) AS recent_loans
FROM members m
JOIN loans l ON m.member_id = l.member_id
WHERE l.loan_date >= (NOW() - INTERVAL 30 DAY)
GROUP BY m.member_id, m.full_name
HAVING recent_loans >= 3;
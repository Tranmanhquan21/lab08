Phần A: Thiết kế & Ràng buộc (Schema & Constraints)
File: Lab08_schema.sql

Nội dung:

Tạo 6 bảng: categories, publishers, books, members, loans, loan_items.

Thiết lập khóa chính (PK), khóa ngoại (FK) với ON DELETE RESTRICT/CASCADE.

Ràng buộc toàn vẹn: UNIQUE (phone, name), CHECK (price > 0, stock >= 0).

Insert dữ liệu mẫu đa dạng để phục vụ thống kê.

Kiểm thử: Đã thực hiện các câu lệnh vi phạm constraint để kiểm tra tính toàn vẹn (xem trong thư mục screenshots/).

Phần B: Truy vấn dữ liệu (Queries)
File: Lab08_queries.sql

Nội dung: Thực hiện 10 câu truy vấn từ cơ bản đến nâng cao:

JOIN 3 bảng để lấy thông tin sách đầy đủ.

Thống kê sách theo danh mục (LEFT JOIN).

Tìm sách chưa từng được mượn (Anti-join / IS NULL).

Tìm bạn đọc tích cực và phiếu mượn quá hạn (Date functions).

Phần C: Tối ưu hóa (Index & Explain)
File: Lab08_explain.txt

Nội dung:

Phân tích hiệu năng của Query Q4 (Tìm sách đang mượn) và Query Q10 (Bạn đọc tích cực).

So sánh EXPLAIN trước và sau khi tạo Index.

Kết quả: Cải thiện từ type: ALL sang type: ref/range, giảm số lượng rows phải quét.

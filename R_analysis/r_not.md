- View(miss_var_summary(df))
- print(miss_var_summary(df), n = Inf)

Khoảng 15.8% dữ liệu bị thiếu — mức trung bình, có thể xử lý bằng imputation hoặc phân tích loại trừ tùy mục đích.

Một số biến có nhiều ô đen liền nhau → có thể là những biến bị thiếu dữ liệu nhiều (gợi ý kiểm tra cụ thể bằng miss_var_summary(df)).

Một số mẫu (dòng) có nhiều ô đen liên tiếp → có thể là các cá thể bị thiếu toàn bộ nhiều biến → cân nhắc loại bỏ.

Nếu thấy các mẫu thiếu có cùng pattern (ví dụ nhiều biến cùng bị thiếu ở các dòng giống nhau) → có thể dữ liệu bị thiếu theo cơ chế có hệ thống (MAR hoặc MNAR).
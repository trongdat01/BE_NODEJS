-- Create Database
CREATE DATABASE
IF NOT EXISTS QuanLyDaoTaoDaiHoc;
USE QuanLyDaoTaoDaiHoc;

-- 1. Bảng Tài Khoản
CREATE TABLE
IF NOT EXISTS TaiKhoan
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_dang_nhap VARCHAR
(50) UNIQUE NOT NULL,
    mat_khau VARCHAR
(255) NOT NULL, -- Nên hash mật khẩu trong ứng dụng thực tế
    loai_tai_khoan VARCHAR
(10) NOT NULL CHECK
(loai_tai_khoan IN
('admin', 'sinh_vien')),
    email VARCHAR
(100) UNIQUE,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng Khoa/Ngành
CREATE TABLE
IF NOT EXISTS KhoaNganh
(
    ma_khoa_nganh VARCHAR
(10) PRIMARY KEY,
    ten_khoa_nganh VARCHAR
(100) NOT NULL
);

-- 3. Bảng Sinh Viên
CREATE TABLE
IF NOT EXISTS SinhVien
(
    msv VARCHAR
(15) PRIMARY KEY,
    ho_ten VARCHAR
(100) NOT NULL,
    ma_lop VARCHAR
(20),
    ma_khoa_nganh VARCHAR
(10),
    nien_khoa VARCHAR
(15), -- e.g., '2021-2025'
    ngay_sinh DATE,
    gioi_tinh VARCHAR
(5) CHECK
(gioi_tinh IN
('Nam', 'Nữ', 'Khác')),
    so_cccd VARCHAR
(12) UNIQUE,
    so_dien_thoai VARCHAR
(15) UNIQUE,
    que_quan VARCHAR
(255),
    dia_chi VARCHAR
(255),
    trang_thai VARCHAR
(20) DEFAULT 'Đang học' CHECK
(trang_thai IN
('Đang học', 'Bị thôi học', 'Đã tốt nghiệp')),
    email VARCHAR
(100) UNIQUE NOT NULL,
    mat_khau VARCHAR
(255) NOT NULL, -- Lưu mật khẩu (ngày tháng năm sinh viết liền) - nên hash
    anh_dai_dien VARCHAR
(255), -- Lưu đường dẫn tới file ảnh
    tai_khoan_id INT UNIQUE, -- Liên kết với bảng TaiKhoan
    FOREIGN KEY
(ma_khoa_nganh) REFERENCES KhoaNganh
(ma_khoa_nganh)
);

-- 4. Bảng Tin Tức
CREATE TABLE
IF NOT EXISTS TinTuc
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tieu_de VARCHAR
(255) NOT NULL,
    danh_muc VARCHAR
(20) NOT NULL CHECK
(danh_muc IN
('Thông báo', 'Sự kiện', 'Học thuật', 'Tuyển sinh')),
    ngay_dang DATE NOT NULL,
    noi_dung TEXT,
    link_bai_dang VARCHAR
(255)
);

-- 5. Bảng Chương Trình Học
CREATE TABLE
IF NOT EXISTS ChuongTrinhHoc
(
    ma_chuong_trinh VARCHAR
(20) PRIMARY KEY,
    ten_chuong_trinh VARCHAR
(255) NOT NULL,
    ma_khoa_nganh VARCHAR
(10),
    he_dao_tao VARCHAR
(50),
    loai_bang VARCHAR
(50),
    tong_so_tin INT,
    thoi_gian_dao_tao VARCHAR
(50),
    mo_ta TEXT,
    muc_tieu_dao_tao TEXT,
    chuan_dau_ra TEXT,
    dieu_kien_tot_nghiep TEXT,
    link_tai_lieu VARCHAR
(255),
    FOREIGN KEY
(ma_khoa_nganh) REFERENCES KhoaNganh
(ma_khoa_nganh)
);

-- 6. Bảng Học Phần
CREATE TABLE
IF NOT EXISTS HocPhan
(
    ma_hoc_phan VARCHAR
(15) PRIMARY KEY,
    ten_hoc_phan VARCHAR
(100) NOT NULL,
    loai_hoc_phan VARCHAR
(15) NOT NULL CHECK
(loai_hoc_phan IN
('Bắt buộc', 'Tự chọn', 'Đồ án', 'Thực tập')),
    tin_chi_ly_thuyet INT DEFAULT 0,
    tin_chi_thuc_hanh INT DEFAULT 0,
    so_tiet_hoc INT,
    hoc_ky_goi_y INT
);

-- Bảng trung gian: Học phần thuộc Chương trình học và Khối kiến thức
CREATE TABLE
IF NOT EXISTS ChuongTrinhHoc_HocPhan
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_chuong_trinh VARCHAR
(20),
    ma_hoc_phan VARCHAR
(15),
    khoi_kien_thuc VARCHAR
(15) NOT NULL CHECK
(khoi_kien_thuc IN
('Đại cương', 'Cơ sở ngành', 'Chuyên ngành', 'Tự chọn')),
    UNIQUE KEY UQ_cthp
(ma_chuong_trinh, ma_hoc_phan),
    FOREIGN KEY
(ma_chuong_trinh) REFERENCES ChuongTrinhHoc
(ma_chuong_trinh),
    FOREIGN KEY
(ma_hoc_phan) REFERENCES HocPhan
(ma_hoc_phan)
);

-- 7. Bảng Điểm
CREATE TABLE
IF NOT EXISTS Diem
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    msv VARCHAR
(15),
    ma_hoc_phan VARCHAR
(15),
    hoc_ky VARCHAR
(10), -- e.g., '20231'
    diem_qua_trinh DECIMAL
(4, 2),
    diem_thi DECIMAL
(4, 2),
    diem_tong_ket DECIMAL
(4, 2),
    trang_thai VARCHAR
(15) DEFAULT 'Chưa có điểm' CHECK
(trang_thai IN
('Đạt', 'Học lại', 'Chưa có điểm')),
    FOREIGN KEY
(msv) REFERENCES SinhVien
(msv),
    FOREIGN KEY
(ma_hoc_phan) REFERENCES HocPhan
(ma_hoc_phan)
);

-- 8. Bảng Giảng Viên
CREATE TABLE
IF NOT EXISTS GiangVien
(
    ma_giang_vien VARCHAR
(10) PRIMARY KEY,
    ho_ten VARCHAR
(100) NOT NULL,
    ma_khoa_nganh VARCHAR
(10),
    email VARCHAR
(100) UNIQUE,
    so_dien_thoai VARCHAR
(15),
    FOREIGN KEY
(ma_khoa_nganh) REFERENCES KhoaNganh
(ma_khoa_nganh)
);

-- 9. Bảng Lớp Học Phần
CREATE TABLE
IF NOT EXISTS LopHocPhan
(
    ma_lop_hoc_phan VARCHAR
(20) PRIMARY KEY,
    ma_hoc_phan VARCHAR
(15),
    nam_hoc INT,
    hoc_ky VARCHAR
(10), -- e.g., '20231'
    ma_giang_vien VARCHAR
(10),
    si_so_toi_da INT,
    FOREIGN KEY
(ma_hoc_phan) REFERENCES HocPhan
(ma_hoc_phan),
    FOREIGN KEY
(ma_giang_vien) REFERENCES GiangVien
(ma_giang_vien)
);

-- 10. Bảng Lịch Học
CREATE TABLE
IF NOT EXISTS LichHoc
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_lop_hoc_phan VARCHAR
(20),
    phong_hoc_ly_thuyet VARCHAR
(20),
    thu_ly_thuyet INT, -- 2=Thứ 2, ..., 8=Chủ nhật
    ca_hoc_ly_thuyet VARCHAR
(50),
    phong_hoc_thuc_hanh VARCHAR
(20),
    thu_thuc_hanh INT,
    ca_hoc_thuc_hanh VARCHAR
(50),
    ngay_bat_dau DATE,
    ngay_ket_thuc DATE,
    FOREIGN KEY
(ma_lop_hoc_phan) REFERENCES LopHocPhan
(ma_lop_hoc_phan)
);

-- Bảng trung gian: Sinh viên đăng ký Lớp học phần
CREATE TABLE
IF NOT EXISTS DangKyLopHocPhan
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    msv VARCHAR
(15),
    ma_lop_hoc_phan VARCHAR
(20),
    ngay_dang_ky DATETIME DEFAULT CURRENT_TIMESTAMP,
    trang_thai_dk VARCHAR
(15) DEFAULT 'Chưa đăng ký' CHECK
(trang_thai_dk IN
('Đã đăng ký', 'Chưa đăng ký')),
    UNIQUE KEY UQ_sv_lhp
(msv, ma_lop_hoc_phan),
    FOREIGN KEY
(msv) REFERENCES SinhVien
(msv),
    FOREIGN KEY
(ma_lop_hoc_phan) REFERENCES LopHocPhan
(ma_lop_hoc_phan)
);

-- 11. Bảng Lịch Thi
CREATE TABLE
IF NOT EXISTS LichThi
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma_hoc_phan VARCHAR
(15),
    nam_hoc INT,
    hoc_ky VARCHAR
(10),
    ngay_thi DATE,
    gio_thi TIME,
    phong_thi VARCHAR
(50),
    hinh_thuc_thi VARCHAR
(100),
    thoi_gian_lam_bai INT, -- Số phút
    trang_thai VARCHAR
(20) DEFAULT 'Đã lên lịch' CHECK
(trang_thai IN
('Đã lên lịch', 'Đã hoàn thành', 'Hoãn thi')),
    FOREIGN KEY
(ma_hoc_phan) REFERENCES HocPhan
(ma_hoc_phan)
);

-- Bảng trung gian: Sinh viên dự thi
CREATE TABLE
IF NOT EXISTS DuThi
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_lich_thi INT,
    msv VARCHAR
(15),
    so_bao_danh VARCHAR
(10),
    FOREIGN KEY
(id_lich_thi) REFERENCES LichThi
(id),
    FOREIGN KEY
(msv) REFERENCES SinhVien
(msv),
    UNIQUE KEY UQ_lt_sv
(id_lich_thi, msv)
);

-- Bảng trung gian: Giảng viên coi thi
CREATE TABLE
IF NOT EXISTS CoiThi
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_lich_thi INT,
    ma_giang_vien VARCHAR
(10),
    FOREIGN KEY
(id_lich_thi) REFERENCES LichThi
(id),
    FOREIGN KEY
(ma_giang_vien) REFERENCES GiangVien
(ma_giang_vien)
);

-- 12. Bảng Tài Chính Sinh Viên
CREATE TABLE
IF NOT EXISTS TaiChinh
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    msv VARCHAR
(15) UNIQUE, -- Mỗi sinh viên có 1 bản ghi tài chính tổng hợp
    tong_phai_nop DECIMAL
(15, 2) DEFAULT 0.00,
    tong_da_nop DECIMAL
(15, 2) DEFAULT 0.00,
    tong_mien_giam DECIMAL
(15, 2) DEFAULT 0.00,
    trang_thai VARCHAR
(20) DEFAULT 'Chưa hoàn thành' CHECK
(trang_thai IN
('Đã hoàn thành', 'Chưa hoàn thành')),
    ghi_chu TEXT,
    FOREIGN KEY
(msv) REFERENCES SinhVien
(msv)
);

-- 13. Bảng Phiếu Thu
CREATE TABLE
IF NOT EXISTS PhieuThu
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tai_chinh INT,
    so_tien_thu DECIMAL
(15, 2) NOT NULL,
    ngay_thu DATE NOT NULL,
    noi_dung_thu VARCHAR
(255),
    ngan_hang_chuyen VARCHAR
(100),
    ngan_hang_nhan VARCHAR
(100),
    nguoi_lap_phieu VARCHAR
(100),
    FOREIGN KEY
(id_tai_chinh) REFERENCES TaiChinh
(id)
);

-- 14. Bảng Thông Tin Thanh Toán (QR Code...)
CREATE TABLE
IF NOT EXISTS ThongTinThanhToan
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_ngan_hang VARCHAR
(100) NOT NULL,
    so_tai_khoan VARCHAR
(20) NOT NULL,
    ten_nguoi_nhan VARCHAR
(100) NOT NULL,
    ma_qr_code_url VARCHAR
(255)
);

-- ======= INSERT DỮ LIỆU MẪU =======

-- Tài Khoản
INSERT INTO TaiKhoan
    (ten_dang_nhap, mat_khau, loai_tai_khoan, email)
VALUES
    ('admin', 'hashed_admin_password', 'admin', 'admin@utc.edu.vn');
-- Thay 'hashed_admin_password' bằng mật khẩu đã hash

INSERT INTO TaiKhoan
    (ten_dang_nhap, mat_khau, loai_tai_khoan, email)
VALUES
    ('sinhvien01', 'hashed_sv01_password', 'sinh_vien', 'sv01@student.utc.edu.vn');
-- Thay 'hashed_sv01_password'

-- Khoa Ngành
INSERT INTO KhoaNganh
    (ma_khoa_nganh, ten_khoa_nganh)
VALUES
    ('CNTT', 'Công nghệ thông tin');
INSERT INTO KhoaNganh
    (ma_khoa_nganh, ten_khoa_nganh)
VALUES
    ('KTXD', 'Kỹ thuật xây dựng');
INSERT INTO KhoaNganh
    (ma_khoa_nganh, ten_khoa_nganh)
VALUES
    ('CKOTO', 'Cơ khí ô tô');

-- Sinh Viên (Liên kết với Tài Khoản)
SET @sv01_tk_id = (SELECT id
FROM TaiKhoan
WHERE ten_dang_nhap = 'sinhvien01');

INSERT INTO SinhVien
    (msv, ho_ten, ma_lop, ma_khoa_nganh, nien_khoa, ngay_sinh, gioi_tinh, so_cccd, so_dien_thoai, que_quan, dia_chi, trang_thai, email, mat_khau, anh_dai_dien, tai_khoan_id)
VALUES
    ('70DCTT21001', 'Nguyễn Văn A', '70DCTT21', 'CNTT', '2022-2026', '2004-05-10', 'Nam', '001204000111', '0987654321', 'Hà Nội', 'Số 1, Đường ABC, Quận XYZ, Hà Nội', 'Đang học', 'sv01@student.utc.edu.vn', '10052004', '/images/avatars/sv01.png', @sv01_tk_id);

-- Tin Tức
INSERT INTO TinTuc
    (tieu_de, danh_muc, ngay_dang, noi_dung, link_bai_dang)
VALUES
    ('Thông báo lịch thi cuối kỳ 2 năm học 2023-2024', 'Thông báo', '2024-05-15', 'Chi tiết lịch thi xem tại...', 'pages/news_detail.html?id=1');
INSERT INTO TinTuc
    (tieu_de, danh_muc, ngay_dang, noi_dung, link_bai_dang)
VALUES
    ('Hội thảo khoa học sinh viên cấp trường năm 2024', 'Sự kiện', '2024-05-10', 'Trân trọng kính mời...', 'pages/news_detail.html?id=2');
INSERT INTO TinTuc
    (tieu_de, danh_muc, ngay_dang, noi_dung, link_bai_dang)
VALUES
    ('Tuyển sinh đại học chính quy năm 2024', 'Tuyển sinh', '2024-04-20', 'Thông tin chi tiết về các ngành tuyển sinh...', 'pages/news_detail.html?id=3');

-- Chương Trình Học
INSERT INTO ChuongTrinhHoc
    (ma_chuong_trinh, ten_chuong_trinh, ma_khoa_nganh, he_dao_tao, loai_bang, tong_so_tin, thoi_gian_dao_tao, mo_ta, muc_tieu_dao_tao, chuan_dau_ra, dieu_kien_tot_nghiep)
VALUES
    ('CNTT_KSTN_2022', 'Kỹ sư Công nghệ thông tin (Tài năng)', 'CNTT', 'Đại học chính quy', 'Kỹ sư', 160, '4.5 năm', 'Chương trình đào tạo kỹ sư tài năng...', 'Đào tạo kỹ sư CNTT chất lượng cao...', 'PLO1, PLO2...', 'Hoàn thành 160 tín chỉ...');

-- Học Phần
INSERT INTO HocPhan
    (ma_hoc_phan, ten_hoc_phan, loai_hoc_phan, tin_chi_ly_thuyet, tin_chi_thuc_hanh, so_tiet_hoc, hoc_ky_goi_y)
VALUES
    ('MAT101', 'Giải tích I', 'Bắt buộc', 3, 1, 60, 1);
INSERT INTO HocPhan
    (ma_hoc_phan, ten_hoc_phan, loai_hoc_phan, tin_chi_ly_thuyet, tin_chi_thuc_hanh, so_tiet_hoc, hoc_ky_goi_y)
VALUES
    ('PHY101', 'Vật lý đại cương I', 'Bắt buộc', 2, 1, 45, 1);
INSERT INTO HocPhan
    (ma_hoc_phan, ten_hoc_phan, loai_hoc_phan, tin_chi_ly_thuyet, tin_chi_thuc_hanh, so_tiet_hoc, hoc_ky_goi_y)
VALUES
    ('CSE101', 'Nhập môn lập trình', 'Bắt buộc', 2, 2, 60, 1);
INSERT INTO HocPhan
    (ma_hoc_phan, ten_hoc_phan, loai_hoc_phan, tin_chi_ly_thuyet, tin_chi_thuc_hanh, so_tiet_hoc, hoc_ky_goi_y)
VALUES
    ('CSE201', 'Cấu trúc dữ liệu và giải thuật', 'Bắt buộc', 3, 1, 60, 2);
INSERT INTO HocPhan
    (ma_hoc_phan, ten_hoc_phan, loai_hoc_phan, tin_chi_ly_thuyet, tin_chi_thuc_hanh, so_tiet_hoc, hoc_ky_goi_y)
VALUES
    ('ENG101', 'Tiếng Anh cơ bản 1', 'Bắt buộc', 3, 0, 45, 1);

-- Chương Trình Học - Học Phần
INSERT INTO ChuongTrinhHoc_HocPhan
    (ma_chuong_trinh, ma_hoc_phan, khoi_kien_thuc)
VALUES
    ('CNTT_KSTN_2022', 'MAT101', 'Đại cương');
INSERT INTO ChuongTrinhHoc_HocPhan
    (ma_chuong_trinh, ma_hoc_phan, khoi_kien_thuc)
VALUES
    ('CNTT_KSTN_2022', 'PHY101', 'Đại cương');
INSERT INTO ChuongTrinhHoc_HocPhan
    (ma_chuong_trinh, ma_hoc_phan, khoi_kien_thuc)
VALUES
    ('CNTT_KSTN_2022', 'ENG101', 'Đại cương');
INSERT INTO ChuongTrinhHoc_HocPhan
    (ma_chuong_trinh, ma_hoc_phan, khoi_kien_thuc)
VALUES
    ('CNTT_KSTN_2022', 'CSE101', 'Cơ sở ngành');
INSERT INTO ChuongTrinhHoc_HocPhan
    (ma_chuong_trinh, ma_hoc_phan, khoi_kien_thuc)
VALUES
    ('CNTT_KSTN_2022', 'CSE201', 'Cơ sở ngành');

-- Giảng Viên
INSERT INTO GiangVien
    (ma_giang_vien, ho_ten, ma_khoa_nganh, email, so_dien_thoai)
VALUES
    ('GV001', 'Trần Thị B', 'CNTT', 'ttb@utc.edu.vn', '0912345678');
INSERT INTO GiangVien
    (ma_giang_vien, ho_ten, ma_khoa_nganh, email, so_dien_thoai)
VALUES
    ('GV002', 'Lê Văn C', 'CNTT', 'lvc@utc.edu.vn', '0905112233');

-- Lớp Học Phần
INSERT INTO LopHocPhan
    (ma_lop_hoc_phan, ma_hoc_phan, nam_hoc, hoc_ky, ma_giang_vien, si_so_toi_da)
VALUES
    ('CSE101.1_20231', 'CSE101', 2023, '20231', 'GV001', 70);
INSERT INTO LopHocPhan
    (ma_lop_hoc_phan, ma_hoc_phan, nam_hoc, hoc_ky, ma_giang_vien, si_so_toi_da)
VALUES
    ('MAT101.2_20231', 'MAT101', 2023, '20231', 'GV002', 100);

-- Lịch Học
INSERT INTO LichHoc
    (ma_lop_hoc_phan, phong_hoc_ly_thuyet, thu_ly_thuyet, ca_hoc_ly_thuyet, phong_hoc_thuc_hanh, thu_thuc_hanh, ca_hoc_thuc_hanh, ngay_bat_dau, ngay_ket_thuc)
VALUES
    ('CSE101.1_20231', 'P301', 2, '1-3', 'Lab101', 4, '7-9', '2023-09-05', '2023-12-15');
INSERT INTO LichHoc
    (ma_lop_hoc_phan, phong_hoc_ly_thuyet, thu_ly_thuyet, ca_hoc_ly_thuyet, phong_hoc_thuc_hanh, thu_thuc_hanh, ca_hoc_thuc_hanh, ngay_bat_dau, ngay_ket_thuc)
VALUES
    ('MAT101.2_20231', 'P405', 3, '4-6', NULL, NULL, NULL, '2023-09-06', '2023-12-16');

-- Đăng Ký Lớp Học Phần
INSERT INTO DangKyLopHocPhan
    (msv, ma_lop_hoc_phan, trang_thai_dk)
VALUES
    ('70DCTT21001', 'CSE101.1_20231', 'Đã đăng ký');
INSERT INTO DangKyLopHocPhan
    (msv, ma_lop_hoc_phan, trang_thai_dk)
VALUES
    ('70DCTT21001', 'MAT101.2_20231', 'Đã đăng ký');

-- Điểm
INSERT INTO Diem
    (msv, ma_hoc_phan, hoc_ky, diem_qua_trinh, diem_thi, diem_tong_ket, trang_thai)
VALUES
    ('70DCTT21001', 'ENG101', '20222', 8.5, 7.0, 7.8, 'Đạt');
-- Giả sử sv đã học kỳ trước

-- Tài Chính
INSERT INTO TaiChinh
    (msv, tong_phai_nop, tong_da_nop, tong_mien_giam, trang_thai)
VALUES
    ('70DCTT21001', 15000000.00, 7500000.00, 0.00, 'Chưa hoàn thành');

-- Phiếu Thu
SET @tc_sv01_id_insert = (SELECT id
FROM TaiChinh
WHERE msv = '70DCTT21001');

INSERT INTO PhieuThu
    (id_tai_chinh, so_tien_thu, ngay_thu, noi_dung_thu, ngan_hang_chuyen, nguoi_lap_phieu)
VALUES
    (@tc_sv01_id_insert, 7500000.00, '2023-08-20', 'Nộp học phí kỳ 1 năm 2023-2024', 'Vietcombank', 'NV001');

-- Thông Tin Thanh Toán (Ví dụ)
INSERT INTO ThongTinThanhToan
    (ten_ngan_hang, so_tai_khoan, ten_nguoi_nhan, ma_qr_code_url)
VALUES
    ('Ngân hàng ABC', '1234567890', 'Trường Đại học Giao thông Vận tải', '/images/qr/payment_qr.png');

-- Lịch Thi (Ví dụ)
INSERT INTO LichThi
    (ma_hoc_phan, nam_hoc, hoc_ky, ngay_thi, gio_thi, phong_thi, hinh_thuc_thi, thoi_gian_lam_bai, trang_thai)
VALUES
    ('CSE101', 2023, '20231', '2023-12-20', '08:00:00', 'H1-201', 'Trắc nghiệm trên máy', 60, 'Đã lên lịch');

-- Coi Thi (Ví dụ)
SET @lt_cse101_id_insert = (SELECT id
FROM LichThi
WHERE ma_hoc_phan = 'CSE101' AND hoc_ky = '20231');

INSERT INTO CoiThi
    (id_lich_thi, ma_giang_vien)
VALUES
    (@lt_cse101_id_insert, 'GV001');

-- Dự Thi (Ví dụ)
SET @dt_lt_cse101_id = (SELECT id
FROM LichThi
WHERE ma_hoc_phan = 'CSE101' AND hoc_ky = '20231');

INSERT INTO DuThi
    (id_lich_thi, msv, so_bao_danh)
VALUES
    (@dt_lt_cse101_id, '70DCTT21001', 'SBD001');

-- Print successful completion
SELECT 'Database schema and sample data created successfully.' AS Message;

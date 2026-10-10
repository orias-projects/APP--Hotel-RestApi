-- SCHEMA: hotel_schema.sql
-- Chỉ giữ lại 3 file: hotel_schema.sql, hotel_policy.sql, hotel_seed.sql. Xóa các file SQL cũ khác để tối giản folder database.

DROP DATABASE IF EXISTS ql_khachsan;
CREATE DATABASE IF NOT EXISTS ql_khachsan CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE ql_khachsan;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `a1_khachhang`;
CREATE TABLE `a1_khachhang` (
  `MaKhachHang` varchar(50) NOT NULL COMMENT 'Mã khách hàng',
  `TenKhachHang` varchar(100) DEFAULT NULL COMMENT 'Tên khách hàng',
  `GioiTinh` enum('Nam','Nữ') DEFAULT NULL COMMENT 'Giới tính',
  `Sdt` varchar(15) DEFAULT NULL COMMENT 'SĐT',
  `TinhTrangKhach` enum('Đang ở','Đã rời','Đang đặt') DEFAULT NULL COMMENT 'Tình trạng',
  PRIMARY KEY (`MaKhachHang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Khách hàng';

DROP TABLE IF EXISTS `b1_hoadon`;
CREATE TABLE `b1_hoadon` (
  `MaHoaDon` varchar(50) NOT NULL COMMENT 'Mã hóa đơn',
  `MaNhanVien` varchar(50) DEFAULT NULL COMMENT 'Mã nhân viên',
  `MaKhachHang` varchar(50) DEFAULT NULL COMMENT 'Mã khách hàng',
  `Ngay` date DEFAULT NULL COMMENT 'Ngày nhập',
  `TongTien` decimal(10,2) DEFAULT NULL COMMENT 'Tổng tiền',
  PRIMARY KEY (`MaHoaDon`),
  KEY `MaNhanVien` (`MaNhanVien`),
  KEY `MaKhachHang` (`MaKhachHang`),
  CONSTRAINT `b1_hoadon_ibfk_1` FOREIGN KEY (`MaNhanVien`) REFERENCES `f1_nhanvien` (`MaNhanVien`),
  CONSTRAINT `b1_hoadon_ibfk_2` FOREIGN KEY (`MaKhachHang`) REFERENCES `a1_khachhang` (`MaKhachHang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Hóa đơn';

DROP TABLE IF EXISTS `b2_hoadonchitiet`;
CREATE TABLE `b2_hoadonchitiet` (
  `MaHoaDon` varchar(50) NOT NULL COMMENT 'Mã hóa đơn',
  `MaPhong` varchar(50) NOT NULL COMMENT 'Mã phòng',
  `MaDichVu` varchar(50) NOT NULL COMMENT 'Mã dịch vụ',
  PRIMARY KEY (`MaHoaDon`,`MaPhong`,`MaDichVu`),
  KEY `MaPhong` (`MaPhong`),
  KEY `MaDichVu` (`MaDichVu`),
  CONSTRAINT `b2_hoadonchitiet_ibfk_1` FOREIGN KEY (`MaHoaDon`) REFERENCES `b1_hoadon` (`MaHoaDon`),
  CONSTRAINT `b2_hoadonchitiet_ibfk_2` FOREIGN KEY (`MaPhong`) REFERENCES `c2_phong` (`MaPhong`),
  CONSTRAINT `b2_hoadonchitiet_ibfk_3` FOREIGN KEY (`MaDichVu`) REFERENCES `e1_dichvu` (`MaDichVu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Hóa đơn chi tiết';

DROP TABLE IF EXISTS `c1_loaiphong`;
CREATE TABLE `c1_loaiphong` (
  `MaLoai` varchar(50) NOT NULL COMMENT 'Mã loại phòng',
  `TenLoai` varchar(100) DEFAULT NULL COMMENT 'Tên loại',
  `SoGiuong` varchar(100) DEFAULT NULL COMMENT 'Số giường',
  `GiaLoai` decimal(10,2) DEFAULT NULL COMMENT 'Giá loại phòng',
  PRIMARY KEY (`MaLoai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Loại phòng';

DROP TABLE IF EXISTS `c2_phong`;
CREATE TABLE `c2_phong` (
  `MaPhong` varchar(50) NOT NULL COMMENT 'Mã phòng',
  `TenPhong` varchar(100) DEFAULT NULL COMMENT 'Tên phòng',
  `MaLoai` varchar(50) DEFAULT NULL COMMENT 'Loại phòng',
  `MoTa` varchar(50) DEFAULT NULL COMMENT 'Mô tả',
  `TinhTrangPhong` enum('Trống','Đang sử dụng','Đã đặt') DEFAULT NULL COMMENT 'Tình trạng phòng',
  PRIMARY KEY (`MaPhong`),
  KEY `MaLoai` (`MaLoai`),
  CONSTRAINT `c2_phong_ibfk_1` FOREIGN KEY (`MaLoai`) REFERENCES `c1_loaiphong` (`MaLoai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Phòng';

DROP TABLE IF EXISTS `c3_datphong`;
CREATE TABLE `c3_datphong` (
  `MaDatPhong` varchar(50) NOT NULL COMMENT 'Mã đặt phòng',
  `MaPhong` varchar(50) DEFAULT NULL COMMENT 'Mã phòng',
  `MaNhanVien` varchar(50) DEFAULT NULL COMMENT 'Mã nhân viên',
  `MaKhachHang` varchar(50) DEFAULT NULL COMMENT 'Mã khách hàng',
  `NgayNhanPhong` datetime DEFAULT NULL COMMENT 'Ngày nhận phòng',
  `NgayTraPhong` datetime DEFAULT NULL COMMENT 'Ngày trả phòng',
  `CachDat` enum('Đặt online','Đặt trực tiếp') DEFAULT NULL COMMENT 'Cách đặt',
  `TinhTrang` enum('Đang sử dụng','Quá hạn','Đang đợi','Đã trả') DEFAULT NULL COMMENT 'Tình trạng',
  `TienPhat` decimal(10,2) DEFAULT '0.00' COMMENT 'Phạt',
  PRIMARY KEY (`MaDatPhong`),
  KEY `MaPhong` (`MaPhong`),
  KEY `MaNhanVien` (`MaNhanVien`),
  KEY `MaKhachHang` (`MaKhachHang`),
  CONSTRAINT `c3_datphong_ibfk_1` FOREIGN KEY (`MaPhong`) REFERENCES `c2_phong` (`MaPhong`),
  CONSTRAINT `c3_datphong_ibfk_2` FOREIGN KEY (`MaNhanVien`) REFERENCES `f1_nhanvien` (`MaNhanVien`),
  CONSTRAINT `c3_datphong_ibfk_3` FOREIGN KEY (`MaKhachHang`) REFERENCES `a1_khachhang` (`MaKhachHang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Đặt phòng';

DROP TABLE IF EXISTS `d1_thietbi`;
CREATE TABLE `d1_thietbi` (
  `MaThietBi` varchar(50) NOT NULL COMMENT 'Mã thiết bị',
  `TenThietBi` varchar(100) DEFAULT NULL COMMENT 'Tên thiết bị',
  `DonGia` decimal(10,2) DEFAULT NULL COMMENT 'Đơn giá thiết bị',
  `DenBu` decimal(10,2) DEFAULT NULL COMMENT 'Đền bù',
  PRIMARY KEY (`MaThietBi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Thiết bị';

DROP TABLE IF EXISTS `d2_thietbiphong`;
CREATE TABLE `d2_thietbiphong` (
  `MaPhong` varchar(50) NOT NULL COMMENT 'Mã phòng',
  `MaThietBi` varchar(50) NOT NULL COMMENT 'Mã thiết bị',
  `SoLuong` int DEFAULT NULL COMMENT 'Số lượng thiết bị',
  `TrangThai` enum('Tốt','Hư hỏng') DEFAULT NULL COMMENT 'Tình trạng thiết bị',
  PRIMARY KEY (`MaPhong`,`MaThietBi`),
  KEY `MaThietBi` (`MaThietBi`),
  CONSTRAINT `d2_thietbiphong_ibfk_1` FOREIGN KEY (`MaPhong`) REFERENCES `c2_phong` (`MaPhong`),
  CONSTRAINT `d2_thietbiphong_ibfk_2` FOREIGN KEY (`MaThietBi`) REFERENCES `d1_thietbi` (`MaThietBi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Thiết bị phòng';

DROP TABLE IF EXISTS `d3_kiemtraphong`;
CREATE TABLE `d3_kiemtraphong` (
  `MaKiemTra` varchar(50) NOT NULL COMMENT 'Mã kiểm tra phòng',
  `MaPhong` varchar(50) DEFAULT NULL COMMENT 'Mã phòng',
  `MaNhanVien` varchar(50) DEFAULT NULL COMMENT 'Mã nhân viên',
  `NgayKiemTra` datetime DEFAULT NULL COMMENT 'Ngày kiểm tra',
  `GhiChu` varchar(255) DEFAULT NULL COMMENT 'Ghi chú',
  `TrangThai` enum('Tốt','Cần dọn','Hỏng') DEFAULT NULL COMMENT 'Tình trạng phòng',
  PRIMARY KEY (`MaKiemTra`),
  KEY `MaPhong` (`MaPhong`),
  KEY `MaNhanVien` (`MaNhanVien`),
  CONSTRAINT `d3_kiemtraphong_ibfk_1` FOREIGN KEY (`MaPhong`) REFERENCES `c2_phong` (`MaPhong`),
  CONSTRAINT `d3_kiemtraphong_ibfk_2` FOREIGN KEY (`MaNhanVien`) REFERENCES `f1_nhanvien` (`MaNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Kiểm tra phòng';

DROP TABLE IF EXISTS `d4_kiemtrachitiet`;
CREATE TABLE `d4_kiemtrachitiet` (
  `MaKiemTra` varchar(50) NOT NULL COMMENT 'Mã kiểm tra',
  `MaPhong` varchar(50) DEFAULT NULL COMMENT 'Mã phòng',
  `MaThietBi` varchar(50) NOT NULL COMMENT 'Mã thiết bị',
  `TinhTrang` enum('Tốt','Hỏng') DEFAULT NULL COMMENT 'Tình trạng thiết bị',
  `DenBu` decimal(10,2) DEFAULT NULL COMMENT 'Đền bù',
  `GhiChu` varchar(255) DEFAULT NULL COMMENT 'Ghi chú',
  PRIMARY KEY (`MaKiemTra`,`MaThietBi`),
  KEY `MaThietBi` (`MaThietBi`),
  KEY `fk_kiemtra_thietbiphong` (`MaPhong`,`MaThietBi`),
  CONSTRAINT `d4_kiemtrachitiet_ibfk_1` FOREIGN KEY (`MaKiemTra`) REFERENCES `d3_kiemtraphong` (`MaKiemTra`),
  CONSTRAINT `fk_kiemtra_thietbiphong` FOREIGN KEY (`MaPhong`, `MaThietBi`) REFERENCES `d2_thietbiphong` (`MaPhong`, `MaThietBi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Kiểm tra chi tiết';

DROP TABLE IF EXISTS `e1_dichvu`;
CREATE TABLE `e1_dichvu` (
  `MaDichVu` varchar(50) NOT NULL COMMENT 'Mã dịch vụ',
  `TenDichVu` varchar(255) DEFAULT NULL COMMENT 'Tên dịch vụ',
  `LoaiDichVu` varchar(100) DEFAULT NULL COMMENT 'Loại dịch vụ',
  `GiaDichVu` decimal(10,2) DEFAULT NULL COMMENT 'Giá dịch vụ',
  PRIMARY KEY (`MaDichVu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dịch vụ';

DROP TABLE IF EXISTS `e2_sddv`;
CREATE TABLE `e2_sddv` (
  `MaSDDV` varchar(50) NOT NULL COMMENT 'Mã sử dụng dịch vụ',
  `MaKhachHang` varchar(50) DEFAULT NULL COMMENT 'Mã khách hàng',
  `MaNhanVien` varchar(50) DEFAULT NULL COMMENT 'Mã nhân viên',
  `NgaySDDV` date DEFAULT NULL COMMENT 'Ngày sử dụng dịch vụ',
  PRIMARY KEY (`MaSDDV`),
  KEY `MaKhachHang` (`MaKhachHang`),
  KEY `MaNhanVien` (`MaNhanVien`),
  CONSTRAINT `e2_sddv_ibfk_1` FOREIGN KEY (`MaKhachHang`) REFERENCES `a1_khachhang` (`MaKhachHang`),
  CONSTRAINT `e2_sddv_ibfk_2` FOREIGN KEY (`MaNhanVien`) REFERENCES `f1_nhanvien` (`MaNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Sử dụng dịch vụ';

DROP TABLE IF EXISTS `e3_chitietsddv`;
CREATE TABLE `e3_chitietsddv` (
  `MaSDDV` varchar(50) NOT NULL COMMENT 'Mã sử dụng dịch vụ',
  `MaDichVu` varchar(50) NOT NULL COMMENT 'Mã dịch vụ',
  `SoLuongDichVu` int DEFAULT NULL COMMENT 'Số lượng dịch vụ sử dụng',
  PRIMARY KEY (`MaSDDV`,`MaDichVu`),
  KEY `MaDichVu` (`MaDichVu`),
  CONSTRAINT `e3_chitietsddv_ibfk_1` FOREIGN KEY (`MaSDDV`) REFERENCES `e2_sddv` (`MaSDDV`),
  CONSTRAINT `e3_chitietsddv_ibfk_2` FOREIGN KEY (`MaDichVu`) REFERENCES `e1_dichvu` (`MaDichVu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Sử dụng dịch vụ chi tiết';

DROP TABLE IF EXISTS `f1_nhanvien`;
CREATE TABLE `f1_nhanvien` (
  `MaNhanVien` varchar(50) NOT NULL COMMENT 'Mã nhân viên',
  `TenNhanVien` varchar(100) DEFAULT NULL COMMENT 'Tên nhân viên',
  `Sdt` varchar(15) DEFAULT NULL COMMENT 'Số điện thoại',
  `GioiTinh` enum('Nam','Nữ') DEFAULT NULL COMMENT 'Giới tính',
  `ChucVu` varchar(50) DEFAULT NULL COMMENT 'Chức vụ',
  PRIMARY KEY (`MaNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Nhân viên';

SET FOREIGN_KEY_CHECKS = 1;



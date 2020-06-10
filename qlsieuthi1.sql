create database QuanLySieuThi
go
use QuanLySieuThi
go
create table NhanVien
(
	id int identity primary key ,
	hoTen nvarchar(50) not null,
	gioiTinh int ,--(0:N"nữ" , 1:N"nam",2 : N"Khác")
	cmnd varchar(20) ,
	namSinh date ,
	diaChi nvarchar(200) ,
	dienThoai varchar(20) ,
	email varchar(50) ,
	username varchar(100) not null,
	password nvarchar(100) not null,
	status int not null  default 1 --(0 : Deactive, 1 : Active)
)
go
create table Code
(
	id int identity primary key ,
	nhanVienId int,
	ten nvarchar(50) not null,
	code varchar(100) not null,
	parenId int ,
	status int default 1 ,
	foreign key (nhanVienId) references NhanVien(id)

)
go
create table KhachHang
(
	id int identity primary key ,
	nhanVienId int ,
	codeId int not null,--Kiểm tra xem nhà cung cấp hay khách hàng
	hoTen nvarchar(50) not null,
	gioiTinh int ,
	cmnd varchar(20) ,
	namSinh date  ,
	tenCongTy nvarchar(200) ,
	maSoThue varchar(100) ,
	diaChi nvarchar(200) ,
	dienThoai varchar(20) ,
	fax varchar(20) ,
	email varchar(50) ,
	foreign key (nhanVienId) references NhanVien(id),
	foreign key (codeId) references Code(id)
)
go
create table HangHoa
(
	id int identity primary key ,
	nhanVienId int , 
	codeIdLoai int not null,--Loại hàng
	codeIdDvt int not null, --Đơn vị tính 
	ten nvarchar(100) not null,
	thanhPhan nvarchar(200) ,
	giaBan money ,
	giaMua money ,
	nhaSX nvarchar(100) ,
	xuatXu nvarchar(100) ,
	ngayCapNhat date ,
	status int default 1 ,
	foreign key (nhanVienId) references NhanVien (id),
	foreign key (codeIdLoai) references Code(id),
	foreign key (codeIdDvt) references Code(id)
)
go

create table ChungTu
(
	id int identity primary key ,
	nhanVienId int not null,--Nhân viên nhập
	khachHangId int not null,--thông tin khách hàng
	codeId int not null,--kiểm tra xem phiếu nhập hay xuất
	soChungTu varchar(100),
	ngayChungTu date not null,
	nguoiGiao nvarchar(100) not null,
	ngayLap date not null default getdate(),
	vat float not null,
	tongTienSo money not null default 0,
	tongTienChu money not null default 0,
	tienKhachDua money not null default 0,
	tienTraLai money not null default 0,
	diem int not null default 0,
	status int not null default 1 ,
	foreign key (nhanVienId ) references NhanVien(id),
	foreign key (khachHangId) references KhachHang(id),
	foreign key (codeId) references Code(id),
)
go
create table ChiTietChungTu
(
	id int identity primary key ,
	hangHoaId int not null,--chi tiết hàng hóa
	chungTuId int not null,--thông tin chứng từ
	soLuong int not null default 1 ,
	donGia money not null default 0,
	ngaySanXuat date ,
	hanSuDung date ,
	foreign key (hangHoaId) references HangHoa(id),
	foreign key (chungTuId) references ChungTu(id)
)
go
--tạo thủ tục
--lấy danh sách nhân viên
create procedure DanhSachNhanVien
as
begin
--select từng thuộc tính tránh select *
	select id,hoTen,gioiTinh,cmnd,namSinh,diaChi,dienThoai,email,username,password,status from NhanVien
end
--thủ tục thêm nhân viên
go
create procedure ThemNhanVien	
	@hoTen nvarchar(50) null,
	@gioiTinh int=null ,--(0:N"nữ" , 1:N"nam",2 : N"Khác")
	@cmnd varchar(20) =null,
	@namSinh date =null,
	@diaChi nvarchar(200)=null ,
	@dienThoai varchar(20)=null ,
	@email varchar(50)=null ,
	@username varchar(100) =null,
	@password nvarchar(100)= null,
	@status int = null--(0 : Deactive, 1 : Active)
as
begin
	insert into NhanVien(hoTen,gioiTinh,cmnd,namSinh,diaChi,dienThoai,email,username,password,status)
	values (@hoTen,@gioiTinh,@cmnd,@namSinh,@diaChi,@dienThoai,@email,@username,@password,@status)
end

go
--thủ tục chỉnh sửa nhân viên
create procedure SuaNhanVien
	@id int = null,
	@hoTen nvarchar(50) null,
	@gioiTinh int=null ,--(0:N"nữ" , 1:N"nam",2 : N"Khác")
	@cmnd varchar(20) =null,
	@namSinh date =null,
	@diaChi nvarchar(200)=null ,
	@dienThoai varchar(20)=null ,
	@email varchar(50)=null ,
	@username varchar(100) =null,
	@password nvarchar(100)= null,
	@status int = null--(0 : Deactive, 1 : Active)
as
begin
	update NhanVien set hoTen=@hoTen,gioiTinh=@gioiTinh,cmnd=@cmnd,
	namSinh=@namSinh,diaChi=@diaChi,dienThoai=@dienThoai,email=@email,username=@username,password=@password,status=@status
	where id=@id
end
go
--thủ tục xóa nhân viên
create procedure XoaNhanVien
	@id int =null
as
begin
	delete NhanVien where id=@id
end
go
--sử dụng test thủ tục
exec ThemNhanVien N'Trương Tiến Minh',1,'242512424','09/09/1999',N'an biên','0854444396','truongtienminh7@gmail.com','tienminh','123',1
exec DanhSachNhanVien
exec XoaNhanVien 4
exec SuaNhanVien 5,N'Lê Minh Lực',1,'242512424','09/09/1999',N'an biên','0854444396','truongtienminh7@gmail.com','tienminh','123',1
drop procedure DanhSachNhanVien
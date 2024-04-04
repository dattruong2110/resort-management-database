use resort_management;

/* 2. Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 
ký tự */
select *
from employee
where left(name, 1) in ('H', 'T', 'K') and char_length(name) <= 15;

/* 3. Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Sài Gòn” hoặc “Quảng Nam” */
select * 
from customer c
where year(c.dob) between 1974 and 2006 
and (c.address = 'Sài Gòn' or 'Quảng Nam');

/* 4. Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt 
phòng của khách hàng. Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond” */
select c.id, c.name, count(ctr.id) number_of_bookings
from contract ctr
join customer c on ctr.customer_id = c.id
join customer_type ct on c.customer_type_id = ct.id
where ct.name = 'Diamond';

/* 5. Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien (Với tổng tiền 
được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) cho 
tất cả các khách hàng đã từng đặt phòng. (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra) */
select c.id customer_id, c.name as customer_name, ct.name, ctr.id contract_id, f.name facility_name, ctr.start_date, ctr.end_date, sum((ctr.deposit + cd.quantity) * af.cost) total_cost
from customer c
join customer_type ct on c.customer_type_id = ct.id
join contract ctr on c.id = ctr.customer_id
join facility f on ctr.facility_id = f.id
join contract_detail cd on ctr.id = cd.contract_id
join attach_facility af on cd.attach_facility_id = af.id
group by c.id, ctr.id;

/* 6. Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu của tất cả các loại dịch vụ chưa từng được khách hàng 
thực hiện đặt từ quý 1 của năm 2023 (Quý 1 là tháng 1, 2, 3) */
select f.id, f.name facility_name, f.area, f.cost, ft.name facility_type_name
from facility f
join facility_type ft on f.facility_type_id = ft.id
join contract ctr on f.id = ctr.facility_id
where year(ctr.start_date) and year(ctr.end_date) >= 2023 and quarter(ctr.start_date) and quarter(ctr.end_date) = 1;

/* 7. Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu của tất cả các loại dịch 
vụ đã từng được khách hàng đặt phòng trong năm 2022 nhưng chưa từng được khách hàng đặt phòng trong năm 2023 */
select distinct f.id, f.name facility_name, f.area, f.max_people, f.cost, ft.name facility_type_name
from facility f
join facility_type ft on f.facility_type_id = ft.id
join contract ctr on f.id = ctr.facility_id 
where ((ctr.start_date >= '2022-01-01' and ctr.start_date <= '2022-12-31') or (ctr.end_date <= '2022-12-31' and ctr.end_date >= '2022-01-01' ))
and not ((ctr.start_date >= '2023-01-01' and ctr.start_date <= '2023-12-31') or (ctr.end_date <= '2023-12-31' and ctr.end_date >= '2023-01-01' ));

/* 8. Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau. Học viên sử dụng theo 3 cách khác 
nhau để thực hiện yêu cầu trên */
-- method 1 --
select distinct name customer_name
from customer;
-- method 2 --
select name customer_name
from customer
group by name;
-- method 3 --
SELECT customer_name
FROM (
    SELECT name AS customer_name, ROW_NUMBER() OVER (PARTITION BY name ORDER BY name) AS rn
    FROM customer
) AS sub
WHERE rn = 1;

/* 9. Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi tháng trong năm 2022 thì sẽ có bao nhiêu khách hàng thực hiện 
đặt phòng */
select month(ctr.start_date) start_month, month(ctr.end_date) end_month, count(distinct ctr.id) number_of_customers, sum((ctr.deposit + cd.quantity) * af.cost) total_cost
from contract ctr
join customer c on ctr.customer_id = c.id
join facility f on ctr.facility_id = f.id
join contract_detail cd on ctr.id = cd.contract_id
join attach_facility af on cd.attach_facility_id = af.id
where year(ctr.start_date) and year(ctr.end_date) = 2022
group by month(ctr.start_date), month(ctr.end_date);

/* 10. Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm. Kết quả hiển thị bao gồm ma_hop_dong, 
ngay_lam_hop_dong,ngay_ket_thuc,tien_dat_coc,so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở dich_vu_di_kem) */
select ctr.id, ctr.start_date, ctr.end_date, ctr.deposit, sum(cd.quantity) number_of_attached_services
from contract ctr
join contract_detail cd on ctr.id = cd.contract_id
group by ctr.id, ctr.start_date, ctr.end_date, ctr.deposit;

/* 11. Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách hàng có ten_loai_khach là “Gold” và có dia_chi ở “Vinh” 
hoặc “Quảng Ngãi”. */
select c.name customer_name, ct.name customer_type, c.address, af.name attach_facility_name
from customer c
join customer_type ct on c.customer_type_id = ct.id
join contract ctr on c.id = ctr.customer_id
join contract_detail cd on ctr.id = cd.contract_id
join attach_facility af on cd.attach_facility_id = af.id
where ct.id = 3 and c.address = 'Quảng Ngãi';

/* 12. Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), so_dien_thoai (khách hàng), ten_dich_vu, 
so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở dich_vu_di_kem), tien_dat_coc của tất cả các dịch vụ đã từng được khách 
hàng đặt vào 3 tháng cuối năm 2022 nhưng chưa từng được khách hàng đặt vào 6 tháng đầu năm 2023 */
select ctr.id, e.name employee_name, c.name customer_name, c.phone_number, f.name facility_name, sum(cd.quantity) number_of_attached_services, sum((ctr.deposit + cd.quantity) * af.cost) total_cost
from contract ctr
join employee e on ctr.employee_id = e.id
join customer c on ctr.customer_id = c.id
join facility f on ctr.facility_id = f.id
join contract_detail cd on ctr.id = cd.contract_id
join attach_facility af on cd.attach_facility_id = af.id
where 
	year(ctr.start_date) and year(ctr.end_date) = 2022 and quarter(ctr.start_date) and quarter(ctr.end_date) = 4
    and ctr.id not in (
		select id
        from contract
        where year(start_date) and year(ctr.end_date) = 2023 and quarter(start_date) and quarter(ctr.end_date) in (1, 2)
    )
group by ctr.id, e.name, c.name, c.phone_number, f.name;

/* 13. Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi các Khách hàng đã đặt phòng. (Lưu ý là có thể có nhiều dịch vụ 
có số lần sử dụng nhiều như nhau) */
select attach_facility_name, max(total_quantity) max_quantity
from (
	select af.name attach_facility_name, sum(cd.quantity) total_quantity
	from attach_facility af
	join contract_detail cd on af.id = cd.attach_facility_id
	join contract ctr on cd.contract_id = ctr.id
	group by af.name
) as subquery;

/* 14. Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một lần duy nhất. Thông tin hiển thị bao gồm ma_hop_dong, 
ten_loai_dich_vu, ten_dich_vu_di_kem, so_lan_su_dung (được tính dựa trên việc count các ma_dich_vu_di_kem) */
select ctr.id, f.name facility_name, af.name attach_facility_name, count(cd.quantity) number_of_quantity
from attach_facility af
join contract_detail cd on af.id = cd.attach_facility_id
join contract ctr on cd.contract_id = ctr.id
join facility f on ctr.facility_id = f.id
group by ctr.id, f.name, af.name
having count(cd.quantity) <= 1;

/* 15. Hiển thị thông tin của tất cả nhân viên bao gồm ma_nhan_vien, ho_ten, ten_trinh_do, ten_bo_phan, so_dien_thoai, dia_chi mới chỉ 
lập được tối đa 3 hợp đồng từ năm 2022 đến 2023 */
select e.id, e.name employee_name, ed.name education_degree_name, d.name division_name, e.phone_number, e.address
from employee e
join education_degree ed on e.education_degree_id = ed.id
join division d on e.division_id = d.id
join contract ctr on ctr.employee_id = e.id
where year(ctr.start_date) and year(ctr.end_date) between 2022 and 2023
		and not (year(ctr.start_date) and year(ctr.end_date) < 2022 or year(ctr.start_date) and year(ctr.end_date) > 2023)
        and e.is_deleted = 0 
group by e.id
having count(e.id) >= 3;

/* 16. Xóa những Nhân viên chưa từng lập được hợp đồng nào từ năm 2022 đến năm 2023 */
SET SQL_SAFE_UPDATES = 0;
update employee e
left join (
		select employee_id
        from contract
        where year(start_date) between 2022 and 2023
			or year (end_date) > 2023
) ctr on e.id = ctr.employee_id
set e.is_deleted = 1
where ctr.employee_id is null
		and e.is_deleted = 0;
SET SQL_SAFE_UPDATES = 1;

select * from employee;

/* 17. Cập nhật thông tin những khách hàng có ten_loai_khach từ Platinum lên Diamond, chỉ cập nhật những khách hàng đã từng đặt phòng 
với Tổng Tiền thanh toán trong năm 2022 là lớn hơn 10.000.000 VNĐ */
SET SQL_SAFE_UPDATES = 0;
update customer c
join (
    select c.id, sum((ctr.deposit + cd.quantity) * af.cost) total_cost
    from customer c
    join contract ctr ON c.id = ctr.customer_id
    join contract_detail cd ON ctr.id = cd.contract_id
    join attach_facility af ON cd.attach_facility_id = af.id
    where year(ctr.start_date) and year(ctr.end_date) = 2022
    group by c.id
    having sum((ctr.deposit + cd.quantity) * af.cost) >= 10000000
) as subquery on c.id = subquery.id
set c.customer_type_id = (
    select id
    from customer_type
    where name = 'Diamond'
);
SET SQL_SAFE_UPDATES = 1;

select c.id, c.name customer_name, ct.name customer_type_name
from customer c
join customer_type ct on c.customer_type_id = ct.id;

/* 18. Xóa những khách hàng có hợp đồng trước năm 2022 (chú ý ràng buộc giữa các bảng) */
SET SQL_SAFE_UPDATES = 0;
update customer c
join contract ctr on ctr.customer_id = c.id
set c.is_deleted = 1
where year(ctr.start_date) and year(ctr.end_date) < 2022;
SET SQL_SAFE_UPDATES = 1;

select * 
from customer c
join contract ctr on ctr.customer_id = c.id
where year(ctr.start_date) and year(ctr.end_date) < 2022;

/* 19. Cập nhật giá cho các dịch vụ đi kèm được sử dụng trên 10 lần trong năm 2022 lên gấp đôi */
SET SQL_SAFE_UPDATES = 0;
update attach_facility af
join contract_detail cd on af.id = cd.contract_id
join contract ctr on cd.contract_id = ctr.id
set af.cost = af.cost * 2
where cd.quantity >= 10 and year(ctr.start_date) and year(ctr.end_date) = 2022;
SET SQL_SAFE_UPDATES = 1;

select * from attach_facility;

/* 20. Hiển thị thông tin của tất cả các nhân viên và khách hàng có trong hệ thống, thông tin hiển thị bao gồm id (ma_nhan_vien, 
ma_khach_hang), ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi */
select e.id employee_id, e.name employee_name, e.email employee_email, e.phone_number employee_phone_number, 
e.dob employee_date_of_birth, e.address employee_address, c.id customer_id, c.name customer_name, c.email customer_email,
c.phone_number customer_phone_number, c.dob customer_date_of_birth, c.address customer_address
from contract ctr
join employee e on ctr.employee_id = e.id
join customer c on ctr.customer_id = c.id;

/* 21. Tạo View có tên là v_nhan_vien để lấy được thông tin của tất cả các nhân viên có địa chỉ là “Sài Gòn” và đã từng lập hợp đồng 
cho một hoặc nhiều khách hàng bất kì với ngày lập hợp đồng là “12/12/2022” */
create view v_nhan_vien as
select e.*
from employee e
join contract ctr on ctr.employee_id = e.id
where year(ctr.start_date) = 2022 
		and month(ctr.start_date) = 12 
		and day(ctr.start_date) = 12 
		and e.address = 'Sài Gòn';

/* 22. Thông qua khung nhìn v_nhan_vien thực hiện cập nhật địa chỉ thành “Phú Nhuận” đối với tất cả các nhân viên được nhìn thấy bởi 
khung nhìn này */
SET SQL_SAFE_UPDATES  = 0;
update v_nhan_vien
set address = 'Phú Nhuận'
where id;
SET SQL_SAFE_UPDATES = 1;

select * from v_nhan_vien;

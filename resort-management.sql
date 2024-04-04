create database resort_management;
use resort_management;

CREATE TABLE rent_type (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(45),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE facility_type (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(45),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE facility (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    area INT,
    cost DOUBLE,
    max_people INT,
    rent_type_id INT,
    facility_type_id INT,
    standard_room VARCHAR(45),
    description_other_convenience VARCHAR(45),
    pool_area DOUBLE,
    number_of_floors INT,
    facility_free TEXT,
    is_deleted BIT(1) DEFAULT 0,
    FOREIGN KEY (rent_type_id)
        REFERENCES rent_type (id),
    FOREIGN KEY (facility_type_id)
        REFERENCES facility_type (id)
);

CREATE TABLE job_position (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(45),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE division (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(45),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE education_degree (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(45),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE role (
    role_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(255),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE user (
    user_name VARCHAR(255) PRIMARY KEY NOT NULL,
    password VARCHAR(255),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE user_role (
    role_id INT NOT NULL AUTO_INCREMENT,
    user_name VARCHAR(255) NOT NULL,
    is_deleted BIT(1) DEFAULT 0,
    PRIMARY KEY (role_id , user_name),
    FOREIGN KEY (role_id)
        REFERENCES role (role_id),
    FOREIGN KEY (user_name)
        REFERENCES user (user_name)
);

CREATE TABLE employee (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(55),
    dob VARCHAR(50),
    id_card VARCHAR(12),
    salary DOUBLE,
    phone_number VARCHAR(12),
    email VARCHAR(45),
    address VARCHAR(50),
    position_id INT,
    education_degree_id INT,
    division_id INT,
    user_name VARCHAR(255),
    is_deleted BIT(1) DEFAULT 0,
    FOREIGN KEY (position_id)
        REFERENCES job_position (id),
    FOREIGN KEY (education_degree_id)
        REFERENCES education_degree (id),
    FOREIGN KEY (division_id)
        REFERENCES division (id),
    FOREIGN KEY (user_name)
        REFERENCES user (user_name)
);

CREATE TABLE customer_type (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE customer (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    customer_type_id INT,
    name VARCHAR(50),
    gender BIT(1) DEFAULT 0,
    dob VARCHAR(50),
    id_card VARCHAR(12),
    phone_number VARCHAR(12),
    email VARCHAR(45),
    address VARCHAR(50),
    is_deleted BIT(1) DEFAULT 0,
    FOREIGN KEY (customer_type_id)
        REFERENCES customer_type (id)
);

CREATE TABLE attach_facility (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(45),
    cost DOUBLE,
    unit VARCHAR(10),
    status VARCHAR(45),
    is_deleted BIT(1) DEFAULT 0
);

CREATE TABLE contract (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    start_date DATETIME,
    end_date DATETIME,
    deposit DOUBLE,
    employee_id INT,
    customer_id INT,
    facility_id INT,
    is_deleted BIT(1) DEFAULT 0,
    FOREIGN KEY (employee_id)
        REFERENCES employee (id),
    FOREIGN KEY (customer_id)
        REFERENCES customer (id),
    FOREIGN KEY (facility_id)
        REFERENCES facility (id)
);

CREATE TABLE contract_detail (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    contract_id INT,
    attach_facility_id INT,
    quantity INT,
    is_deleted BIT(1) DEFAULT 0,
    FOREIGN KEY (contract_id)
        REFERENCES contract (id),
    FOREIGN KEY (attach_facility_id)
        REFERENCES attach_facility (id)
);

/* Thêm mới thông tin cho tất cả các bảng có trong CSDL */
INSERT INTO rent_type (name) 
VALUES
('Year'),
('Month'),
('Day'),
('Hours');

INSERT INTO facility_type (name)
VALUES
('Villa'),
('House'),
('Room');

INSERT INTO job_position (name) 
VALUES
('Receptionist'),
('Waiters'),
('Expert'),
('Monitor'),
('Manager'),
('Director');

INSERT INTO division (name) 
VALUES
('Sale – Marketing'),
('Administration'),
('Staff'),
('Manager');

INSERT INTO education_degree (name) 
VALUES
('Intermediate'),
('College'),
('University'),
('Postgraduate degree');

INSERT INTO role (role_name) 
VALUES
('Admin'),
('Employee'),
('Customer');

INSERT INTO customer_type (name) 
VALUES
('Diamond'),
('Platinium'),
('Gold'),
('Silver'),
('Member');

INSERT INTO user (user_name, password) 
VALUES
('admin', 'adminpassword');

INSERT INTO user_role (user_name) VALUES
('Admin');

INSERT INTO attach_facility (name, cost, unit, status) 
VALUES
('Massage', 70.00, 'Hour', 'Available'),
('Karaoke', 50.00, 'Hour', 'Available'),
('Food', 20.00, 'Part', 'Available'),
('Drink', 20.00, 'Part', 'Available'),
('Rent a car to visit the resort', 100.00, 'Trip', 'Available');

INSERT INTO customer (customer_type_id, name, dob, id_card, phone_number, email, address) 
VALUES
(1, 'Đạt', '2000-10-21', '1811060165', '0784727487', 'tandattruong2110@gmail.com', 'Sài Gòn'),
(2, 'Nguyễn', '2001-01-01', '1921068372', '0907782645', 'nguyenhuynh@gmail.com', 'Quảng Nam'),
(3, 'Đức', '1999-01-01', '1711872845', '0987637245', 'anhduc@gmail.com', 'Sài Gòn'),
(4, 'Tuấn', '2000-03-03', '1813909824', '0772874835', 'anhtuan@gmail.com', 'Quảng Nam'),
(5, 'Phát', '1970-02-27', '1677890294', '0898765498', 'phathuynh@gmail.com', 'Sài Gòn');

INSERT INTO employee (name, dob, id_card, salary, phone_number, email, address, position_id, education_degree_id, division_id, user_name) 
VALUES
('Michael Johnson', '1980-02-10', 'XYZ123456', 40000.00, '555-1234', 'michael@example.com', '789 Elm Street', 1, 3, 1, 'Admin'),
('Emily Davis', '1995-07-25', 'GHT987654', 40000.00, '555-5678', 'emily@example.com', '321 Oak Avenue', 2, 3, 2, 'Admin');

INSERT INTO facility (name, area, cost, max_people, rent_type_id, facility_type_id, standard_room, description_other_convenience, pool_area, number_of_floors, facility_free) 
VALUES
('Penthouses', 50, 700.00, 2, 1, 3, 'Single Bed', 'Balcony with sea view', 20.00, 3, 'Breakfast included'),
('Standard Room', 30, 400.00, 2, 1, 2, 'Single Bed', 'Private room', 20.00, 0, 'Breakfast included'),
('Private Villa', 200, 1000.00, 6, 2, 1, 'Three Bedrooms', 'Private pool and garden', 50.00, 3, '24/7 Butler service');

INSERT INTO contract (start_date, end_date, deposit, employee_id, customer_id, facility_id) 
VALUES
('2021-08-11', '2021-08-15', 1000000.00, 10, 5, 1),
('2021-11-11', '2021-11-15', 600.00, 7, 5, 1),
('2022-03-08', '2022-03-14', 2000000.00, 7, 1, 2),
('2021-11-11', '2021-11-15', 600.00, 9, 5, 1),
('2023-03-15', '2023-03-20', 100.00, 3, 1, 2),
('2023-03-25', '2023-03-25', 100.00, 3, 5, 3),
('2024-04-01', '2024-04-07', 200.00, 4, 2, 1);

INSERT INTO contract_detail (contract_id, attach_facility_id, quantity) 
VALUES
(5, 1, 2),
(5, 3, 1),
(6, 3, 1),
(13, 3, 7),
(14, 5, 2),
(15, 3, 5),
(16, 4, 6);


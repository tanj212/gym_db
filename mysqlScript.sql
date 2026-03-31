/*
  Gym Management System - MySQL Script
  DBA Task
*/


CREATE DATABASE IF NOT EXISTS gym_db;
USE gym_db;


CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    phone VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    trainer_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);


CREATE TABLE subscriptions (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    type VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);


CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    check_in_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

INSERT INTO trainers (full_name, specialization, phone) VALUES 
('Bat-Erdene', 'Bodybuilding', '99112233'),
('Saruul', 'Yoga', '88001122');

INSERT INTO members (first_name, last_name, email, trainer_id) VALUES 
('Bold', 'Tumur', 'bold@mail.com', 1),
('Anu', 'Ganbaatar', 'anu@mail.com', 1),
('Dorj', 'Bat', 'dorj@mail.com', 2);

INSERT INTO subscriptions (member_id, type, start_date, price) VALUES 
(1, 'Monthly', '2024-03-01', 150000),
(2, 'Yearly', '2024-01-15', 1200000),
(3, 'Monthly', '2024-03-05', 150000);

INSERT INTO attendance (member_id) VALUES (1), (1), (2), (3), (3);


SELECT m.first_name, m.last_name, t.full_name AS trainer, s.type
FROM members m
JOIN trainers t ON m.trainer_id = t.trainer_id
JOIN subscriptions s ON m.member_id = s.member_id;


SELECT t.full_name, COUNT(m.member_id) AS total_members
FROM trainers t
LEFT JOIN members m ON t.trainer_id = m.trainer_id
GROUP BY t.full_name;


SELECT t.full_name, COUNT(m.member_id) AS member_count
FROM trainers t
JOIN members m ON t.trainer_id = m.trainer_id
GROUP BY t.full_name
ORDER BY member_count DESC LIMIT 1;


SELECT m.first_name, COUNT(a.attendance_id) AS visits
FROM members m
JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_id
HAVING visits >= 2;

CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin123!';
GRANT ALL PRIVILEGES ON gym_db.* TO 'admin_user'@'localhost';

CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'Report123!';
GRANT SELECT ON gym_db.* TO 'report_user'@'localhost';

FLUSH PRIVILEGES;


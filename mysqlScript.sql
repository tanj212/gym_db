CREATE DATABASE gym_db;
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
    phone VARCHAR(15),
    trainer_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) ON DELETE SET NULL
);
CREATE TABLE subscriptions (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    type VARCHAR(20) NOT NULL, -- Жишээ нь: 'Monthly', 'Yearly'
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    amount DECIMAL(10, 2) CHECK (amount > 0),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    check_in_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

INSERT INTO trainers (full_name, specialization, phone) VALUES 
('Бат-Эрдэнэ', 'Бодибилдинг', '99112233'),
('Саруул', 'Йога', '88112233'),
('Тэмүүлэн', 'Кардио', '95112233');

INSERT INTO members (first_name, last_name, email, phone, trainer_id) VALUES 
('Дорж', 'Баяр', 'dorj@gmail.com', '90001111', 1),
('Болд', 'Ган', 'bold@gmail.com', '90002222', 1),
('Ану', 'Цэцэг', 'anu@gmail.com', '90003333', 2),
('Хүслэн', 'Энх', 'huslen@gmail.com', '90004444', NULL);

INSERT INTO subscriptions (member_id, type, start_date, end_date, amount) VALUES 
(1, 'Monthly', '2024-03-01', '2024-04-01', 150000),
(2, 'Yearly', '2024-01-01', '2025-01-01', 1200000),
(3, 'Monthly', '2024-03-15', '2024-04-15', 180000);

INSERT INTO attendance (member_id, check_in_time) VALUES 
(1, '2024-03-01 08:00:00'),
(1, '2024-03-03 08:30:00'),
(2, '2024-03-01 10:00:00'),
(3, '2024-03-02 18:00:00'),
(3, '2024-03-04 18:00:00');
SELECT m.first_name, m.last_name, t.full_name AS trainer_name, s.type, s.amount
FROM members m
LEFT JOIN trainers t ON m.trainer_id = t.trainer_id
JOIN subscriptions s ON m.member_id = s.member_id;

SELECT t.full_name, COUNT(m.member_id) AS member_count
FROM trainers t
LEFT JOIN members m ON t.trainer_id = m.trainer_id
GROUP BY t.full_name;

SELECT t.full_name, COUNT(m.member_id) AS member_count
FROM trainers t
JOIN members m ON t.trainer_id = m.trainer_id
GROUP BY t.full_name
ORDER BY member_count DESC
LIMIT 1;

SELECT m.first_name, m.last_name, COUNT(a.attendance_id) AS visit_count
FROM members m
JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_id
HAVING visit_count >= 2;
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON gym_db.* TO 'admin_user'@'localhost';
CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'ReportPass123!';
GRANT SELECT ON gym_db.* TO 'report_user'@'localhost';
SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'report_user'@'localhost';
FLUSH PRIVILEGES;

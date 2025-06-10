-- ================================================================
-- База данных для ИС точки проката "Игора"
-- Кодировка: utf8mb4_unicode_ci
-- СУБД: MariaDB/MySQL
-- ================================================================

-- Создание базы данных
CREATE DATABASE IF NOT EXISTS `igora` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `igora`;

-- ================================================================
-- СОЗДАНИЕ ТАБЛИЦ
-- ================================================================

-- 1. Роли пользователей
CREATE TABLE `Roles` (
    `role_id` INT AUTO_INCREMENT PRIMARY KEY,
    `role_name` VARCHAR(50) UNIQUE NOT NULL,
    `role_description` TEXT,
    `permissions` JSON
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Пользователи системы
CREATE TABLE `Users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `login` VARCHAR(50) UNIQUE NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `middle_name` VARCHAR(100),
    `role_id` INT NOT NULL,
    `photo_path` VARCHAR(500),
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Клиенты
CREATE TABLE `Clients` (
    `client_id` INT AUTO_INCREMENT PRIMARY KEY,
    `client_code` VARCHAR(20) UNIQUE NOT NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `middle_name` VARCHAR(100),
    `email` VARCHAR(255) UNIQUE,
    `phone` VARCHAR(20),
    `address` TEXT,
    `birth_date` DATE,
    `passport_series` VARCHAR(10),
    `passport_number` VARCHAR(20),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Категории оборудования
CREATE TABLE `Equipment_Categories` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL,
    `category_description` TEXT,
    `is_active` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Оборудование
CREATE TABLE `Equipment` (
    `equipment_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `brand` VARCHAR(100),
    `model` VARCHAR(100),
    `size` VARCHAR(20),
    `condition_status` ENUM('excellent', 'good', 'satisfactory', 'needs_repair') DEFAULT 'excellent',
    `purchase_date` DATE,
    `last_maintenance_date` DATE,
    `is_available` BOOLEAN DEFAULT TRUE,
    `barcode` VARCHAR(255) UNIQUE,
    `notes` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Услуги проката
CREATE TABLE `Services` (
    `service_id` INT AUTO_INCREMENT PRIMARY KEY,
    `service_name` VARCHAR(200) NOT NULL,
    `service_description` TEXT,
    `category_id` INT,
    `hourly_rate` DECIMAL(10,2) NOT NULL,
    `daily_rate` DECIMAL(10,2),
    `deposit_amount` DECIMAL(10,2),
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Заказы
CREATE TABLE `Orders` (
    `order_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_number` VARCHAR(50) UNIQUE NOT NULL,
    `client_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `order_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    `total_amount` DECIMAL(12,2) NOT NULL DEFAULT 0,
    `deposit_amount` DECIMAL(10,2),
    `status` ENUM('active', 'completed', 'cancelled', 'archived') DEFAULT 'active',
    `barcode` VARCHAR(255) UNIQUE,
    `notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Услуги в заказе
CREATE TABLE `Order_Services` (
    `order_service_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `service_id` INT NOT NULL,
    `equipment_id` INT,
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(10,2) NOT NULL,
    `total_price` DECIMAL(10,2) NOT NULL,
    `rental_hours` INT,
    `notes` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Возврат оборудования
CREATE TABLE `Equipment_Returns` (
    `return_id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `equipment_id` INT NOT NULL,
    `returned_by_user_id` INT NOT NULL,
    `return_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `condition_on_return` ENUM('excellent', 'good', 'satisfactory', 'damaged') DEFAULT 'good',
    `damage_description` TEXT,
    `additional_charges` DECIMAL(10,2) DEFAULT 0,
    `notes` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. История входов
CREATE TABLE `Login_History` (
    `history_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_login` VARCHAR(50) NOT NULL,
    `attempt_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `is_successful` BOOLEAN NOT NULL,
    `ip_address` VARCHAR(45),
    `user_agent` TEXT,
    `failure_reason` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. Управление сеансами
CREATE TABLE `Session_Management` (
    `session_id` VARCHAR(255) PRIMARY KEY,
    `user_id` INT NOT NULL,
    `login_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `last_activity` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `session_duration_minutes` INT DEFAULT 150,
    `is_active` BOOLEAN DEFAULT TRUE,
    `logout_time` TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. Расходные материалы
CREATE TABLE `Consumables` (
    `consumable_id` INT AUTO_INCREMENT PRIMARY KEY,
    `item_name` VARCHAR(200) NOT NULL,
    `item_description` TEXT,
    `unit_of_measure` VARCHAR(20),
    `current_stock` DECIMAL(10,2) NOT NULL DEFAULT 0,
    `minimum_stock` DECIMAL(10,2) DEFAULT 0,
    `unit_cost` DECIMAL(10,2),
    `supplier` VARCHAR(200),
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_active` BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. Движение расходных материалов
CREATE TABLE `Consumable_Transactions` (
    `transaction_id` INT AUTO_INCREMENT PRIMARY KEY,
    `consumable_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `transaction_type` ENUM('receipt', 'consumption', 'writeoff') NOT NULL,
    `quantity` DECIMAL(10,2) NOT NULL,
    `transaction_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `reason` TEXT,
    `document_number` VARCHAR(100),
    `notes` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 14. Кэш отчетов
CREATE TABLE `Reports_Cache` (
    `cache_id` INT AUTO_INCREMENT PRIMARY KEY,
    `report_type` VARCHAR(100) NOT NULL,
    `parameters_hash` VARCHAR(255) NOT NULL,
    `report_data` LONGTEXT,
    `file_path` VARCHAR(500),
    `generated_by_user_id` INT NOT NULL,
    `generated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expires_at` TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- СОЗДАНИЕ ВНЕШНИХ КЛЮЧЕЙ
-- ================================================================

-- Users → Roles
ALTER TABLE `Users` 
ADD CONSTRAINT `FK_Users_Roles` 
FOREIGN KEY (`role_id`) REFERENCES `Roles`(`role_id`);

-- Equipment → Equipment_Categories
ALTER TABLE `Equipment` 
ADD CONSTRAINT `FK_Equipment_Categories` 
FOREIGN KEY (`category_id`) REFERENCES `Equipment_Categories`(`category_id`);

-- Services → Equipment_Categories
ALTER TABLE `Services` 
ADD CONSTRAINT `FK_Services_Categories` 
FOREIGN KEY (`category_id`) REFERENCES `Equipment_Categories`(`category_id`);

-- Orders → Clients
ALTER TABLE `Orders` 
ADD CONSTRAINT `FK_Orders_Clients` 
FOREIGN KEY (`client_id`) REFERENCES `Clients`(`client_id`);

-- Orders → Users
ALTER TABLE `Orders` 
ADD CONSTRAINT `FK_Orders_Users` 
FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`);

-- Order_Services → Orders
ALTER TABLE `Order_Services` 
ADD CONSTRAINT `FK_OrderServices_Orders` 
FOREIGN KEY (`order_id`) REFERENCES `Orders`(`order_id`) ON DELETE CASCADE;

-- Order_Services → Services
ALTER TABLE `Order_Services` 
ADD CONSTRAINT `FK_OrderServices_Services` 
FOREIGN KEY (`service_id`) REFERENCES `Services`(`service_id`);

-- Order_Services → Equipment
ALTER TABLE `Order_Services` 
ADD CONSTRAINT `FK_OrderServices_Equipment` 
FOREIGN KEY (`equipment_id`) REFERENCES `Equipment`(`equipment_id`);

-- Equipment_Returns → Orders
ALTER TABLE `Equipment_Returns` 
ADD CONSTRAINT `FK_Returns_Orders` 
FOREIGN KEY (`order_id`) REFERENCES `Orders`(`order_id`);

-- Equipment_Returns → Equipment
ALTER TABLE `Equipment_Returns` 
ADD CONSTRAINT `FK_Returns_Equipment` 
FOREIGN KEY (`equipment_id`) REFERENCES `Equipment`(`equipment_id`);

-- Equipment_Returns → Users
ALTER TABLE `Equipment_Returns` 
ADD CONSTRAINT `FK_Returns_Users` 
FOREIGN KEY (`returned_by_user_id`) REFERENCES `Users`(`user_id`);

-- Session_Management → Users
ALTER TABLE `Session_Management` 
ADD CONSTRAINT `FK_Sessions_Users` 
FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`);

-- Consumable_Transactions → Consumables
ALTER TABLE `Consumable_Transactions` 
ADD CONSTRAINT `FK_Transactions_Consumables` 
FOREIGN KEY (`consumable_id`) REFERENCES `Consumables`(`consumable_id`);

-- Consumable_Transactions → Users
ALTER TABLE `Consumable_Transactions` 
ADD CONSTRAINT `FK_Transactions_Users` 
FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`);

-- Reports_Cache → Users
ALTER TABLE `Reports_Cache` 
ADD CONSTRAINT `FK_Reports_Users` 
FOREIGN KEY (`generated_by_user_id`) REFERENCES `Users`(`user_id`);

-- ================================================================
-- СОЗДАНИЕ ИНДЕКСОВ ДЛЯ ОПТИМИЗАЦИИ
-- ================================================================

-- Поиск клиентов
CREATE INDEX `idx_clients_email` ON `Clients`(`email`);
CREATE INDEX `idx_clients_phone` ON `Clients`(`phone`);
CREATE INDEX `idx_clients_name` ON `Clients`(`last_name`, `first_name`);
CREATE INDEX `idx_clients_code` ON `Clients`(`client_code`);

-- Поиск заказов
CREATE INDEX `idx_orders_date` ON `Orders`(`order_date`);
CREATE INDEX `idx_orders_status` ON `Orders`(`status`);
CREATE INDEX `idx_orders_number` ON `Orders`(`order_number`);
CREATE INDEX `idx_orders_client` ON `Orders`(`client_id`, `order_date`);

-- История входов
CREATE INDEX `idx_login_history_time` ON `Login_History`(`attempt_time`);
CREATE INDEX `idx_login_history_user` ON `Login_History`(`user_login`);
CREATE INDEX `idx_login_history_success` ON `Login_History`(`is_successful`, `attempt_time`);

-- Оборудование
CREATE INDEX `idx_equipment_available` ON `Equipment`(`is_available`);
CREATE INDEX `idx_equipment_category` ON `Equipment`(`category_id`);
CREATE INDEX `idx_equipment_barcode` ON `Equipment`(`barcode`);

-- Услуги в заказе
CREATE INDEX `idx_order_services_order` ON `Order_Services`(`order_id`);
CREATE INDEX `idx_order_services_service` ON `Order_Services`(`service_id`);

-- Возврат оборудования
CREATE INDEX `idx_returns_date` ON `Equipment_Returns`(`return_date`);
CREATE INDEX `idx_returns_order` ON `Equipment_Returns`(`order_id`);

-- Сеансы
CREATE INDEX `idx_sessions_active` ON `Session_Management`(`is_active`, `last_activity`);
CREATE INDEX `idx_sessions_user` ON `Session_Management`(`user_id`);

-- ================================================================
-- CHECK-ОГРАНИЧЕНИЯ
-- ================================================================

-- Проверка дат в заказах
ALTER TABLE `Orders` 
ADD CONSTRAINT `chk_orders_dates` 
CHECK (`end_date` > `start_date`);

-- Проверка положительных сумм
ALTER TABLE `Orders` 
ADD CONSTRAINT `chk_orders_amount` 
CHECK (`total_amount` >= 0);

ALTER TABLE `Order_Services` 
ADD CONSTRAINT `chk_orderservices_quantity` 
CHECK (`quantity` > 0);

ALTER TABLE `Order_Services` 
ADD CONSTRAINT `chk_orderservices_price` 
CHECK (`unit_price` >= 0 AND `total_price` >= 0);

-- Проверка остатков материалов
ALTER TABLE `Consumables` 
ADD CONSTRAINT `chk_consumables_stock` 
CHECK (`current_stock` >= 0 AND `minimum_stock` >= 0);

-- ================================================================
-- СОЗДАНИЕ ПРЕДСТАВЛЕНИЙ (VIEWS)
-- ================================================================

-- Активные заказы
CREATE VIEW `v_active_orders` AS
SELECT 
    o.order_id,
    o.order_number,
    CONCAT(c.last_name, ' ', c.first_name) as client_name,
    c.phone,
    o.start_date,
    o.end_date,
    o.total_amount,
    o.status
FROM `Orders` o
JOIN `Clients` c ON o.client_id = c.client_id
WHERE o.status = 'active';

-- Статистика по дням
CREATE VIEW `v_daily_statistics` AS
SELECT 
    DATE(order_date) as order_day,
    COUNT(*) as orders_count,
    SUM(total_amount) as daily_revenue,
    COUNT(DISTINCT client_id) as unique_clients
FROM `Orders`
WHERE status != 'cancelled'
GROUP BY DATE(order_date);

-- Популярные услуги
CREATE VIEW `v_popular_services` AS
SELECT 
    s.service_name,
    COUNT(os.order_service_id) as booking_count,
    SUM(os.total_price) as total_revenue,
    AVG(os.unit_price) as avg_price
FROM `Services` s
JOIN `Order_Services` os ON s.service_id = os.service_id
JOIN `Orders` o ON os.order_id = o.order_id
WHERE o.status != 'cancelled'
GROUP BY s.service_id, s.service_name
ORDER BY booking_count DESC;

-- ================================================================
-- ТРИГГЕРЫ ДЛЯ БИЗНЕС-ЛОГИКИ
-- ================================================================

-- Обновление остатков оборудования
DELIMITER //
CREATE TRIGGER `tr_update_equipment_availability`
AFTER INSERT ON `Order_Services`
FOR EACH ROW
BEGIN
    IF NEW.equipment_id IS NOT NULL THEN
        UPDATE `Equipment` 
        SET is_available = FALSE 
        WHERE equipment_id = NEW.equipment_id;
    END IF;
END//
DELIMITER ;

-- Возврат оборудования
DELIMITER //
CREATE TRIGGER `tr_return_equipment`
AFTER INSERT ON `Equipment_Returns`
FOR EACH ROW
BEGIN
    UPDATE `Equipment` 
    SET is_available = TRUE,
        condition_status = NEW.condition_on_return
    WHERE equipment_id = NEW.equipment_id;
    
    UPDATE `Orders` 
    SET status = 'completed'
    WHERE order_id = NEW.order_id;
END//
DELIMITER ;

-- Автоматический расчет общей стоимости услуг в заказе
DELIMITER //
CREATE TRIGGER `tr_calculate_order_total`
AFTER INSERT ON `Order_Services`
FOR EACH ROW
BEGIN
    UPDATE `Orders` 
    SET total_amount = (
        SELECT COALESCE(SUM(total_price), 0) 
        FROM `Order_Services` 
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END//
DELIMITER ;

-- ================================================================
-- ХРАНИМЫЕ ПРОЦЕДУРЫ
-- ================================================================

-- Создание нового заказа
DELIMITER //
CREATE PROCEDURE `sp_create_order`(
    IN p_client_id INT,
    IN p_user_id INT,
    IN p_start_date DATETIME,
    IN p_end_date DATETIME,
    OUT p_order_id INT,
    OUT p_order_number VARCHAR(50)
)
BEGIN
    DECLARE v_next_number INT;
    
    -- Получаем следующий номер заказа
    SELECT COALESCE(MAX(CAST(SUBSTRING(order_number, 2) AS UNSIGNED)), 0) + 1
    INTO v_next_number
    FROM `Orders`;
    
    SET p_order_number = CONCAT('O', LPAD(v_next_number, 6, '0'));
    
    -- Создаем заказ
    INSERT INTO `Orders` (order_number, client_id, user_id, start_date, end_date, status)
    VALUES (p_order_number, p_client_id, p_user_id, p_start_date, p_end_date, 'active');
    
    SET p_order_id = LAST_INSERT_ID();
END//
DELIMITER ;

-- Генерация штрих-кода
DELIMITER //
CREATE PROCEDURE `sp_generate_barcode`(
    IN p_order_id INT,
    OUT p_barcode VARCHAR(255)
)
BEGIN
    DECLARE v_order_number VARCHAR(50);
    DECLARE v_date_part VARCHAR(20);
    DECLARE v_unique_code VARCHAR(10);
    
    SELECT order_number, DATE_FORMAT(created_at, '%d%m%y%H%i')
    INTO v_order_number, v_date_part
    FROM `Orders`
    WHERE order_id = p_order_id;
    
    -- Генерируем уникальный код
    SET v_unique_code = LPAD(FLOOR(RAND() * 1000000), 6, '0');
    
    -- Формируем штрих-код
    SET p_barcode = CONCAT(
        SUBSTRING(v_order_number, 2), -- номер без префикса
        v_date_part,
        '12', -- срок проката в часах (по умолчанию)
        v_unique_code
    );
    
    -- Обновляем заказ
    UPDATE `Orders` 
    SET barcode = p_barcode 
    WHERE order_id = p_order_id;
END//
DELIMITER ;

-- ================================================================
-- ЗАПОЛНЕНИЕ БАЗОВЫМИ ДАННЫМИ
-- ================================================================

-- Роли
INSERT INTO `Roles` (`role_name`, `role_description`) VALUES
('Продавец', 'Базовые права: формирование заказов'),
('Старший смены', 'Расширенные права: формирование заказов + прием товара'),
('Администратор', 'Полные права: все функции системы');

-- Категории оборудования
INSERT INTO `Equipment_Categories` (`category_name`, `category_description`) VALUES
('Горные лыжи', 'Лыжи для горнолыжного спорта'),
('Сноуборды', 'Доски для сноубординга'),
('Лыжные ботинки', 'Ботинки для горных лыж'),
('Ботинки для сноуборда', 'Ботинки для сноубordinга'),
('Шлемы', 'Защитные шлемы'),
('Защита', 'Защитные элементы (наколенники, налокотники)'),
('Палки', 'Лыжные палки'),
('Ватрушки', 'Надувные санки для катания');

-- Примеры услуг
INSERT INTO `Services` (`service_name`, `service_description`, `category_id`, `hourly_rate`, `daily_rate`, `deposit_amount`) VALUES
('Прокат горных лыж', 'Аренда комплекта горных лыж', 1, 300.00, 1500.00, 5000.00),
('Прокат сноуборда', 'Аренда сноуборда', 2, 350.00, 1800.00, 5500.00),
('Прокат лыжных ботинок', 'Аренда лыжных ботинок', 3, 150.00, 800.00, 2000.00),
('Прокат ботинок для сноуборда', 'Аренда ботинок для сноуборда', 4, 150.00, 800.00, 2000.00),
('Прокат шлема', 'Аренда защитного шлема', 5, 100.00, 500.00, 1500.00),
('Прокат ватрушки', 'Аренда ватрушки для катания', 8, 200.00, 1000.00, 1000.00);

-- Администратор по умолчанию (пароль: admin123)
INSERT INTO `Users` (`login`, `password_hash`, `first_name`, `last_name`, `role_id`) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Администратор', 'Системы', 3);

-- ================================================================
-- ЗАВЕРШЕНИЕ СОЗДАНИЯ БАЗЫ ДАННЫХ
-- ================================================================

-- Установка автоинкремента для безопасности
ALTER TABLE `Users` AUTO_INCREMENT = 1001;
ALTER TABLE `Clients` AUTO_INCREMENT = 1001;
ALTER TABLE `Orders` AUTO_INCREMENT = 1001;
ALTER TABLE `Equipment` AUTO_INCREMENT = 1001;

-- Сообщение о завершении
SELECT 'База данных "igora" успешно создана со всей структурой!' as message;
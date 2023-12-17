INSERT INTO users (user_name, user_type, phone_number, email, password, enabled, registration_date, role_id, theme_id,
                   geolocation_id)
VALUES ('Пользователь 1', 'SPECIALIST', '111-111-1111', 'user1@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(),
        1, (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 2', 'CUSTOMER', '222-222-2222', 'user2@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(),
        2, (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 3', 'SPECIALIST', '333-333-3333', 'user3@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(),
        1, (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 4', 'CUSTOMER', '444-444-4444', 'user4@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(),
        2, (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 5', 'SPECIALIST', '555-555-5555', 'user5@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(),
        1, (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 6', 'CUSTOMER', '666-666-6666', 'user6@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 2,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 7', 'SPECIALIST', '777-777-7777', 'user7@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 8', 'CUSTOMER', '888-888-8888', 'user8@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 2,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 9', 'SPECIALIST', '999-999-9999', 'user9@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 10', 'CUSTOMER', '101-101-1010', 'user10@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 2,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 11', 'SPECIALIST', '111-111-11112', 'user11@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 12', 'CUSTOMER', '121-121-1212', 'user12@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 2,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 13', 'SPECIALIST', '131-131-1313', 'user13@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 14', 'CUSTOMER', '141-141-1414', 'user14@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 2,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 15', 'SPECIALIST', '151-151-1515', 'user15@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 16', 'SPECIALIST', '161-161-1616', 'user16@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 17', 'SPECIALIST', '171-171-1717', 'user17@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 18', 'SPECIALIST', '181-181-1818', 'user18@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 19', 'SPECIALIST', '191-191-1919', 'user19@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 20', 'SPECIALIST', '120-120-2020', 'user20@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 21', 'SPECIALIST', '121-121-2121', 'user21@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 22', 'SPECIALIST', '122-122-2222', 'user22@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек')),

       ('Пользователь 23', 'SPECIALIST', '123-123-2323', 'user23@example.com',
        '$2a$12$a72Udagvfj0P2ezcWE1yV.s7mMxn6SgJsyHWVOMegNmTN/WBayFbC', true, NOW(), 1,
        (select id from THEMES where THEME_NAME = 'light'), (select id from GEOLOCATION where CITY = 'Бишкек'));


insert into SPECIALISTS (USER_ID, COMPANY_NAME)
VALUES (
           (select id from USERS where PHONE_NUMBER = '123' ),
           'Services Co.'
       );

insert into SUBSCRIPTIONS_ON_TARIFFS(user_id, tariff_id, start_period_time, end_period_time)
values (
        (select id from USERS where PHONE_NUMBER = '123' ),
        (select id from TARIFFS where TARIFF_NAME = 'free'),
        '2023-10-15 15:30:00', '2024-10-15 15:30:00' );

insert into AUTHORITIES(AUTHORITY_NAME)
values ('FULL'),
    ('LIMITED');


INSERT INTO SPECIALISTS_AUTHORITIES (specialist_id, authority_id, date_start, date_end)
values ((select  id from specialists where company_name = 'Services Co.'),
        (select id from authorities where authority_name = 'FULL'),
        CURRENT_DATE, CURRENT_DATE + INTERVAL '1' MONTH);

insert into PORTFOLIOS (SPECIALIST_ID, TITLE)
VALUES ( (select  id from specialists where company_name = 'Services Co.'), 'Примеры моих работ');

insert into PHOTOS (PORTFOLIO_ID, PHOTO_LINK)
VALUES ( (select id from portfolios where title = 'Примеры моих работ'), 'https://www.imperialhotel.ru/upload/iblock/f7b/photo_2021-06-30_13-27-56.jpg' ),
       ((select id from portfolios where title = 'Примеры моих работ'), 'https://upload.wikimedia.org/wikipedia/commons/e/ef/Basingstoke_Sports_Centre_Pool.jpg');

insert into RESUMES (CATEGORY_ID, SPECIALIST_ID, TIME_OF_RESUME, RESUME_DESCRIPTION, name)
VALUES (
           (select  id from  CATEGORIES where CATEGORY_NAME like 'Строительные работы%'),
           (select  id from specialists where company_name = 'Services Co.'), '2023-10-18 12:00:00', 'строительство бассейнов, срок строительства от 6 мес., от $20000', 'Строительство прудов, бассейнов'),
       (
           (select id from CATEGORIES where CATEGORY_NAME like 'Строительные работы и ремонт'),
           (select  id from specialists where company_name = 'Services Co.'), '2023-10-19 12:00:00', 'сантех-работы', 'Сантехнические работы');

insert into FAVOURITES (SPECIALIST_ID, USER_ID)
VALUES ( (select  id from specialists where company_name = 'Services Co.'),  (select  id from users where phone_number = '1234'));

insert into SUBSCRIPTION_STAND (CATEGORY_ID, SPECIALIST_ID)
VALUES ( (select id from CATEGORIES where CATEGORY_NAME like 'Строительные работы%'), (select  id from specialists where company_name  = 'Services Co.') );


insert into RATINGS (USER_ID, SPECIALIST_ID, RATING, REVIEW_TEXT, RATING_DATE)
VALUES ( 2, (select  id from specialists where company_name = 'Services Co.'), 5,'Специалист заменил трубы в ванной комнате. работа выполнена отлично', '2023-10-18 12:00:00'),
       (2, (select  id from specialists where company_name = 'Services Co.'), 3, 'Специалист сделал работу некачественно', '2023-10-18 12:00:00');


insert into POSTS (CATEGORY_ID, PUBLISHED_DATE, USER_ID, WORK_REQUIRED_TIME, DESCRIPTION, TITLE)
VALUES ( (select  id from  CATEGORIES where CATEGORY_NAME like 'Строительные работы%'), '2023-10-15 10:00:00', 2, '2023-10-17 10:00:00', 'Требуется устранить утечку труб', 'Требуется сантехник' );

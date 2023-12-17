insert into POSTS (USER_ID, CATEGORY_ID, TITLE, DESCRIPTION, WORK_REQUIRED_TIME, PUBLISHED_DATE)
VALUES (2,
        (select id from CATEGORIES where CATEGORY_NAME like 'Компьютеры'),
        'Установка windows', 'Требуется установить windows  на компьютер', '2023-10-23 10:00:00', '2023-10-21 10:00:00'),
       (2,
        (select id from CATEGORIES where CATEGORY_NAME like 'Красота и Здоровье'),
        'Женская прическа', 'Требуется мастер с выездом на дом', '2023-10-23 15:00:00','2023-10-21 15:00:00' );


INSERT INTO NOTIFICATIONS (USER_ID, NOTIFICATION_TEXT, NOTIFICATION_DATE)
VALUES (2, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', CURRENT_TIMESTAMP),
       (2, 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem', CURRENT_TIMESTAMP),
       (1, 'ab illo inventore veritatis et quasi architecto beata', CURRENT_TIMESTAMP),
       (1, 'sit amet, consectetur, adipisci velit, sed quia non numquam', CURRENT_TIMESTAMP);

insert into CONTACTS (SPECIALIST_ID, CONTACT_TYPE, CONTACT_VALUE)
VALUES ( 1, 'Telegram', '@qweqwe' );

insert into MESSAGES (SENDER_ID, RECEIVER_ID, MESSAGE_TEXT, DATE_TIME)
VALUES ( 1, 2, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', now() ),
       (2, 1, 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem', now()),
       (1, 2, 'ab illo inventore veritatis et quasi architecto beata', now()),
       (1, 2, 'sit amet, consectetur, adipisci velit, sed quia non numquam', now()),
       (1, 2, 'nisi ut aliquid ex ea commodi consequatur? Quis autem', now()),
       (2, 1, 'fugiat quo voluptas nulla pariatur?', now()),
       (2, 1, 'magnam aliquam quaerat voluptatem. Ut enim ad', now()),
       (1, 2, 'nisi ut aliquid ex ea commodi consequatu', now()),
       (1, 2, 'vel illum qui dolorem eum fugiat', now());

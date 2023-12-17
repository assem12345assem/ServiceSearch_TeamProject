insert into SPECIALISTS (USER_ID, COMPANY_NAME)
VALUES (
        (select id from USERS where PHONE_NUMBER = '111-111-1111'),
        'Attractor Co.');

insert into PORTFOLIOS (SPECIALIST_ID, TITLE, time_of_portfolio)
VALUES (11, 'Примеры моих работ', now());


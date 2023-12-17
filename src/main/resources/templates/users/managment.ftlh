<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Управление пользователями</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .user-card {
            margin-bottom: 20px;
            padding: 20px;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);

        }



        .btn-group {
            margin-top: 15px;
        }

        .sort-dropdown {
            margin-bottom: 20px;
        }

        #unblock {
            color: green;
            border: solid 1px green;
            background-color: white;
            border-radius: 3px;
        }
        #unblock:hover {
            color: green;
            background-color: lightgray;
            border-color: green;
        }
        .notification {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background-color: #4caf50;
            color: #fff;
            padding: 10px;
            text-align: center;
            z-index: 1000;
            margin: 20px;
            border-radius: 11px;
            display: none;
        }

        .notification.show {
            display: block;
            animation: fadeOut 4s ease-in-out;
        }
    </style>
</head>
<body>
<div class="container">
    <div><a href="/logout">LOGOUT</a> </div>
    <h1 class="text-center mt-4 mb-5">Управление пользователями</h1>


    <div class="row">
        <div class="col-md-8 offset-md-2">

            <meta name="_csrf_header" content="${_csrf.headerName}"/>
            <meta name="_csrf_token" content="${_csrf.token}"/>

            <div id="userList">

            </div>

        </div>
    </div>

</div>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        async function fetchAndDisplayUsers() {
            try {
                const response = await fetch('/api/super/users');
                if (!response.ok) {
                    throw new Error('Failed to fetch user data');
                }
                const usersData = await response.json();
                displayUsers(usersData);
            } catch (error) {
                console.error('Error fetching user data:', error);
            }
        }

        function displayUsers(usersData) {
            const userListContainer = document.getElementById('userList');
            userListContainer.innerHTML = '';

            usersData.forEach(user => {
                const userCard = document.createElement('div');
                userCard.classList.add('user-card');

                const userNameElement = document.createElement('h3');
                userNameElement.textContent = user.userName;

                const emailElement = document.createElement('p');
                emailElement.textContent = `Email:` + user.email;

                const roleElement = document.createElement('p');
                roleElement.textContent = `Роль: ` + user.role;

                const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
                const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');

                const buttonGroup = document.createElement('div');
                buttonGroup.classList.add('btn-group');
                buttonGroup.setAttribute('role', 'group');
                buttonGroup.setAttribute('aria-label', 'Действия с пользователем');

                const blockButton = document.createElement('button');
                blockButton.classList.add('btn', 'btn-danger', 'mr-2', 'block-btn');
                blockButton.setAttribute('data-userid', user.id);
                if (user.enabled) {
                    blockButton.textContent = 'Заблокировать';
                } else {
                    blockButton.id = 'unblock';
                    blockButton.textContent = 'Разблокировать';
                }

                const detailLink = document.createElement('a');
                detailLink.classList.add('btn', 'btn-primary', 'mr-2');
                detailLink.textContent = 'Подробнее';
                detailLink.href = `/super/info/`+user.id;

                blockButton.addEventListener('click', async (event) => {
                    const userId = event.target.dataset.userid;

                    try {
                        const response = await fetch(`/api/super/block/` + userId, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                [csrfHeader]: csrfToken,
                            },
                        });

                        if (response.status === 200) {
                            console.log('SUCCESS!');

                        } else {
                            console.error('Failed to update favorites.');
                        }
                    } catch (error) {
                        console.error('Error in updating favorites:', error);
                    }
                });

                buttonGroup.appendChild(blockButton);
                buttonGroup.appendChild(detailLink)
                userCard.append(userNameElement, emailElement, roleElement, buttonGroup);
                userListContainer.appendChild(userCard);
            });
        }

        fetchAndDisplayUsers();

        setInterval(fetchAndDisplayUsers, 1000);
    });
</script>
</body>
</html>

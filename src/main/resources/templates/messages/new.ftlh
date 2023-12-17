<#import '../layout.ftlh' as main>
<@main.layout>
    <<<<<<<<< Temporary merge branch 1
    <div class="content">
    <div class="new-msg">
        <div class="email-app">
            <p class="text-center">Новое сообщение</p>
            <form>
                <div class="form-row mb-3">
                    <label for="to" class="my-3">Кому:</label>
                    <div class="">
                        <input type="text" class="form-control" id="to" placeholder="Имя пользователя">
                        <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                               value="${(_csrf.token)!'--no-token--'}"/>
                        <div id="toError" class="error-message"></div> <!-- New element for error message -->

                    </div>
                </div>
            </form>
            <div class="list-names">
                <#if usernameList??>
                    <#list usernameList as item>
                        <div class="user-item" data-id="${item.id}">
                            <div class="textbox">
                                ${item.userName}
                            </div>

                        </div>
                    </#list>
                </#if>
            </div>
            <div class="row">
                <div class="">
                    <div class="form-group mt-4">
                        <textarea class="form-control" id="message" name="body" rows="12"
                                  placeholder="Введите Ваше сообщение"></textarea>

                        <div id="messageError" class="error-message"></div>
                    </div>
                    <div class="form-group btns">
                        <button type="button" class="button-msg" id="send">Отправить</button>
                        <a href="javascript:history.go(-1);" class="button-msg" id="cancel">Отмена</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toInput = document.getElementById('to');
            const listNames = document.querySelector('.list-names');
            let userId;
            toInput.addEventListener('input', function () {
                const userInput = this.value.toLowerCase();
                const userItems = listNames.querySelectorAll('.user-item');

                listNames.style.display = 'none';

                userItems.forEach(item => {
                    const userName = item.textContent.toLowerCase();

                    if (userName.includes(userInput)) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });

                if (userInput.length > 0) {
                    listNames.style.display = 'block';
                }
            });

            listNames.addEventListener('click', function (e) {
                const userItem = e.target.closest('.user-item');

                if (userItem) {
                    userId = userItem.dataset.id;
                    toInput.value = userItem.textContent.trim();
                    console.log('Selected user ID:', userId);

                    listNames.style.display = 'none';
                }
            });
            document.getElementById('send').addEventListener('click', function () {
                const message = document.getElementById('message').value;
                const csrfToken = document.querySelector('input[name="_csrf"]').value;
                const toError = document.getElementById('toError');
                const messageError = document.getElementById('messageError');

                if (!userId) {
                    toError.textContent = "Поле кому не может быть пустым.";
                    return;
                }

                if (!message) {
                    messageError.textContent = "Поле сообщение не может быть пустым.";
                    return;
                }

                toError.textContent = "";
                messageError.textContent = "";
                fetch('/msg/new', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify({
                        viewer: userId,
                        response: message
                    })
                }).then(response => {
                    window.location.href = '/msg';
                })
                    .catch(function (error) {
                        console.error('Error:', error);
                    });
            });
        });
    </script>
    <style>
        .list-names {
            display: none;
        }

        .error-message {
            color: red;
            font-size: 12px;
            margin-top: 5px;
        }

        .new-msg {
            padding: 40px;
            display: block;
            flex-direction: row;
            margin-left: auto;
            margin-right: auto;
            width: 500px;
        }

        .textbox {
            border: 1px solid #2552e7;
            padding: 5px;
            margin: 5px;
            cursor: pointer;
            border-radius: 10px;
            color: #2552e7;
        }

        .email-app {
            background: #fff;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 10px;
            margin-bottom: 40px;
        }

        .dark-theme .email-app {
            background: #333;
            color: white
        }

        @media only screen and (max-width: 600px) {
            .email-app {
                padding: 30px;
                margin: 5px;
            }

            .new-msg {
                padding: 10px;
                width: auto;
            }

            textarea {
                height: 300px;
            }
        }

        @media only screen and (max-width: 400px) {
            .btns {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .button-msg {
                margin: 15px auto;
            }
        }

        .form-control {
            width: 100%;
            border: 1px solid #ccc;
            background-color: #fff;
            border-radius: 10px;
            padding: 10px;
            margin: 10px 0;
        }

        .dark-theme .form-control {

            background-color: #333;
            color: white;
        }

        .form-group {
            text-align: center;
        }

        .button-msg {
            border: 1px solid #2552e7;
            background-color: #fff;
            border-radius: 10px;
            width: 150px;
            padding: 8px 0;
            font-size: 15px;
            margin: 15px 10px;
            color: #2552e7;
            text-decoration: none;
        }

        .dark-theme .button-msg {
            border: 1px solid #555;
            background-color: #333;
            color: white;
        }

        button.button-msg {
            padding: 8px 0;
        }

        a.button-msg {
            display: inline-block;
        }

        .button-msg:hover {
            background-color: #2552e7;
            color: #fff;
        }

    </style>
</@main.layout>
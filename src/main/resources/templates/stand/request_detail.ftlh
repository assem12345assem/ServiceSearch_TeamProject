<#import '../layout.ftlh' as main>
<@main.layout>
    <title>Детали запроса</title>
    <div class="padding-div">
        <div class="category-header">
            <a href="javascript:history.go(-1);" class="back-button">
                <i class="fas fa-arrow-left"></i>Назад
            </a>
        </div>
        <h1 class="text-center"> Запрос пользователя </h1>
        <div class="task-content">
            <#if post??>
                <div class="task-details mt-3 me-2">
                    <div class="row">
                        <div class="col-2 user-photo">
                            <img src="${post.userPhoto}" alt="User Photo">
                        </div>
                        <div class="col-3 text-center">${post.userName}</div>
                    </div>
                    <hr>
                    <div class="description">
                        <i class="fa-solid fa-calendar-days"></i> Когда: ${post.workRequiredTime}
                        <br>
                        ${post.title}
                        <br>
                        ${post.description}
                    </div>
                    <hr>
                    <div class="response-info">
                        <div class="responses-count">
                            <p>Откликнулось специалистов: ${post.responseNumber}</p>
                            <p>Дата публикации: ${post.publishedDate}</p>
                        </div>

                    </div>
                </div>
            <#else>
                Данный запрос больше не актуален.
            </#if>
        </div>
        <div class="d-flex flex-column align-items-end me-3 my-3">
            <#if (pastMessages)??>
                <#if pastMessages?has_content>
                    <#list pastMessages as item>
                        <#if item.viewer == 'author'>
                            <div class="message">${item.response} <br> <#if (item.dateTime)??> ${item.dateTime} </#if>
                            </div>
                        <#else>
                            <div class="incoming-msg">${item.response} <br> <#if (item.dateTime)??> ${item.dateTime} </#if>
                            </div>
                        </#if>
                    </#list>
</#if>
            </#if>
        </div>


        <div class="sent-messages d-flex flex-column align-items-end me-3 my-3">
            <!-- Messages will be displayed here -->
        </div>
        <div class="message-container">
            <form method="post" action="/stand/request_detail/message/${conversationId}" id="message-form"
                  class="d-flex flex-column align-items-end me-3">
                <input type="text" id="message-text" class="msg-input" autofocus required>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                       value="${(_csrf.token)!'--no-token--'}"/>
                <button type="submit" class="respond-button">Отправить</button>
            </form>
        </div>
    </div>
    <style>
        .padding-div {
            padding: 30px;
        }

        .message-container {
            margin-bottom: 40px;
        }

        .category-card span {
            margin-top: 10px;
            font-size: 12px;
            font-weight: 600;
        }

        .task-content {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 30px;
        }

        .task-details {
            border: 1px solid #ccc;
            border-radius: 15px;
            padding: 30px;
            width: 100%;
        }


        .user-photo img {
            margin-right: 10px;
            width: 50px;
            height: 50px;
            object-fit: cover;
        }

        .description {
            margin-top: 10px;
        }

        .response-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .responses-count {
            color: #747373;
            margin-bottom: 20px;
        }

        .msg-input {
            width: 80%;
            border-radius: 15px;
            padding: 15px;
            box-shadow: 0 -5px 15px rgb(224, 220, 220);
            height: 100px;
            margin: 30px 0 10px;
        }

        .respond-button {
            padding: 15px 20px;
            color: #2552e7;
            border: 2px solid #2552e7;
            background-color: #fff;
            cursor: pointer;
            border-radius: 15px;
            text-decoration: none;
            width: 25%;
        }

        @media (max-width: 600px) {
            .respond-button {
                width: auto;
                margin-right: auto;
                margin-left: auto;
            }
        }

        .respond-button:hover {
            background-color: #2552e7;
            color: #fff;
        }

        .message {
            margin: 5px 15px 5px;
            background-color: #2552e74a;
            border-radius: 15px;
            width: fit-content;
            max-width: 450px;
            padding: 5px 10px;

        }

        .back-button {
            text-decoration: none;
            color: #2552e7;
            display: flex;
            align-items: center;
            font-size: 18px;
            margin-right: 40px;
            margin-left: 10px;
        }

        .incoming-msg {
            margin: 5px 15px 5px;
            background-color: #66e08497;
            border-radius: 15px;
            width: fit-content;
            max-width: 450px;
            padding: 5px 10px;
            margin-right: auto !important;
        }
    </style>
    <script>
        const currentURL = window.location.href;
        const parts = currentURL.split("/");
        const viewer = parts[parts.length - 1];
        const csrfToken = document.querySelector('input[name="_csrf"]').value;
        const sentMessages = document.querySelector('.sent-messages');
        const postedMessages = new Set();

        document.addEventListener('DOMContentLoaded', function () {
            const messageForm = document.getElementById('message-form');
            const messageText = document.getElementById('message-text');

            messageForm.addEventListener('submit', function (e) {
                e.preventDefault();
                const message = messageText.value;
                const responseText = {
                    viewer: viewer,
                    response: message,
                };
                console.log(responseText)
                fetch(`/stand/request_detail/message/` + viewer, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify(responseText)
                })
                    .then(response => {
                        const messageElement = document.createElement('div');
                        messageElement.classList.add('message');
                        const dt = getDateTime();
                        messageElement.innerText = message + '\n' + getDateTime();
                        sentMessages.appendChild(messageElement);
                        messageForm.reset();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
            });
        });

        function getDateTime() {
            const now = new Date();
            const date = ("0" + now.getDate()).slice(-2);
            const month = ("0" + (now.getMonth() + 1)).slice(-2);
            const hour = ("0" + now.getHours()).slice(-2);
            const minute = ("0" + now.getMinutes()).slice(-2);

            return '\n' + month + '/' + date + ' ' + hour + ':' + minute;
        }

        const now = new Date();


        let preciseNow = new Date(Math.floor(now.getTime() / 1000) * 1000);
        const time = preciseNow.toISOString()

        function fetchNewMessages(preciseNow) {

            fetch(`/stand/find_new/customer_specialist`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': csrfToken
                },
                body: JSON.stringify({
                    'viewer': viewer,
                    'response': time
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.length > 0) {
                        console.log(data);
                        data.forEach(message => {
                            const responseMessage = message.response;
                            const responseDateTime = message.dateTime;
                            const messageIdentifier = responseMessage + '-' + responseDateTime;

                            if (!postedMessages.has(messageIdentifier)) {
                                const messageElement = document.createElement('div');
                                messageElement.classList.add('incoming-msg');

                                messageElement.innerText = responseMessage + '\n' + responseDateTime;
                                sentMessages.appendChild(messageElement);

                                postedMessages.add(messageIdentifier);
                            }
                        });
                        preciseNow = Math.max(...data.map(message => message.dateTime));
                    }
                    setTimeout(() => fetchNewMessages(preciseNow), 5000); // Fetch every 5 seconds (adjust as needed)
                })
                .catch(error => {
                    console.error('Error fetching new messages:', error);
                    setTimeout(() => fetchNewMessages(preciseNow), 5000); // Fetch every 5 seconds (adjust as needed)
                });
        }

        let preciseNow2 = new Date(Math.floor(now.getTime() / 1000) * 1000);
        fetchNewMessages(preciseNow2);
    </script>
</@main.layout>
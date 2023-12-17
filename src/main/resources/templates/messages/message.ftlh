<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="msg">
        <button class="tablinks-1">Сообщения</button>
        <button class="tablinks-2">Уведомления</button>
    </div>

    <div id="Messages" class="tabcontent margin-bottom-add">
        <h3 class="my-3">Сообщения</h3>
        <#if messages??>
            <#list messages as item>
                <a class="message-card mb-3" href="/msg/${item.id}">
                    <div class="photo">
                        <img src="${item.senderPhoto}" alt="user photo">
                    </div>
                    <div class="text">
                        <b> ${item.senderName} </b>
                        <#if (item.lastMessageText)??>${item.lastMessageText}</#if>
                        <p class="ms-auto">
                            <#if (item.lastMessageDateTime)??>${item.lastMessageDateTime}</#if>
                        </p>
                    </div>
                    <span class="delete-icon" style="color: black;"><i class="fas fa-trash-alt"></i></span>
                </a>
            </#list>
        </#if>


        <a href="/msg/new" class="btn fixed-button"><i class="fas fa-pen"></i>
        </a>

    </div>

    <div id="Notifications" class="tabcontent margin-bottom-add">
        <h3>Уведомления</h3>
        <#if notifications??>
            <#list notifications as item>
                <div class="notification-card" onclick="toggleCardExpansion(this)">
                    ${item.notificationText}
                    <br>
                    ${item.notificationDate}
                    <a href="msg/delete/${item.id}">
                        <span class="delete-icon" style="color: black;"><i class="fas fa-trash-alt"></i></span>
                    </a>
                </div>

            </#list>
        <#else>
            <h3>Уведомлений нет</h3>
        </#if>

    </div>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .msg {
            overflow: hidden;
            border: 1px solid #ccc;
            background-color: #f9f9f9;
            display: flex;
        }
        .dark-theme .msg {
            background-color: #333;
            color: white;
            border: 1px solid #555;

        }

        .msg button {
            background-color: inherit;
            display: inline-block;
            width: 100%;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.3s;
            font-size: 17px;
        }


        .msg button:hover {
            background-color: #2552e7;
            color: white;
        }

        .msg button.active {
            background-color: #2552e7;
            color: white;
        }

        .tabcontent {
            display: none;
            padding: 12px 25px;
            border: 1px solid #ccc;
            border-top: none;
            position: relative;
            height: auto;
            min-height: 80vh;
            margin-bottom: 30px;
        }

        .message-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0.0, 0.0, 0.2, 0.2);
            margin: 10px;
            color: black;
            text-decoration: none;
            display: flex;
            height: 90px;
            flex-direction: row;
            padding: 20px 30px;
        }
        .dark-theme .message-card {
            background-color: #333;
            color: #fff;
            box-shadow: 0 5px 15px rgba(247, 241, 241, 0.614);
        }

        @media only screen and (max-width: 600px) {
            .message-card {
                padding: 20px 10px;
                height: 150px;
            }

            .notification-card {
                padding: 20px 10px;
                height: 150px !important;
            }

            .text {
                white-space: normal !important;
            }

        }

        .fixed-button {
            position: absolute;
            background-color: #2552e7;
            color: white;
            padding: 15px 20px;
            bottom: 70px;
            right: 50px;
            border-radius: 5px;
        }

        .fixed-button:hover {
            background-color: #2552e7;
        }

        .text {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            margin: 0 10px;
        }

        .photo img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            /* This property ensures that the image covers the entire container while maintaining aspect ratio */
        }

        .notification-card {
            border: 1px solid #99999986;
            margin: 10px;
            padding: 20px 30px;
            overflow: hidden;
            transition: height 0.3s ease;
            height: 90px;
        }
.dark-theme .notification-card {
    background-color: #333;
    color: #fff;
    box-shadow: 0 5px 15px rgba(247, 241, 241, 0.614);
}
.dark-theme .tablinks-1 {
    color: white;
}
.dark-theme .tablinks-2 {
    color: white;
}
        .expanded {
            max-height: none;
        }
        .margin-bottom-add {
            margin-bottom: 60px;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const messagesTab = document.getElementById('Messages');
            const notificationsTab = document.getElementById('Notifications');

            // Function to show Messages tab
            function showMessagesTab() {
                messagesTab.style.display = 'block';
                notificationsTab.style.display = 'none';
            }

            // Function to show Notifications tab
            function showNotificationsTab() {
                messagesTab.style.display = 'none';
                notificationsTab.style.display = 'block';
            }

            const tablinks1 = document.querySelector('.tablinks-1');
            const tablinks2 = document.querySelector('.tablinks-2');

            tablinks1.addEventListener('click', showMessagesTab);
            tablinks2.addEventListener('click', showNotificationsTab);
            tablinks1.click();


            const messageCards = document.querySelectorAll('.message-card');

            messageCards.forEach(function (card) {
                const href = card.getAttribute('href');
                const msgId = href.split('/').pop();

                if (msgId.startsWith('response-')) {
                    card.addEventListener('click', function (event) {
                        event.preventDefault();
                        window.location.href = `/stand/show/` + msgId;
                    });
                } else {
                    card.addEventListener('click', function (event) {
                        event.preventDefault();
                        window.location.href = `/msg/` + msgId;
                    });
                }
            });
        });
    </script>
</@main.layout>
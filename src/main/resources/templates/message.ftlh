<#import "layout.ftlh" as main>
<@main.layout>
    <title>Сообщение</title>
    <style>
        .message-block{
            margin-top: 150px;
        }

        .text{
            color: #25d366;
            font-size: 20px;
        }
    </style>
    <div class="message-block text-center">
        <h2>Сбросить пароль</h2>
        <p class="text">${message}</p>
    </div>
</@main.layout>
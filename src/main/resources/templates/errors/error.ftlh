<#import "../layout.ftlh" as main>
<@main.layout>
<title>Ошибка</title>
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f8f9fa;
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100vh;
        margin: 0;
    }

    .error-container {
        text-align: center;
    }

    .error-code {
        font-size: 120px;
        font-weight: bold;
        color: #dc3545;
    }

    .error-message {
        font-size: 24px;
        margin-top: 20px;
        margin-bottom: 10px;
        color: #343a40;
    }

    .back-link {
        text-decoration: none;
        color: #007bff;
        font-size: 18px;
        font-weight: bold;
    }

    .back-link:hover {
        text-decoration: underline;
    }
</style>
<body>
<div class="error-container">
    <#if status??>
        <div class="error-code">${status}</div>
    <#else>
        <div class="error-code">Ошибка</div>
    </#if>
    <#if reason??>
        <div class="error-message">${reason}</div>
    <#else>
        <div class="error-message">Что то пошло не так</div>
    </#if>
    <a href="/" class="back-link">Вернуться на главную</a>
</div>
</@main.layout>

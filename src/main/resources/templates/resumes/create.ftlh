<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Создать новое резюме</title>
    <style>
        .content {
            max-width: 600px;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            margin-top: 20%;
        }

        .dark-theme .content {
            background-color: #333;
            color: #fff;
            box-shadow: 0 5px 15px rgba(247, 241, 241, 0.614);
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
        }

        input[type="text"],
        input[type="number"],
        select,
        textarea {
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        input[type="submit"] {
            background-color: #7F88FF;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
        }

        input[type="submit"]:hover {
            background-color: #636df6;
        }

        .buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }

        .back-button {
            text-decoration: none;
            color: #7F88FF;
            display: flex;
            align-items: center;
            font-size: 18px;
            margin: 15px;
        }
    </style>
<a href="javascript:history.go(-1);" class="back-button">
    <i class="fas fa-arrow-left"></i>Назад
</a>
<div class="content">
    <form action="/resume/create" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

        <label for="resumeTitle">Заголовок резюме:</label>
        <input type="text" id="resumeTitle" name="header" required>

        <label for="resumeCategory">Категория резюме:</label>
        <select id="resumeCategory" name="categoryId" required>
            <#if categories?has_content>
                <#list categories as category>
                    <option value="${category.id}">${category.categoryName}</option>
                </#list>
            </#if>
        </select>

        <label for="resumeDescription">Описание резюме:</label>
        <textarea id="resumeDescription" name="resumeDescription"
                  rows="4" required></textarea>

        <div class="buttons">
            <input type="submit" value="Сохранить">
        </div>
    </form>
</div>
</@main.layout>
<#import '../layout.ftlh' as main>
<@main.layout>
    <title>Создать новый запрос на стенд</title>
<style>
    .content {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        margin: 100px 20px 70px;
    }
.dark-theme .content {
    border: 1px solid #555;
    background-color: #333;
    color: white;
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
        background-color: #2552e7;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 18px;
    }

    input[type="submit"]:hover {
        background-color: #1c3c80;
    }

    .buttons {
        margin-top: 20px;
        display: flex;
        justify-content: center;
    }

    .cancel {
        background-color: #2552e7;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 18px;
        text-decoration: none;
        margin-right: 20px;
    }

    .back-button{
        margin: 15px;
    }
</style>
    <a href="javascript:history.go(-1);" class="back-button">
        <i class="fas fa-arrow-left"></i>Назад
    </a>
    <div class="content">
        <h2 class="text-center">Создать новый запрос на стенде</h2>
        <form action="/stand/new" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

            <label for="title">Заголовок запроса:</label>
            <input type="text" id="title" name="title" required>

            <label for="workRequiredTime">Когда требуется выполнить услугу:</label>
            <input type="datetime-local" id="workRequiredTime" name="workRequiredTime" required>
            <p id="error-message" style="color: red;"></p>

            <label for="description">Содержание запроса:</label>
            <input type="text" id="description" name="description" required>

            <label for="categoryId">Категория запроса:</label>
            <select id="categoryId" name="categoryId" required>
                <#if categories?has_content>
                    <#list categories as category>
                        <option value="${category.id}">${category.categoryName}</option>
                    </#list>
                </#if>
            </select>


            <div class="buttons">
                <a href="javascript:history.go(-1);" class="cancel">Отмена</a>
                <input type="submit" value="Сохранить">
            </div>
    </form>
    </div>

    <script>
        document.querySelector('form').addEventListener('submit', function(event) {
            var inputDateTime = new Date(document.getElementById('workRequiredTime').value);
            var now = new Date();

            if (inputDateTime < now) {
                event.preventDefault();
                document.getElementById('error-message').textContent = 'Дата и время не могут быть в прошлом.';
            } else {
                document.getElementById('error-message').textContent = '';
            }
        });
    </script>
</@main.layout>
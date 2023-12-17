<#macro layout>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Главная страница</title>
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link
                href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                rel="stylesheet"
                integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
                crossorigin="anonymous">
        <link rel="stylesheet" href="/static/css/layout.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous">
        </script>
    </head>
    <body>
    <div class="tab-container">
        <nav class="tab-bar">
            <a href="/" class="tab" id="home">
                <i class="fas fa-home"></i>
                <!-- <span>Главный экран</span> -->
            </a>
            <a href="/contact" class="tab" id="home">
                <i class="fas fa-id-card"></i>
                <!-- <span>Визитница</span> -->
            </a>
            <a href="/stand" class="tab">
                <i class="fas fa-tasks"></i>
                <!-- <span>Стенд</span> -->
            </a>
            <a href="/msg" class="tab">
                <i class="fas fa-envelope"></i>
                <!-- <span>Сообщения</span> -->
            </a>
            <a href="/profile" class="tab">
                <i class="fas fa-user"></i>
                <!-- <span>Личный кабинет</span> -->
            </a>
        </nav>
    </div>
<script>
    function applyThemeToPage() {
        const storedTheme = localStorage.getItem('theme');

        const theme = storedTheme !== null ? parseInt(storedTheme, 10) : 0;

        const body = document.body;
        const otherElements = document.querySelectorAll('.other-elements');

        body.classList.toggle('dark-theme', theme == 1);
        otherElements.forEach(element => {
            element.classList.toggle('dark-theme', theme == 1);
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        applyThemeToPage();
    });

</script>
<#nested>
    </body>
    </html>
</#macro>
<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Резюме</title>
    <link rel="stylesheet" href="../../static/css/resumes.css">
    <link rel="stylesheet" href="../../static/css/layout.css">
    <div id="content" class="content">
        <div class="category-header">
            <a href="javascript:history.go(-1);" class="back-button">
                <i class="fas fa-arrow-left"></i>Назад
            </a>
        </div>

        <div class="resumes-list">
            <#if resumes?has_content>
                <#list resumes as resume>
                    <div class="resume">
                        <a href="/resume/${resume.id}" class="resume-link">
                            <#if resume.header?has_content>
                                <p class="resume-name">${resume.header}</p>
                                <#else>
                                    <p class="resume-name">Без заголовок</p>
                            </#if>
                            <p class="resume-date">Дата создания: ${resume.timeOfResume} </p>
                        </a>
                        <div class="resume-buttons">
                            <a class="view-button" href="/resume/${resume.id}">Больше узнать</a>

                            <meta name="_csrf_header" content="${_csrf.headerName}"/>
                            <meta name="_csrf_token" content="${_csrf.token}"/>

                            <button class="favorite-button" id="favoriteButton"
                                    data-specialist-id="${resume.specialistId}">

                                <#if noUser??>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="25"
                                         height="25" fill="currentColor"
                                         class="bi bi-bookmark" viewBox="0 0 16 16">
                                        <path
                                                d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5V2zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1H4z"/>
                                    </svg>
                                </#if>
                            </button>
                        </div>
                    </div>
                </#list>
            <#else>
                <p>Резюме не найдено</p>
            </#if>
        </div>

        <div class="notification" id="notification">
            Добавлено в избранное
        </div>
    </div>
    <script>
        const favoriteButtons = document.querySelectorAll(".favorite-button");
        const successNotification = document.getElementById("notification");
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
        const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');

        favoriteButtons.forEach(button => {
            button.addEventListener("click", async function () {
                const specialistId = button.getAttribute("data-specialist-id");

                try {
                    const response = await fetch(`/fav/add/` + specialistId, {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            [csrfHeader]: csrfToken,
                        },
                    });

                    if (response.status === 200) {
                        button.classList.add("favorite");
                        showSuccessNotification();
                    } else {
                        console.error("Failed to update favorites.");
                    }
                } catch (error) {
                    console.error("Error in updating favorites: " + error);
                }
            });
        });

        function showSuccessNotification() {
            successNotification.classList.add("show");
            setTimeout(() => {
                successNotification.classList.remove("show");
            }, 4000);
        }
    </script>

</@main.layout>
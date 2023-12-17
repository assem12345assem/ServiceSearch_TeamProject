<#import "../layout.ftlh" as main>
<@main.layout>
    <link rel="stylesheet" href="/static/css/profileorigin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <title>Личный кабинет</title>
    <div id="content" class="content">
        <a href="#" class="settings-link" id="openModal">
            <i class="fas fa-cog"></i>
        </a>

        <div class="square">
            <h2 class="logo">linky.</h2>
        </div>

        <div class="white">

        </div>
        <div class="black">

        </div>
        <div class="profile-header row">
            <div class="profile-image-block col-4">
                <#if user.photo?has_content>
                    <img src="${user.photo}"
                         class="round-image" alt>
                <#else>
                    <img src="/static/default.jpg" class="round-image" alt="default photo">
                </#if>
            </div>
            <div class="personal-info col-6">
                <#if user.userName?has_content>
                    <p class="username text-center">${user.userName}</p>
                </#if>
                <#if businessCard??>
                    <#if businessCard?has_content>
                        <#list businessCard as it>
                            <p class="margin-left-div">
                                <#if it.contactType == "Telegram">
                                    <span class="social-icon"><i class="fa-brands fa-telegram"
                                                                 style="color: #0056d6;"></i></span>
                                <#elseif it.contactType == "Instagram">
                                    <span class="social-icon"><i class="fa-brands fa-instagram"
                                                                 style="color: #ff40ff;"></i></span>
                                <#elseif it.contactType == "WhatsApp">
                                    <span class="social-icon"><i class="fa-brands fa-whatsapp"
                                                                 style="color: #669c35;"></i></span>
                                <#elseif it.contactType == "Facebook">
                                    <span class="social-icon"><i class="fa-brands fa-facebook"
                                                                 style="color: #0042aa;"></i></span>
                                <#elseif it.contactType == "TikTok">
                                    <span class="social-icon"><i class="fa-brands fa-tiktok"></i></span>
                                <#elseif it.contactType == "LinkedIn">
                                    <span class="social-icon"><i class="fa-brands fa-linkedin"
                                                                 style="color: #0056d6;"></i></span>
                                <#elseif it.contactType == "Email">
                                    <span class="social-icon"><i class="fa-solid fa-envelope"></i></span>
                                <#elseif it.contactType == "Телефон">
                                    <span class="social-icon"><i class="fa-solid fa-phone"></i></span>
                                <#elseif it.contactType == "ВКонтакте">
                                    <span class="social-icon"><i class="fa-brands fa-vk"
                                                                 style="color: #0042aa;"></i></span>
                                <#elseif it.contactType == "Одноклассники">
                                    <span class="social-icon"><i class="fa-brands fa-odnoklassniki"
                                                                 style="color: #d29d00;"></i></span>
                                <#elseif it.contactType == "Другое">
                                    <span class="social-icon">Др.</span>
                                </#if>
                                : ${it.contactValue}</p>
                        </#list>
                    </#if>
                <#else>
                    <#if user.phoneNumber?has_content>
                        <p>${user.phoneNumber}</p>
                    </#if>
                </#if>

                <#if rating?has_content>
                    <div class="rating text-center">
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="rating-number" id="rating"><#if rating??>${rating}</#if></span>
                    </div>
                </#if>
            </div>
        </div>
        <div>
            <#if user.role = "ROLE_SPECIALIST">
                <div class="tabs">
                    <button class="tab-item" id="resume-tab">Резюме</button>
                    <button class="tab-item" id="portfolio-tab">Портфолио</button>
                </div>
                <div class="tab-content" id="resume-content">
                    <div class="resume-list">
                        <div class="resume create-resume">
                            <a href="/resume/create" class="add-resume-link">
                                <p class="add-resume-text">Добавить резюме</p>
                                <i class="fas fa-plus"></i>
                            </a>
                        </div>
                        <#if resumes?has_content>
                            <#list resumes as resume>
                                <div class="resume">
                                    <a href="/resume/${resume.id}" class="resume-link">
                                        <#if resume.header?has_content>
                                            <p class="resume-name">${resume.header}</p>
                                        <#else>
                                            <p class="resume-name">Без заголовка</p>
                                        </#if>
                                        <#if resume.experience?has_content>
                                            <p class="resume-experience">Опыт работы: ${resume.experience}</p>
                                        </#if>
                                        <#if resume.category?has_content>
                                            <p class="resume-category">Категория: ${resume.category}</p>
                                        </#if>
                                        <#if resume.timeOfResume?has_content>
                                            <p class="resume-date">Дата публикации: ${resume.timeOfResume}</p>
                                        </#if>
                                    </a>
                                    <div class="buttons-resume">
                                        <a href="/resume/up/${resume.id}">
                                            <button class="btn resume-button">Ап</button>
                                        </a>
                                        <a href="/resume/delete/${resume.id}">
                                            <button class="btn resume-button">Удалить</button>
                                        </a>
                                    </div>
                                </div>
                            </#list>
                        <#else>
                            <p class="text-center mt-5">У вас еще нету созданных резюме</p>
                        </#if>
                    </div>
                </div>
                <div class="tab-content" id="portfolio-content">
                    <div class="portfolio-list">
                        <div class="resume create-resume">
                            <a href="/portfolio/new" class="add-resume-link">
                                <p class="add-resume-text">Добавить портфолио</p>
                                <i class="fas fa-plus"></i>
                            </a>
                        </div>
                        <#if portfolios?has_content>
                            <#list portfolios as portfolio>
                                <div class="portfolio">
                                    <div class="cover-photo">
                                        <#if portfolio.coverPhotoLink??>
                                            <img src="${portfolio.coverPhotoLink}" alt class="portfolio-img">
                                        <#else>
                                            <img src="/static/noPhoto.png" alt class="portfolio-img">
                                        </#if>
                                    </div>
                                    <div class="portfolio-details">
                                        <#if portfolio.title?has_content>
                                            <p class="resume-name">${portfolio.title}</p>
                                        </#if>
                                        <#if portfolio.timeOfPortfolio?has_content>
                                            <p>Дата публикации ${portfolio.timeOfPortfolio}</p>
                                        </#if>
                                    </div>
                                </div>
                            </#list>
                        <#else>
                            <p class="text-center mt-5">У вас еще нет загруженного портфолио</p>
                        </#if>
                    </div>
                </div>
            <#elseif user.role = "ROLE_CUSTOMER">
                <div class="tab-content" id="resume-content">
                    <div class="resume-list">
                        <div class="resume create-resume">
                            <a href="/stand/new" class="add-resume-link">
                                <p class="add-resume-text">Новый запрос</p>
                                <i class="fas fa-plus"></i>
                            </a>
                        </div>
                        <#if stands?has_content>
                            <#list stands as stand>
                                <div class="resume">
                                    <div class="post">
                                        <div class="post-menu">
                                            <button type="button" class="menu-button" data-bs-toggle="dropdown"
                                                    aria-haspopup="true"
                                                    aria-expanded="false">
                                <span class="dots" style="font-size: 25px"><i class="fas fa-ellipsis-v"></i>
                                </span>
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item"
                                                   href="/stand/delete/${stand.id}">Удалить</a>
                                            </div>
                                        </div>
                                    </div>

                                    <a href="/stand/request/${stand.id}" class="resume-link">
                                        <#if stand.title?has_content>
                                            <p class="resume-name">${stand.title}</p>
                                        <#else>
                                            <p class="resume-name">Без заголовка</p>
                                        </#if>
                                        <#if stand.category?has_content>
                                            <p class="resume-category">Категория: ${stand.category}</p>
                                        </#if>
                                        <#if stand.publishedDate?has_content>
                                            <p class="resume-date">Дата создания: ${stand.publishedDate}</p>
                                        </#if>
                                    </a>
                                </div>
                            </#list>
                        <#else>
                            <p class="text-center mt-5">У вас еще нет запросов</p>
                        </#if>
                    </div>
                </div>
            </#if>
        </div>
    </div>
    <div id="modal" class="modal">
        <div class="modal-content">
            <div id="side-menu" class="side-menu">
                <div class="close-button" id="close-button">X</div>
                <ul>
                    <li><a href="profile/edit">Редактировать профиль</a></li>
                    <li><a href="/favourites">Посмотреть избранные</a></li>
                    <li><a href="/profile/add_contacts">Редактировать визитку</a></li>
                    <li><a href="/logout">Выйти из аккаунта</a></li>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                           value="${(_csrf.token)!'--no-token--'}"/>
                    <li><a href="#">
                            <div class="slider-container">
                                <span class="slider-label">Изменить тему:</span>
                                <input type="range" min="0" max="1" value="0" step="1" class="slider"
                                       id="themeToggle">
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/profile.js"></script>
    <script>
        function getThemeFromServer() {
            const storedTheme = localStorage.getItem('theme');
            if (storedTheme !== null) {
                applyThemeToPage(storedTheme);
                themeToggle.value = storedTheme;
            } else {
                const url = '/api/get-theme';
                fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        localStorage.setItem('theme', data);
                        applyThemeToPage(data);
                    })
                    .catch(error => {
                        console.error('Error getting theme from server:', error);
                    });
            }
        }

        function applyThemeToPage(theme) {

            const body = document.body;
            const otherElements = document.querySelectorAll('.other-elements');

            body.classList.toggle('dark-theme', theme == 1);
            otherElements.forEach(element => {
                element.classList.toggle('dark-theme', theme == 1);
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            getThemeFromServer();
        });
        const themeToggle = document.getElementById('themeToggle');
        const body = document.body;

        themeToggle.addEventListener('input', function () {
            const theme = parseInt(themeToggle.value);
            body.classList.toggle('dark-theme', theme === 1);
            localStorage.setItem('theme', theme);
            const otherElements = document.querySelectorAll('.other-elements');
            otherElements.forEach(element => {
                element.classList.toggle('dark-theme', theme === 1);
            });
            saveThemePreference(theme);
        });

        function saveThemePreference(theme) {
            const url = '/api/save-theme-preference';
            const csrfToken = document.querySelector('input[name="_csrf"]').value;

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': csrfToken
                },
                body: JSON.stringify({
                    theme
                }),
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Theme preference saved:', data);
                })
                .catch(error => {
                    console.error('Error saving theme preference:', error);
                });
        }


        document.addEventListener("DOMContentLoaded", function () {
            const tabButton = document.getElementById("stand-request-tab");
            const tabContent = document.querySelector('.stand-requests');

            tabButton.addEventListener("click", function () {
                if (tabContent.style.display === "none") {
                    tabContent.style.display = "block";
                } else {
                    tabContent.style.display = "none";
                }
            });
        });
    </script>
</@main.layout>

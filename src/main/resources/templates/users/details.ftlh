<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Настройки аккаунта</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/static/css/account_details.css">
    <a href="javascript:history.go(-1);" class="back-button">
        <i class="fas fa-arrow-left"></i>Назад
    </a>
    <div id="content" class="content">
        <#if isUserSpecialist??>
            <#if isUserSpecialist>
                <div class="qr-code-section" id="openModal">
                    <i class="fas fa-qrcode fa-3x"></i>
                    <p class="mt-2">Мой QR-код</p>
                </div>
            </#if>
        </#if>
        <div class="tabs mt-4">
            <div class="share-buttons">
                <button class="share-button facebook">
                    <i class="fab fa-facebook-f"></i>
                </button>
                <button class="share-button twitter">
                    <i class="fab fa-twitter"></i>
                </button>
                <button class="share-button linkedin">
                    <i class="fab fa-linkedin-in"></i>
                </button>
                <button class="share-button pinterest">
                    <i class="fab fa-pinterest"></i>
                </button>
                <button class="share-button whatsapp">
                    <i class="fab fa-whatsapp"></i>
                </button>
            </div>
        </div>
        <ul class="mt-4">
            <#if details??>
                <#if details.email?has_content>
                    <li><p>ваш город: ${details.geolocation}</p></li>
                <#else>
                    <li><p>ваш город: не указан</p></li>
                </#if>
                <#if details.geolocation??>
                    <li><p>email: ${details.email}</p></li>
                <#else>
                    <li><p>email: не указан</p></li>
                </#if>
            </#if>
            <li><a href="/profile/edit">Редактировать профиль</a></li>
            <li><a href="/favourites">Посмотреть избранные</a></li>
            <li><a href="/profile/add_contacts">Редактировать визитницу</a></li>
            <#if isUserSpecialist??>
                <#if isUserSpecialist>
                    <li><a href="/tariff">Выбрать тариф</a></li>
                </#if>
                <#if specialistId?has_content>
                    <li><a href="/rating/${specialistId}/reviews">Посмотреть отзывы</a></li>
                </#if>
            </#if>
            <li><a href="/logout">Выйти из аккаунта</a></li>
            <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                   value="${(_csrf.token)!'--no-token--'}"/>
            <li><p href="#">
                <div class="slider-container">
                    <span class="slider-label">Изменить тему:</span>
                    <input type="range" min="0" max="1" value="0" step="1" class="slider"
                           id="themeToggle">
                </div>
                </p>
            </li>
        </ul>
        <h4 class="text-center mt-3">Визитница</h4>
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
        </#if>
    </div>
    <div id="modal" class="modal">
        <div class="modal-content">
            <div id="side-menu" class="side-menu">
                <div class="close-button" id="close-button">X</div>
                <div class="qr-code-section">
                    <p class="mt-2">Мой QR-код</p>
                </div>
                <#if qrCodeBase64??>
                    <img src="data:image/png;base64,${qrCodeBase64}" alt="QR Code">
                </#if>
            </div>
        </div>
    </div>
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

        document.getElementById("openModal").addEventListener("click", function () {
            openModal();
        });

        document.getElementById("close-button").addEventListener("click", function () {
            closeModal()
        });

        function openModal() {
            document.getElementById("modal").style.display = "block";
        }

        function closeModal() {
            document.getElementById("modal").style.display = "none";
        }

        window.onclick = function (event) {
            var modal = document.getElementById("modal");
            if (event.target === modal) {
                closeModal();
            }
        };
    </script>
</@main.layout>
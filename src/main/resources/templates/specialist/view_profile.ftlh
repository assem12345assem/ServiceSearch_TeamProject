<#import "../layout.ftlh" as main>
<@main.layout>
    <link rel="stylesheet" href="/static/css/profileorigin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <title>Профиль пользователя</title>
    <div id="content" class="content">

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
                    <#if user.email?has_content>
                        <p>${user.email}</p>
                    </#if>
                </#if>
                <#if user.city?has_content>
                    <p class="text-center">город: ${user.city}</p>
                </#if>
                <#if user.role = "ROLE_SPECIALIST">
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
                </#if>
                <#if user.role = "ROLE_SPECIALIST">
                    <a href="/rating/${specialistId}/reviews" class="text-center">Посмотреть отзывы</a>
                </#if>
            </div>
            <#if user.role = "ROLE_SPECIALIST">
                <button class="leave-review-btn" id="openModalRating" onclick="openModalRating()">Оставить отзыв</button>
            </#if>
        </div>
        <div>
            <#if user.role = "ROLE_SPECIALIST">
                <div class="tabs">
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
                        <#if user.role = "ROLE_SPECIALIST">
                            <a href="/favourites/add/${specialistId}" type="button" class="btn btn-outline-success">Добавить в избранное</a>
                        </#if>
                    </div>
                </div>
                <div class="tabs">
                    <button class="tab-item" id="resume-tab">Резюме</button>
                    <button class="tab-item" id="portfolio-tab">Портфолио</button>
                </div>
                <div class="tab-content additional-mb" id="resume-content">
                    <div class="resume-list">
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
                                </div>
                            </#list>
                        <#else>
                            <p class="text-center mt-5">Пользователь еще не создал резюме</p>
                        </#if>
                    </div>
                </div>
                <div class="tab-content additional-mb" id="portfolio-content">
                    <div class="portfolio-list">
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
                            <p class="text-center mt-5">Пользователь еще не создал портфолио</p>
                        </#if>
                    </div>
                </div>
            <#elseif user.role = "ROLE_CUSTOMER">
                <div class="tab-content additional-mb" id="resume-content">
                    <div class="resume-list">
                        <#if stands?has_content>
                            <#list stands as stand>
                                <div class="resume">

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
                            <p class="text-center mt-5">Пользователь еще не создал запросов</p>
                        </#if>
                    </div>
                </div>
            </#if>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/profileForAnother.js"></script>

</@main.layout>
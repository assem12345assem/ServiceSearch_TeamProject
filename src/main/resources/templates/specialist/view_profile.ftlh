<#import "../layout.ftlh" as main>
<@main.layout>
    <link rel="stylesheet" href="/static/css/profileorigin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf_token" content="${_csrf.token}"/>
    <title>Профиль пользователя</title>
    <style>

        .close-button {
            position: absolute;
            top: 20px;
            right: 20px;
            cursor: pointer;
            font-size: 24px;
        }

        .full-stars {
            text-align: center;
        }

        .full-stars .rating-group {
            display: inline-flex;
        }

        .full-stars input {
            position: absolute;
            left: -9999px;
        }

        .full-stars label {
            margin: 0;
            cursor: pointer;
        }

        .full-stars label svg {
            margin: 2px;
            height: 40px;
            width: 40px;
            fill: #ffb300;
            transition: fill 0.3s;
        }

        .full-stars input:checked ~ label svg {
            fill: #BFE2FF;
        }

        .full-stars .rating-group:hover label svg {
            fill: #ffb300;
        }

        .full-stars .rating-group input:hover ~ label svg {
            fill: #BFE2FF;
        }

        #side-menu input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-top: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        #submit-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }

        #submit-button:hover {
            background-color: #45a049;
        }

        .close-button {
            position: absolute;
            top: 10px;
            left: 10px;
            cursor: pointer;
            font-size: 20px;
            color: #555;
        }

        .close-button:hover {
            color: #000;
        }


        .notification {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background-color: #4caf50;
            color: #fff;
            padding: 10px;
            text-align: center;
            z-index: 1000;
            margin: 20px;
            border-radius: 11px;
            display: none;
        }

        .notification.show {
            display: block;
            animation: fadeOut 4s ease-in-out;
        }

        .notificationError {
            background-color: red;
            color: white;
        }

        .leave-review-btn {
            position: fixed;
            bottom: 70px;
            left: 50%;
            width: 200px;
            transform: translateX(-50%);
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            z-index: 3;
        }


        .share-buttons {
            display: flex;
            gap: 10px;
        }

        .share-button {
            border: none;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
            font-size: 16px;
            padding: 8px 16px;
        }

        .facebook {
            background-color: #3b5998;
        }

        .twitter {
            background-color: #1da1f2;
        }

        .linkedin {
            background-color: #0077b5;
        }

        .pinterest {
            background-color: #bd081c;
        }

        .reddit {
            background-color: #ff4500;
        }

        .whatsapp {
            background-color: #25d366;
        }

        .social-tabs {
            margin: 30px 40px 0 40px;
            display: flex;
            justify-content: space-around;
            align-items: center;
            padding-bottom: 15px;
        }

        .add-to-favourites{
            display: flex;
            justify-content: center;
            margin: 0 20px;
            width: 300px;
        }
    </style>
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
                <button class="leave-review-btn" id="openModalRating">Оставить отзыв</button>
            </#if>
        </div>
        <div>
            <#if user.role = "ROLE_SPECIALIST">
                <div class="social-tabs">
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
                <#if user.role = "ROLE_SPECIALIST">
                    <a href="/favourites/add/${specialistId}" type="button" class="btn btn-outline-success add-to-favourites">Добавить в
                        избранное</a>
                </#if>
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
    <div id="modalRating" class="modal">
        <div class="modal-content">
            <div id="side-menu" class="side-menu">
                <div class="full-stars">
                    <div class="rating-group">
                        <input type="hidden" id="specialistId" value="${specialistId}">
                        <!-- по умолчанию 0 -->
                        <input name="fst" value="0" type="radio"
                               disabled checked/>

                        <!-- рейтинг 1 -->
                        <label for="fst-1">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512">
                                <path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                            </svg>
                        </label>
                        <input name="fst" id="fst-1" value="1"
                               type="radio"/>

                        <!-- рейтинг 2 -->
                        <label for="fst-2">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512">
                                <path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                            </svg>
                        </label>
                        <input name="fst" id="fst-2" value="2"
                               type="radio"/>

                        <!-- рейтинг 3 -->
                        <label for="fst-3">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512">
                                <path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                            </svg>
                        </label>
                        <input name="fst" id="fst-3" value="3"
                               type="radio"/>

                        <!-- рейтинг 4 -->
                        <label for="fst-4">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512">
                                <path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                            </svg>
                        </label>
                        <input name="fst" id="fst-4" value="4"
                               type="radio"/>

                        <!-- рейтинг 5 -->
                        <label for="fst-5">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512">
                                <path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                            </svg>
                        </label>
                        <input name="fst" id="fst-5" value="5"
                               type="radio"/>
                    </div>
                </div>
                <input type="text" placeholder="Оставьте отзыв"
                       id="review-input">
                <button id="submit-button" onclick="submitReview()">Отправить</button>
                <div class="close-button" onclick="closeModalRating()">×</div>
            </div>
        </div>
    </div>
    <div class="notification" id="notification">

    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/profileForAnother.js"></script>

</@main.layout>
<#import "../layout.ftlh" as main>
<@main.layout>
<link rel="stylesheet" href="/static/css/profile.css">
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="_csrf_token" content="${_csrf.token}"/>
<div id="content" class="content">
    <div class="col">
        <#--        <div id="menu-toggle" class="menu-toggle">-->
        <#--            <svg xmlns="http://www.w3.org/2000/svg" width="40"-->
        <#--                 height="40" fill="currentColor" class="bi bi-list"-->
        <#--                 id="openModal"-->
        <#--                 viewBox="0 0 16 16">-->
        <#--                <path fill-rule="evenodd"-->
        <#--                      d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>-->
        <#--            </svg>-->
        <#--        </div>-->
    </div>
    <div class="profile">
        <div class="profile-header row">
            <div class="profile-image-block col-4">
                <#if user.photo?has_content>
                    <img src="${user.photo}"
                         class="round-image" alt>
                <#else>
                    <img src="default.jpg" class="round-image" alt="default photo">
                </#if>
            </div>
            <div class="personal-info col-6">
                <#if user.userName?has_content>
                    <p class="username">${user.userName}</p>
                </#if>
                <#if user.email?has_content>
                    <p>${user.email}</p>
                </#if>
                <#if user.phoneNumber?has_content>
                    <p>${user.phoneNumber}</p>
                </#if>
                <#if user.city?has_content>
                    <p>Город: ${user.city}</p>
                </#if>
                <#if rating?has_content>
                    <div class="rating">
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="star fas fa-star"></span>
                        <span class="rating-number" id="rating">${rating}</span>
                    </div>
                </#if>
                <a href="/rating/${specialistId}/reviews">Посмотреть отзывы</a>
            </div>
        </div>
    </div>
    <button class="leave-review-btn"  id="openModalRating" onclick="openModalRating()">Оставить отзыв</button>

    <div>
        <div class="tabs">
            <button class="tab-item" id="resume-tab">Резюме</button>
            <button class="tab-item" id="portfolio-tab">Портфолио</button>
        </div>

        <div class="tab-content" id="resume-content">
            <div class="resume-list">
                <#if resumes?has_content>
                    <#list resumes as resume>
                        <div class="resume">
                            <a href="/resume/${resume.id}" class="resume-link">
                                <#if resume.header?has_content>
                                    <p class="resume-name">${resume.header}</p>
                                <#else>
                                    <p class="resume-name">Без заголовок</p>
                                </#if>
                                <#--                                    <p class="resume-experience">Опыт работы: ${resume.experience}</p>-->
                                <#--                                    <p class="resume-category">Категория: ${resume.category}</p>-->
                                <p class="resume-date">Дата создания: ${resume.timeOfResume}</p>
                            </a>
                        </div>
                    </#list>
                <#else>
                    <p>У этого специалиста нет резюме</p>
                </#if>
            </div>
        </div>

        <div class="tab-content" id="portfolio-content">
            <div class="portfolio-list">
                <#if portfolios?has_content>
                    <#list portfolios as portfolio>
                        <div class="portfolio">
                            <img src="${portfolio.photo}" alt class="portfolio-img">
                            <div>
                                <p>${portfolio.name}</p>
                                <p>Дата публикации: ${portfolio.createdDate}</p>
                            </div>
                        </div>
                    </#list>
                <#else>
                    <p>У этого специалиста нет портфолио</p>
                </#if>
            </div>
        </div>
    </div>
    <div id="modal" class="modal">
        <div class="modal-content">
            <div id="side-menu" class="side-menu">
                <div class="close-button" id="close-button">X</div>
                <ul>
                    <li><a href="#" id="add-fav">Добавить в избранное</a></li>
                    <li><a href="#" id="block-user">Заблокировать</a></li>
                </ul>
            </div>
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
                               disabled checked />

                        <!-- рейтинг 1 -->
                        <label for="fst-1">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512"><path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z" /></svg>
                        </label>
                        <input name="fst" id="fst-1" value="1"
                               type="radio" />

                        <!-- рейтинг 2 -->
                        <label for="fst-2">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512"><path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z" /></svg>
                        </label>
                        <input name="fst" id="fst-2" value="2"
                               type="radio" />

                        <!-- рейтинг 3 -->
                        <label for="fst-3">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512"><path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z" /></svg>
                        </label>
                        <input name="fst" id="fst-3" value="3"
                               type="radio" />

                        <!-- рейтинг 4 -->
                        <label for="fst-4">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512"><path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z" /></svg>
                        </label>
                        <input name="fst" id="fst-4" value="4"
                               type="radio" />

                        <!-- рейтинг 5 -->
                        <label for="fst-5">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 576 512"><path
                                        d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z" /></svg>
                        </label>
                        <input name="fst" id="fst-5" value="5"
                               type="radio" />
                    </div>
                </div>
                <input type="text" placeholder="Оставьте отзыв"
                       id="review-input">
                <button id="submit-button" onclick="submitReview()">Отправить</button>
                <div class="close-button" onclick="closeModal()">×</div>
            </div>
        </div>
    </div>
    <div class="notification" id="notification">

    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/profile.js"></script>
    </@main.layout>

<#import '../layout.ftlh' as main>
<@main.layout>
    <title>Запросы на стенд</title>
    <header xmlns="http://www.w3.org/1999/html">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
              crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                crossorigin="anonymous"></script>
        <link rel="stylesheet" href="/static/css/profile.css">
    </header>
    <div class="padding-div">
    <div class="category-header">
        <a href="javascript:history.go(-1);" class="back-button">
            <i class="fas fa-arrow-left"></i>Назад
        </a>
    </div>
    <h1 class="text-center"> Запрос пользователя </h1>
    <div class="task-content">
        <#if post??>
            <div class="task-details mt-3 me-2">
                <div class="row">
                    <div class="col-2 user-photo">
                        <img src="${post.userPhoto}" alt="User Photo">
                    </div>
                    <div class="col-3 text-center">${post.userName}</div>
                </div>
                <hr>
                <div class="description">
                    <i class="fa-solid fa-calendar-days"></i> Когда: ${post.workRequiredTime}
                    <br>
                    ${post.title}
                    <br>
                    ${post.description}
                </div>
                <hr>
                <div class="response-info">
                    <div class="responses-count">
                        <p>Откликнулось специалистов: ${post.responseNumber}</p>
                        <p>Дата публикации: ${post.publishedDate}</p>
                    </div>

                </div>
            </div>
        <#else>
            Данный запрос больше не актуален.
        </#if>
    </div>
    <div>

        <div class="tab-content bottom-margin" id="resume-content">
            <h2 class="text-center">Откликнувшиеся специалисты</h2>
            <div class="resume-list">
                <#if conversations??>
                    <#if conversations?has_content>
                        <#list conversations as item>
                            <#assign varId = item.conversationId>
                            <div class="message-card"><a href="/profile/${item.userId}"
                                                                 class="link-profile-stand">${item.userName}</a>
                                <a class="stand-button chatb"
                                   href="/stand/request_detail/${item.conversationId}">Чат</a>
                                <a class="stand-button selectb" href="/stand/select/${item.conversationId}">Выбрать</a>
                            </div>

                        </#list>
                    <#else>
                        <p>На данный запрос еще никто не откликнулся.</p>
                    </#if>
                </#if>
            </div>
        </div>
    </div>
    <style>
        .bottom-margin {
            margin-bottom: 20px;
            padding: 30px;
        }

        .padding-div {
            padding: 30px;
        }

        .category-card span {
            margin-top: 10px;
            font-size: 12px;
            font-weight: 600;
        }

        .task-content {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 30px;
        }

        .task-details {
            border: 1px solid #ccc;
            border-radius: 15px;
            padding: 30px;
            width: 100%;
        }

        .user-photo img {
            margin-right: 10px;
            width: 50px;
            height: 50px;
            object-fit: cover;
        }
        .description {
            margin-top: 10px;
        }
        .response-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .responses-count {
            color: #747373;
            margin-bottom: 20px;
        }
        .back-button {
            text-decoration: none;
            color: #2552e7;
            display: flex;
            align-items: center;
            font-size: 18px;
            margin-right: 40px;
            margin-left: 10px;
        }
        .message-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0.0, 0.0, 0.2, 0.2);
            margin: 10px;
            display: flex;
            height: 90px;
            flex-direction: row;
            padding: 20px 30px;
            position: relative;
        }
        .dark-theme .message-card {
            background-color: #333;
            color: #fff;
            box-shadow: 0 5px 15px rgba(247, 241, 241, 0.614);
        }
        .stand-button {
            background-color: #fff;
            padding: 10px 30px;
            border-radius: 10px;
            text-decoration: none;
            position: absolute;
            top: 25px;
        }
        @media (max-width: 600px) {
            .message-card {
                flex-direction: column;
                align-items: center;
                height: auto;
            }

            .stand-button {
                position: static;
                margin-top: 10px;
            }
        }
        .chatb {
            border: 2px solid #2552e7;
            color: #2552e7;
            right: 35%;

        }
        .chatb:hover {
            background-color: #2552e7;
            color: #fff;
        }

        .selectb {
            border: 2px solid green;
            color: green;
            right: 5%;
        }
        .selectb:hover {
            background-color: green;
            color: #fff;
        }
        .link-profile-stand {
            color: black;
            text-decoration: none;
            padding-top: 13px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/profile.js"></script>
</@main.layout>
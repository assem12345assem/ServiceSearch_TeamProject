<#import "../layout.ftlh" as main>
<@main.layout>
<title>Стенд</title>
<h1 class="text-center"> Стенд </h1>
<div class="p-5">
    <#if viewer??>
        <div class="stand mb-4">
            <#if (viewer.specialistId)??>

                <h2>Мои отклики</h2>
                <#if myResponses??>
                    <#if myResponses?has_content>
                        <#list myResponses as item>
                            <a class="response-link" href="/stand/respond/${item.postId}"><i class="fas fa-check"></i>
                                ${item.postTitle}</a> <br>
                        </#list>
                    <#else>
                        <p class="ms-4">У Вас нет откликов на актуальные запросы.</p>
                    </#if>
                </#if>

                <h2 class="mt-3">Мои подписки</h2>
                <#if myPosts??>
                    <#if myPosts?has_content>
                        <#list myPosts as item>
                            <div class="category">${item.category}</div>
                            <#if (item.postDtoList)?? && (item.postDtoList?size > 0)>
                                <ul class="tasks">
                                    <#list (item.postDtoList) as post>
                                        <li class="task"> ${post.title}</li>
                                        <div class="task-content">
                                            <div class="task-details mt-3 me-2">
                                                <div class="row">
                                                    <div class="col-2 user-photo">
                                                        <img src="${post.userPhoto}" alt="User Photo">
                                                    </div>
                                                    <div class="col-3 text-center">${post.userName}</div>
                                                </div>
                                                <hr>
                                                <div class="description">
                                                    <i class="fa-solid fa-calendar-days"></i>
                                                    Когда: ${post.workRequiredTime}
                                                    <br>
                                                    ${post.title}
                                                    <br>
                                                    ${post.description}
                                                </div>
                                                <hr>
                                                <div class="response-info">
                                                    <div class="responses-count"><p>Откликнулось
                                                            специалистов: ${post.responseNumber}</p>
                                                        <p>Дата публикации: ${post.publishedDate}</p></div>
                                                    <div class="">
                                                        <#if (viewer.specialistId)??>
                                                            <a href="/stand/respond/${post.id}"
                                                               class="respond-button my-3">Откликнуться</a>
                                                        </#if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </#list>
                                </ul>
                            </#if>
                        </#list>
                    <#else>
                        <p class="ms-4"> Вы не подписались ни на одну категорию.</p>
                    </#if>
                </#if>


            <#else>
                <h2>Мои запросы</h2>
                <#if myRequests??>
                    <#list myRequests as item>
                        <a class="response-link" href="/stand/request/${item.postId}"><i class="fas fa-check"></i>
                            ${item.postTitle}</a> <br>
                    </#list>
                </#if>
            </#if>
        </div>
    </#if>
    <div class="stand mb-4">
        <div id="stand">
            <h2>Все категории</h2>
            <#if posts??>
                <#list posts as item>
                    <div class="category">${item.category}</div>
                    <#if (item.postDtoList)?? && (item.postDtoList?size > 0)>
                        <ul class="tasks">
                            <#list (item.postDtoList) as post>
                                <li class="task"> ${post.title}</li>
                                <div class="task-content">
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
                                            <div class="responses-count"><p>Откликнулось
                                                    специалистов: ${post.responseNumber}</p>
                                                <p>Дата публикации: ${post.publishedDate}</p></div>
                                            <div class="">
                                                <#if (viewer.specialistId)??>
                                                    <#if (viewer.specialistAuthority)??>
                                                        <#if (viewer.specialistAuthority) == 'full'>
                                                            <a href="/stand/respond/${post.id}"
                                                               class="respond-button my-3">Откликнуться</a>
                                                        </#if>
                                                    <#else>
                                                        Вы не можете откликнуться в бесплатном режиме.
                                                    </#if>
                                                </#if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </#list>
                        </ul>
                    <#else>
                        В данной категории нет запросов
                    </#if>
                </#list>
            </#if>


        </div>
    </div>
    <style>
        .category {
            font-weight: bold;
            border-radius: 15px;
            margin: 25px 10px;
            box-shadow: 5px -5px 15px rgba(0.0, 0.0, 0.1, 0.2);
            background-color: white;
            text-decoration: none;
            display: flex;
            flex-direction: row;
            align-items: center;
            padding: 25px;
            cursor: pointer;
        }

        .dark-theme .category {
            box-shadow: 5px -5px 15px rgba(247, 241, 241, 0.614);
            background-color: #333;
        }

        .category:hover {
            background-color: #2552e7;
            color: white;
        }

        .dark-theme .category:hover {
            background-color: white;
            color: black;
        }

        .category::after {
            padding-left: 30px;
            font-family: 'Font Awesome 5 Free';
            content: "\f196";
            margin-left: auto;
            font-size: 30px;
            color: #4b6ad0;
        }

        .category.collapsed::after {
            content: "\f147";
        }

        #content {
            padding-bottom: 60px;
            overflow-y: scroll;
            height: calc(100vh - 60px);
        }

        .response-link {
            color: black;
            text-decoration: none;
            margin-left: 20px;
        }

        .dark-theme .response-link {
            color: #d9d9d9;

        }

        .response-link:hover {
            color: mediumpurple;
        }

        .tasks {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: none;
        }

        .task {
            margin-left: 20px;
            padding: 10px 15px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            cursor: pointer;
            /* Make it clickable */
        }

        .task-content {
            display: none;
            align-items: center;
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

        .respond-button {
            padding: 15px 20px;
            background-color: #4b6ad0;
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 15px;
            text-decoration: none;
        }

        .task::before {
            content: "\f11e";
            font-family: 'Font Awesome 5 Free';
            margin-right: 20px;
            font-size: 20px;
        }

        .task:not(:last-child) {
            padding-bottom: 15px;
            border-bottom: 1px solid #ccc;
        }

        .task-content.hidden {
            display: none;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const categories = document.querySelectorAll('.category');

            categories.forEach(function (category) {
                category.addEventListener('click', function () {
                    const tasks = this.nextElementSibling;

                    if (tasks.style.display === 'none' || tasks.style.display === '') {
                        tasks.style.display = 'block';
                    } else {
                        tasks.style.display = 'none';
                    }
                });
            });

            const tasks = document.querySelectorAll('.task');

            tasks.forEach((function (task) {
                task.addEventListener('click', function () {
                    const posts = this.nextElementSibling;
                    if (posts.style.display === 'none' || posts.style.display === '') {
                        posts.style.display = 'flex';
                    } else {
                        posts.style.display = 'none';
                    }
                });

            }))
        })


    </script>
    </@main.layout>



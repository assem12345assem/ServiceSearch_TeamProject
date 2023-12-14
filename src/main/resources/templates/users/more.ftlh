<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .user-card {
            margin-bottom: 20px;
        }

        .resume-card {
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            padding: 20px;
            transition: box-shadow 0.3s ease-in-out;
        }

        .resume-card:hover {
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        #cart {
            height: 220px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card user-card">
        <div class="card-header">
            Данные о пользователе
        </div>
        <div class="card-body">
            <h5 class="card-title">Имя: ${user.userName}</h5>
            <p class="card-text">City: ${user.city}</p>
            <p class="card-text">Роль: ${user.role}</p>
        </div>
    </div>

    <#if resumes??>
        <div class="mt-5">
            <h2>Резюме</h2>

            <div class="row row-cols-1 row-cols-md-2">
                <#list resumes as resume>
                    <div class="col mb-4">
                        <div class="card resume-card" id="cart">
                            <div class="card-body">
                                <h5 class="card-title">${resume.header}</h5>
                                <p class="card-text">Description: ${resume.resumeDescription}</p>
                                <p class="card-text">Date: ${resume.timeOfResume}</p>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>

        </div>
    </#if>

    <#if posts??>
        <div class="mt-5">
            <h2>Посты</h2>
            <div class="row row-cols-1 row-cols-md-2">
                <#list posts as post>
                    <div class="col mb-4">
                        <div class="card resume-card" id="cart">
                            <div class="card-body">
                                <h5 class="card-title">${post.title}</h5>
                                <p class="card-text">Description: ${post.description}</p>
                                <p class="card-text">Date: ${post.publishedDate}</p>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </div>
    </#if>
</div>


<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>

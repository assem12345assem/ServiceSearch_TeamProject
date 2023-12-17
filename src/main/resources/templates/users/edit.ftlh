<#import "../layout.ftlh" as main>
<@main.layout>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Редактировать профиль</title>
    <style>

        .profile-image-container {
            text-align: center;
        }

        .dark-theme .profile-image-container,
        .dark-theme .card-header,
        .dark-theme .card-body,
        .dark-theme .form-control,
        .dark-theme .form-select {
            background-color: #333;
            color: white
        }

        .profile-image {
            width: 150px;
            height: 150px;
            border: 5px solid #fff;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 10px;
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        #center {
            border: none;
            position: absolute;
            top: 30%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 10px;
        }

    </style>
    <div class="content">
        <#if restricted??>
            <div id="center" class="empty-favorites text-center"
                 style="background-color: rgba(0, 123, 255, 0.6); border-radius: 10px; padding: 20px; margin-top: 40px;">
                <i class="fas fa-info-circle text-light" style="font-size: 48px;"></i>
                <#--            <h3 class="text-light">Вы не можете обновлять профиль больше 5 раз в месяц!</h3>-->

            </div>
        <#else>
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h2>Редактировать профиль</h2>
                            </div>
                            <div class="card-body">
                                <form action="/profile/edit" method="post" enctype="multipart/form-data">
                                    <#if _csrf??>
                                        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                               value="${(_csrf.token)!'csrf-token'}"/>

                                    </#if>

                                    <div class="mb-3 text-center">
                                        <label for="profileImage" class="form-label visually-hidden">Profile Image</label>
                                        <div class="profile-image-container">
                                            <div class="profile-image">
                                                <img id="preview"
                                                     src="${user.photo}"
                                                     alt="Profile Image">
                                            </div>
                                            <label for="fileInput" style="background-color: #2552E7;"
                                                   class="btn btn-primary">
                                                <i class="bi bi-camera"></i> Вставить фото
                                            </label>
                                            <input type="file" accept="image/*" class="my-3 fileInput" id="fileInput"
                                                   name="fileInput"
                                                   style="visibility:hidden;" onchange="previewImage(this);">
                                            <div id="imagePreview"
                                                 style="margin-top: 10px; width: 30px; height: 30px;"></div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <#assign username = user.userName!>
                                        <label for="username" class="form-label">Имя пользователя:</label>
                                        <input type="text" class="form-control" id="username" name="userName"
                                               value="${username}" required>
                                    </div>
                                    <div class="mb-3" id="countries">
                                        <#assign val = -1>
                                        <#if countries??>
                                            <select name="country" id="" class="form-select">
                                                <#list countries as item>
                                                    <option value="${item.country}">${item.country}
                                                        <#assign val = item_index>
                                                    </option>
                                                </#list>
                                            </select>
                                        </#if>

                                    </div>
                                    <div class=" mb-3" id="cities">
                                        <#if countries??>
                                            <select name="city" class="form-select">
                                                <#if (val > -1)>
                                                    <#list countries[val].cities as city>
                                                        <option value="${city}">${city}</option>
                                                    </#list>
                                                </#if>
                                            </select>
                                        </#if>
                                    </div>
                                    <#--
                                    <#--                                <div class="mb-3">-->
                                    <#--                                    <label for="email" class="form-label">Email</label>-->
                                    <#--                                    <#assign email = user.email!>-->
                                    <#--                                    <input type="email" class="form-control" id="email" name="email"-->
                                    <#--                                           value="${email}" required>-->
                                    <#--                                </div>-->

                                    <button style="background-color: #2552E7;" type="submit" class="btn btn-primary">
                                        Сохранить
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </#if>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewImage(input) {
            const preview = document.getElementById('preview');

            if (input.files && input.files[0]) {
                const reader = new FileReader();

                reader.onload = function (e) {
                    preview.src = e.target.result;
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</@main.layout>
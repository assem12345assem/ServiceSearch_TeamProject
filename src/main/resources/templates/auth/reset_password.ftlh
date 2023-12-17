<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Восстановление пароля</title>
    <style>
        #send-button {
            width: 100%;
            height: 45px;
            border: none;
            border-radius: 5px;
        }

        .active {
            background-color: #0080ff;
            color: white;
        }

        .succes {
            color: #25d366;
        }
    </style>
    <body>
<section class="h-100">
    <div class="container h-100">
        <div class="row justify-content-sm-center h-100">
            <div class="col-xxl-4 col-xl-5 col-lg-5 col-md-7 col-sm-9">
                <div class="text-center my-5">
                </div>
                <div class="card shadow-lg" style="border-radius: 15px; margin-top: 100px;">
                    <div class="card-body p-5">
                        <h2 class="fs-4 card-title fw-bold mb-4 text-center">Сбросить пароль</h2>
                        <form action="/auth/reset_password" method="post" class="text-center">
                            <#if _csrf??>
                                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                       value="${(_csrf.token)!'csrf-token'}"/>
                            </#if>
                            <#if error?has_content>
                                <b class="text-danger text-center mb-2">${error}</b>
                            </#if>
                            <div class="mb-3 mt-3">
                                <input type="hidden" name="token" value="${token!}">

                                <input id="password" type="password" class="form-control" name="password"
                                       placeholder="Введите ваш новый пароль" required autofocus/>
                            </div>

                            <button type="submit" class="active" id="send-button">
                                Изменить пароль
                            </button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</@main.layout>
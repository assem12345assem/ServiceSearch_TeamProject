<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Забыли пароль?</title>
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

        .succes{
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
                        <h2 class="fs-4 card-title fw-bold mb-4 text-center">Забыли пароль</h2>
                        <form action="/auth/forgot_password" method="post" class="text-center">
                            <#if _csrf??>
                                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                       value="${(_csrf.token)!'csrf-token'}"/>
                            </#if>
                            <#if error??>
                                <b class="text-danger text-center mb-2">${error}</b>
                            <#elseif message??>
                                <b class="succes">${message}</b>
                            <#else>
                                <div>
                                    <p class="text-center">Мы отправим вам ссылку для сброса пароля на вашу электронную
                                        почту.</p>
                                </div>
                            </#if>

                            <div class="mb-3 mt-3">

                                <input id="email" type="email" class="form-control" name="email"
                                       placeholder="Введите вашу электронную почту" required autofocus/>
                            </div>

                            <button type="submit" class="active" id="send-button">
                                Отправить
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</@main.layout>
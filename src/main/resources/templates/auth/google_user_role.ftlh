<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Регистрация</title>
    <style>
        select {
            -webkit-appearance: none;
            -moz-appearance: none;
            text-indent: 1px;
            text-overflow: '';
            width: 75px;
            padding-left: 3px;
        }

        #send-button {
            width: 100%;
            height: 45px;
            border: none;
            border-radius: 5px;
        }

        .active{
            background-color: #0080ff;
            color: white;
        }
    </style>
    <section class="h-100">
        <div class="container h-100">
            <div class="row justify-content-sm-center h-100">
                <div class="col-xxl-4 col-xl-5 col-lg-5 col-md-7 col-sm-9">
                    <div class="text-center my-5">
                    </div>
                    <div class="card shadow-lg" style="border-radius: 15px; margin-top: 100px;">
                        <div class="card-body p-5">
                            <h1 class="fs-4 card-title fw-bold mb-4">Зарегистрироваться</h1>
                            <form method="post" class="needs-validation" action="/auth/login" id="/login-form"  onsubmit="return validateAndSubmit()">

                                <div class="mb-3">
                                    <label class="label-text" for="role" style="display: none">Выберите кто Вы:</label>
                                    <br>
                                    <select id="role" class="form-select" name="role" required>
                                        <option value="" disabled selected>Выберите кто Вы:</option>
                                        <#list roles as role>
                                            <#if role != 'ROLE_ADMIN'>
                                                <option value="${role}">
                                                    <#if role == 'ROLE_SPECIALIST'>
                                                        Я специалист
                                                    <#elseif role == 'ROLE_CUSTOMER'>
                                                        Я ищу специалиста
                                                    </#if>
                                                </option>
                                            </#if>
                                        </#list>
                                    </select>
                                </div>

                                <div class="mb-3" id="countries">
                                    <#assign val = -1>
                                    <#if countries??>
                                        <select name="country" id="" class="form-select" >
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
                                        <select name="city" class="form-select" >
                                            <#if (val > -1)>
                                                <#list countries[val].cities as city>
                                                    <option value="${city}">${city}</option>
                                                </#list>
                                            </#if>
                                        </select>
                                    </#if>
                                </div>

                                <button type="submit" class="active" id="send-button" >
                                    Потвердить
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</@main.layout>
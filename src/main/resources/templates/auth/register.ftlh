<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Регистрация</title>
    <style>
        flag-icon {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }

        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .flag-icon {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }

        .phone-input-group {
            display: flex;
            align-items: center;
        }

        #countrySelect {
            flex-shrink: 0;
            margin-right: 10px;
        }

        .country {
            height: 37px;
            background-color: transparent;
            border-radius: 4px;
            border: 1px solid #ced4da;

        }
        .dark-theme .country {
            color: white;
        }

        select {
            -webkit-appearance: none;
            -moz-appearance: none;
            text-indent: 1px;
            text-overflow: '';
            width: 75px;
            padding-left: 3px;
        }

        .register-text {
            color: #0080ff;
        }

        #send-button {
            width: 100%;
            height: 45px;
        }

        .button-register{
            border-radius: 5px;
            border: none;
        }

        .active {
            background-color: #2552e7;
            color: white;
        }

        .not-active {
            background-color: #919293;
            border-color: #babbbd;
            color: white;
        }

        #phone.is-invalid {
            border-color: #dc3545 !important;
        }

        #phone.is-invalid:focus {
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important;
        }

        .google-login-btn {
            background-color: #fff;
            color: #2552e7;
            border-radius: 5px;
            border: 1px solid #2552e7;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .google-login-btn:hover {
            background-color: #f5f5f5;
        }
        .dark-theme input::placeholder {
            color: white;
        }
    </style>
    <body>
    <section class="h-100">
        <div class="container h-100">
            <div class="row justify-content-sm-center h-100">
                <div class="col-xxl-4 col-xl-5 col-lg-5 col-md-7 col-sm-9">
                    <div class="card shadow-lg" style="border-radius: 15px; margin-top: 70px;">
                        <div class="card-body p-5">
                            <h1 class="fs-4 card-title fw-bold mb-4">Регистрация</h1>
                            <form method="post" class="needs-validation" action="/auth/register">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <div class="mb-3">
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
                                <label class="mb-2" for="email">Телефон Номер</label>
                                <div class="mb-3 phone-input-group">
                                    <select id="countrySelect" name="phoneNumberCode" onchange="changeCountry()"
                                            class="country" required>
                                        <#if countryCodes?has_content>
                                            <#list countryCodes as code>
                                                <option value="${code.code}">${code.icon} +${code.code}</option>
                                            </#list>
                                        </#if>
                                    </select>
                                    <input id="phone" type="number" class="form-control" name="phoneNumber" value=""
                                           placeholder="(555) 00 00 00" required autofocus>
                                </div>

                                <div class="mb-3">
                                    <div class="mb-2 w-100">
                                        <label class="" for="password">Пароль</label>
                                    </div>
                                    <input id="password" type="password" class="form-control" name="password" required>
                                </div>

                                <button type="button" class="button-register active not-active" id="send-button">
                                    Зарегистрироваться
                                </button>
                            </form>
                            <div class="google-login-btn mt-3">
                                <a class="btn tab-item" href="/oauth2/authorization/google" style="font-size: 13px; color: #2552e7;">
                                    <svg width="30px" height="30px" viewBox="0 0 32 32" fill="none"
                                         xmlns="http://www.w3.org/2000/svg">
                                        <path d="M30.0014 16.3109C30.0014 15.1598 29.9061 14.3198 29.6998 13.4487H16.2871V18.6442H24.1601C24.0014 19.9354 23.1442 21.8798 21.2394 23.1864L21.2127 23.3604L25.4536 26.58L25.7474 26.6087C28.4458 24.1665 30.0014 20.5731 30.0014 16.3109Z"
                                              fill="#4285F4"/>
                                        <path d="M16.2863 29.9998C20.1434 29.9998 23.3814 28.7553 25.7466 26.6086L21.2386 23.1863C20.0323 24.0108 18.4132 24.5863 16.2863 24.5863C12.5086 24.5863 9.30225 22.1441 8.15929 18.7686L7.99176 18.7825L3.58208 22.127L3.52441 22.2841C5.87359 26.8574 10.699 29.9998 16.2863 29.9998Z"
                                              fill="#34A853"/>
                                        <path d="M8.15964 18.769C7.85806 17.8979 7.68352 16.9645 7.68352 16.0001C7.68352 15.0356 7.85806 14.1023 8.14377 13.2312L8.13578 13.0456L3.67083 9.64746L3.52475 9.71556C2.55654 11.6134 2.00098 13.7445 2.00098 16.0001C2.00098 18.2556 2.55654 20.3867 3.52475 22.2845L8.15964 18.769Z"
                                              fill="#FBBC05"/>
                                        <path d="M16.2864 7.4133C18.9689 7.4133 20.7784 8.54885 21.8102 9.4978L25.8419 5.64C23.3658 3.38445 20.1435 2 16.2864 2C10.699 2 5.8736 5.1422 3.52441 9.71549L8.14345 13.2311C9.30229 9.85555 12.5086 7.4133 16.2864 7.4133Z"
                                              fill="#EB4335"/>
                                    </svg>
                                    Зарегистрируйтесь через Google
                                </a>
                            </div>
                        </div>
                        <div class="card-footer py-3 border-0">
                            <div class="text-center">
                                У вас уже есть аккаунт?<a href="/auth/login" class="text-dark-link"> Войти</a>
<#--                                <p class="text-danger pt-2 text-center">${error.text}</p>-->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <script>
        document.getElementById('phone').addEventListener('input', function () {
            var phoneInput = this;
            var sendButton = document.getElementById("send-button")
            var phoneNumber = phoneInput.value.trim();

            if (/^\d{9}$/.test(phoneNumber) && !phoneNumber.startsWith('0')) {
                sendButton.setAttribute('type', 'submit');
                sendButton.classList.remove('not-active');
                phoneInput.classList.remove('is-invalid');
                document.getElementById('login-form').classList.remove('was-validated');
                console.log("hello world")
            } else {
                sendButton.classList.add('not-active');
                sendButton.setAttribute('type', 'button');
                phoneInput.classList.add('is-invalid');
                document.getElementById('login-form').classList.add('was-validated');
                sendButton.classList.remove('btn-primary');
            }
        });
    </script>
    </body>
    </html>
</@main.layout>
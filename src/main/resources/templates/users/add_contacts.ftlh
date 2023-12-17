<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Визитница</title>
    <header>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
              crossorigin="anonymous">
    </header>
    <div class="container">
        <div class="content">
            <div class="form-center">
                <a href="javascript:history.go(-1);" class="back-button">
                    <i class="fas fa-arrow-left"></i>Назад
                </a>
                <h4 class="pt-3 ps-5">Добавить средства связи</h4>
                <#if businessCard??>
                    <#if businessCard?has_content>
                        Мои данные:
                        <table class="table">
                            <thead>
                            <tr>
                                <th scope="col">Поле</th>
                                <th scope="col">Контактные данные</th>
                                <th scope="col">Удалить</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list businessCard as bc>
                                <tr>
                                    <td>bc.contactType</td>
                                    <td>bc.contactValue</td>
                                    <td>
                                        <a class="btn plus-btn" href="/contact/contact-item/delete?contactType=${bc.contactType}&contactValue=${bc.contactValue}">-</a>
                                    </td>
                                </tr>
                            </#list>

                            </tbody>
                        </table>
                    </#if>
                </#if>
                <form id="contactForm" action="/profile/submit-contact-info" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <div id="contactPairsContainer">
                        <div class="contact-pair">
                            <label for="contactType" class="label-item">Поле:</label>
                            <#if contactTypes??>
                                <#if contactTypes?has_content>
                                    <select name="contactType" class="select-item">
                                        <#list contactTypes as item>
                                            <option value="${item}"> ${item}</option>
                                        </#list>
                                    </select>
                                </#if>
                            </#if>
                            <label for="contactValue" class="label-item">Контактные данные:</label>
                            <input type="text" name="contactValue" class="input-item">

                        </div>
                    </div>

                    <button type="button" class="plus-btn" id="addContactButton">+</button>

                    <input type="submit" value="Добавить" class="plus-btn">
                </form>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {

            const contactInfoList = [];

            function addContactPair() {
                const container = document.getElementById('contactPairsContainer');
                const template = document.querySelector('.contact-pair');
                const newContactPair = template.cloneNode(true);

                newContactPair.querySelector('[name="contactType"]').value = '';
                newContactPair.querySelector('[name="contactValue"]').value = '';

                container.appendChild(newContactPair);
            }


            document.getElementById('addContactButton').addEventListener('click', addContactPair);

            document.getElementById('contactForm').addEventListener('submit', function (event) {
                event.preventDefault();

                const contactPairs = Array.from(document.querySelectorAll('.contact-pair'));

                contactPairs.forEach(contactPair => {
                    const contactType = contactPair.querySelector('[name="contactType"]').value;
                    const contactValue = contactPair.querySelector('[name="contactValue"]').value;

                    if (contactType && contactValue) {
                        contactInfoList.push({contactType, contactValue});
                    }
                });

                console.log('Contact Info List:', contactInfoList);
                const csrfToken = document.querySelector('input[name="_csrf"]').value;
                fetch('/profile/submit-contact-info', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify(contactInfoList),
                })
                    .then(response => {
                        console.log(response.text())
                        window.location.href = "/profile";
                    })

                    .catch(error => {
                        console.error('Fetch error:', error);
                    });
            });

        });


    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous">
    </script>
    <style>
        .form-center {
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        .contact-pair {
            margin-top: 30px;
            justify-content: center;
            display: flex;
            flex-direction: column;

        }

        .plus-btn {
            display: block;
            margin: 20px auto;
            padding: 4px 13px;
            border-radius: 5px;
            border: 1px solid #2552e7;
            background-color: #fff;
        }

        .plus-btn:hover {
            background-color: #2552e7;
            color: #fff;
        }

        .select-item {
            border: 1px solid #2552e7;
            border-radius: 5px;
            height: 30px;
            font-size: 16px;
            width: 200px;
            margin-right: 20px;
            margin-left: 85px;
        }

        .input-item {
            border: 1px solid #2552e7;
            border-radius: 5px;
            padding: 3px 10px;
            font-size: 16px;
            width: 200px;
            margin-left: 85px;

        }

        .label-item {
            margin: 10px 0 10px 80px;
            font-size: 16px;
        }
    </style>
</@main.layout>
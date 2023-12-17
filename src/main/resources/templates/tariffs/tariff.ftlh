<#import "../layout.ftlh" as main>
<@main.layout>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Выбор тарифа</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        .tariff-card {
            cursor: pointer;
        }

        .tariff-card:hover {
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
    </style>

    <div class="container mt-5">
        <div style="display: flex; justify-content: center; height: 30vh;">
            <img src="https://cdn.icon-icons.com/icons2/2427/PNG/512/cash_icon_147027.png" style="width: 250px; height: 250px; object-fit: contain;">
        </div>

        <div class="row">
            <!-- Paid Tariff -->
            <div class="col-md-6">
                <div class="card tariff-card mb-4" data-toggle="modal" data-target="#confirmationModal" data-tariff-type="Paid Tariff" style="background-color:rgb(221, 221, 36)">
                    <div class="card-body">
                        <h5 class="card-title">Платный</h5>
                        <p class="card-text" style="height:50px;">Вы можете создавать визитку,размещать резюме на стенде и загружать порфолио</p>
                    </div>
                </div>
            </div>
        </div>
        <div>
            <h3 class="mb-4">Доступные тарифы</h3>
            <table class="table">
                <thead>
                <tr>
                    <th scope="col">Вид</th>
                    <th scope="col">Стоимость</th>
                    <th scope="col">Функционал</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th scope="row">Бесплатный</th>
                    <td>0.00</td>
                    <td>Создание визитки, возможность размещать ссылку на свой профиль в соц.сетях.</td>
                </tr>
                <tr>
                    <th scope="row">Помесячный</th>
                    <td>0.00</td>
                    <td rowspan="4">Отображение специалиста в поиске, возможность отвечать на запросы в стенде и
                        размещать резюме</td>
                </tr>
                <tr>
                    <th scope="row">Поквартальный</th>
                    <td>0.00</td>
                </tr>
                <tr>
                    <th scope="row">Полугодовой</th>
                    <td>0.00</td>
                </tr>
                <tr>
                    <th scope="row">Годовой</th>
                    <td>0.00</td>
                </tr>
                </tbody>
            </table>
        </div>
        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Подтверждение</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Вы уверены что хотите выбрать именно этот тариф <span id="selectedTariffType"></span>?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Отменить</button>
                        <button type="button" class="btn btn-primary" data-dismiss="modal" data-toggle="modal" data-target="#paymentModal">Подтвердить</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Modal -->
        <div class="modal fade" id="paymentModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Оплата</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form id="paymentForm" action="/tariff/save" method="POST">
                            <input type="text" placeholder="Введите номер карты" name="cardNumber" required><br><br>
                            <input type="text" placeholder="Срок действия" name="expiryDate" required><br><br>
                            <input type="text" placeholder="CVV" name="cvv" required><br><br>
                            <button type="submit" class="btn btn-primary">Оплатить</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Success Message Modal -->
        <div class="modal fade" id="successMessageModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Успех</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Вы успешно выбрали свой тариф и оплатили его.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap and jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

    <script>
        $(document).ready(function () {
            // Handle click on tariff card to update modal content
            $('.tariff-card').click(function () {
                var tariffType = $(this).data('tariff-type');
                $('#selectedTariffType').text(tariffType);
            });

            // Handle payment form submission
            $('#paymentForm').submit(function (event) {
                event.preventDefault();
                $('#paymentModal').modal('hide');
                $('#successMessageModal').modal('show');
            });
        });
    </script>

</@main.layout>
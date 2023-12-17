<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Избранные</title>
    <link rel="stylesheet" href="../../static/css/favourites.css">
    <div id="content" class="content">
        <h1 class="text-center" style="margin-top: 20px;">Избранные</h1>

        <div class="p-5">
            <div class="stand mb-4">

                <div class="row justify-content-center">
                    <#list favourites as favorite>
                        <div class="col-md-6 mb-4">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5 class="card-title">
                                            <a href="/specialist/${favorite.specialistId}" class="company-link">${favorite.companyName}</a>
                                        </h5>

                                       <a href="/favourites/delete/${favorite.specialistId}">
                                        <span class="delete-icon" style="color: black;">
                                            <i class="fas fa-trash-alt"></i>
                                        </span>
                                       </a>
                                    </div>
                                    <p class="card-text">
                                        <span class="company-city">${favorite.city}</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </#list>
                    <#if favourites?size == 0>
                        <div class="empty-favorites text-center" style="background-color: rgba(0, 123, 255, 0.6); border-radius: 10px; padding: 20px;">
                            <i class="fas fa-info-circle text-light" style="font-size: 48px;"></i>
                            <h3 class="text-light">Избранные пусты</h3>
                        </div>
                    </#if>

                </div>
            </div>
        </div>
    </div>
</@main.layout>

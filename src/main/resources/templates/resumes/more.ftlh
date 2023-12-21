<#import '../layout.ftlh' as main>
<@main.layout>
    <title>Резюме</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../../static/css/resume_more.css">
    <div class="header shadow">
        <a href="javascript:history.go(-1);" class="back-button">
            <i class="fas fa-arrow-left"></i>Назад
        </a>
    </div>

    <div id="content" class="content">
        <div class="resume">
            <#if resume.name?has_content>
                <h1 class="resume-name">${resume.name}</h1>
            <#else>
                <h1 class="resume-name">Без заголовок</h1>
            </#if>
            <div class="resume-category">
                <#if resume.category??>
                    <i class="fas fa-user-tie"></i>Категория: ${resume.category}
                <#else>
                    <i class="fas fa-user-tie"></i> <p class="no-content">Категория: не найдено</p>
                </#if>
            </div>
            <p class="resume-description">
                <#if resume.resumeDescription??>
                    <i class="fas fa-info-circle"></i>Описание: ${resume.resumeDescription}
                <#else>
                <i class="fas fa-info-circle"></i> <p class="no-content">Описание: Без описания</p>
                </#if>
            </p>
            <div class="resume-phone">
                <#if businessCard??>
                    <#if businessCard?has_content>
                        <#list businessCard as it>
                            <p class="margin-left-div">
                                <#if it.contactType == "Telegram">
                                    <span class="social-icon"><i class="fa-brands fa-telegram" style="color: #0056d6;"></i></span>
                                <#elseif it.contactType == "Instagram">
                                    <span class="social-icon"><i class="fa-brands fa-instagram" style="color: #ff40ff;"></i></span>
                                <#elseif it.contactType == "WhatsApp">
                                    <span class="social-icon"><i class="fa-brands fa-whatsapp" style="color: #669c35;"></i></span>
                                <#elseif it.contactType == "Facebook">
                                    <span class="social-icon"><i class="fa-brands fa-facebook" style="color: #0042aa;"></i></span>
                                <#elseif it.contactType == "TikTok">
                                    <span class="social-icon"><i class="fa-brands fa-tiktok"></i></span>
                                <#elseif it.contactType == "LinkedIn">
                                    <span class="social-icon"><i class="fa-brands fa-linkedin" style="color: #0056d6;"></i></span>
                                <#elseif it.contactType == "Email">
                                    <span class="social-icon"><i class="fa-solid fa-envelope"></i></span>
                                <#elseif it.contactType == "Телефон">
                                    <span class="social-icon"><i class="fa-solid fa-phone"></i></span>
                                <#elseif it.contactType == "ВКонтакте">
                                    <span class="social-icon"><i class="fa-brands fa-vk" style="color: #0042aa;"></i></span>
                                <#elseif it.contactType == "Одноклассники">
                                    <span class="social-icon"><i class="fa-brands fa-odnoklassniki" style="color: #d29d00;"></i></span>
                                <#elseif it.contactType == "Другое">
                                    <span class="social-icon">Др.</span>
                                </#if>
                                : ${it.contactValue}</p>
                        </#list>
                    </#if>
                <#else>
                    <#if resume.phoneNumber??>
                        <i class="fas fa-phone"></i> Телефон: <a href="/tel+${resume.phoneNumber}">${resume.phoneNumber}</a>
                    <#else>
                        <i class="fas fa-phone"></i> Телефон: <p class="no-content">телефон номер не указан</p>
                    </#if>
                </#if>
            </div>
            <div class="resume-buttons">
                <a href="#" class="view-button">Написать</a>
                <#if resume.phoneNumber??>
                    <a href="/tel+${resume.phoneNumber}" class="view-button">Позвонить</a>
                <#else>
                    <a class="view-button disabled">Позвонить</a>
                </#if>
            </div>
        </div>
    </div>
</@main.layout>
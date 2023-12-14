<#import '../layout.ftlh' as main>
<@main.layout>
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
                <#if resume.phoneNumber??>
                    <i class="fas fa-phone"></i> Телефон: <a href="tel+${resume.phoneNumber}">${resume.phoneNumber}</a>
                <#else>
                    <i class="fas fa-phone"></i> Телефон: <p class="no-content">телефон номер не указан</p>
                </#if>
            </div>
            <div class="resume-buttons">
                <a href="#" class="view-button">Написать</a>
                <#if resume.phoneNumber??>
                    <a href="tel+${resume.phoneNumber}" class="view-button">Позвонить</a>
                <#else>
                    <a class="view-button disabled">Позвонить</a>
                </#if>
            </div>
        </div>
    </div>
</@main.layout>
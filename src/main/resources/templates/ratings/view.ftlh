<#import '../layout.ftlh' as main>
<@main.layout>
<title>Отзывы</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        color: #333;
        margin: 0;
        padding: 0;
    }

    header {
        background-color: #007bff;
        color: white;
        text-align: center;
        padding: 10px 0;
    }

    .container {
        max-width: 800px;
        padding: 10px;
        margin: 50px auto 0;
    }

    .reviews {
        margin-top: 10px;
    }

    .review {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
        padding: 15px;
        margin-bottom: 10px;
    }

    .review h3 {
        color: #007bff;
    }

    .review p {
        margin-bottom: 3px;
    }

    .rating {
        display: flex;
        align-items: center;
    }

    .star {
        color: #ffc107;
        margin-right: 5px;
    }

    .review .date {
        color: #868e96;
    }

    #closeButton {
        position: absolute;
        top: 5px;
        right: 10px;
        cursor: pointer;
        font-size: 50px;
        color: #007bff;
        background: none;
        border: none;
        outline: none;
    }

    #closeButton:hover {
        color: #333;
    }

    @media screen and (min-width: 769px) {
        #closeButton {
            position: absolute;
            top: 5px;
            right: 29%;
            cursor: pointer;
            font-size: 50px;
            color: #007bff;
            background: none;
            border: none;
            outline: none;
        }
    }
</style>
</head>
<body>

<div class="container">
    <button id="closeButton" onclick="goBack()">&#215;</button>

    <div class="reviews">
        <#if reviews?has_content>
            <#list reviews as review>
                <#if review.reviewText?has_content>
                    <div class="review">
                        <#assign notActiveCountOfStars = 5 - review.ratingValue?number>
                        <div class="rating">
                            <#list 1..review.ratingValue as rating>
                                <span class="star">&#9733;</span>
                            </#list>
                            <#if notActiveCountOfStars != 0>
                                <#list 1..notActiveCountOfStars as notActive>
                                    <span class="star">&#9734;</span>
                                </#list>
                            </#if>
                        </div>
                        <p>${review.reviewText}</p>
                        <p class="date">${review.ratingDate}</p>
                    </div>
                </#if>
            </#list>
        <#else>
            <h4 class="text-center pt-5">Отзывы не найдены</h4>
        </#if>
    </div>

</div>
<script>
    function goBack() {
        history.go(-1);
    }
</script>
</@main.layout>

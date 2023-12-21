<#import "../layout.ftlh" as main>
<@main.layout>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
            crossorigin="anonymous"></script>
    <style>
    </style>

    <div class="container">
        <div class="portfolio-container mt-5">
            <#if portfolio.title??>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>

                <h2>${portfolio.title}</h2>
            <#else>
                <h2 class="mt-3 text-center">Без заголовка</h2>
            </#if>
            <div id="carouselExample" class="carousel slide mb-5">
                <#if portfolio.photos?has_content>
                    <#list portfolio.photos as photo>
                        <div class="carousel-inner mt-1">
                            <div class="carousel-item active">
                                <img src="${photo.photoLink}" class="d-block w-100" alt="...">
                            </div>
                        </div>
                    </#list>
                </#if>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample"
                        data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselExample"
                        data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
            <#if portfolio.timeOfPortfolio??>
                <p>${portfolio.timeOfPortfolio}</p>
            </#if>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
            integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
            integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
            crossorigin="anonymous"></script>
    <script>
        $(document).ready(function () {
            $('.carousel').slick({
                infinite: true,
                slidesToShow: 1,
                slidesToScroll: 1,
                swipeToSlide: true,
                prevArrow: $('.slick-prev'),
                nextArrow: $('.slick-next')
            });
        });
    </script>
</@main.layout>


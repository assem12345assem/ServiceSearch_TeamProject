<#import '../layout.ftlh' as main>
<@main.layout>
    <header>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </header>
    <style>
        .title {
            font-weight: bold;
            padding: 10px;
            border-bottom: 1px solid #ccc;
            cursor: pointer;
        }

        .title:hover {
            color: mediumpurple;
        }
        .dark-theme .title:hover {
            color: black;
        }

        .specialists-list {
            display: none;
            margin-top: 10px;
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .dark-theme .specialists-list {
            background-color: #555;
        }

        .string-item {
            margin-bottom: 5px;
        }
        .dark-theme .string-item{
            color: white;
        }
.string-item:hover {
    background-color: #2552e7;
    color: white;
}
.dark-theme .string-item:hover {
    background-color: whitesmoke;
    color: black;
}
        .string-list {
            padding: 30px;
            margin-bottom: 20px;
        }


        .link-item {
            text-decoration: none;
            color: black;
        }
        .dark-theme .link-item {
            color: white;
        }
        .dark-theme .link-item:hover{
            color: black;
        }
        .title {
            font-weight: bold;
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }

        .hidden {
            display: none;
        }


        .search-button {
            padding: 10px;
            background-color: #2552e7;
            border: none;
            border-radius: 5px;
            color: #fff;
            cursor: pointer;
        }

        .list-names {
            display: none;
        }
        .dark-theme .list-names a{
            color: white
        }

        .empty-message {
            color: #888;
        }
        .dark-theme .card-body {
            background-color: #333;
            color: #fff;
        }
    </style>
    <div class="p-5">
        <div class="searchBox">
            <input type="text" class="searchInput" id="search" placeholder="Поиск...">
            <#--            <button class="search-button"><i class="fas fa-search"></i></button>-->
        </div>
        <div>
            <#if searchResults??>
                <#list searchResults as item>
                    <a href="/specialist/${item.id}" class="list-names"><#if (item.name)??>${item.name}</#if></a>
                </#list>
            </#if>
        </div>
        <div class="string-list">
            <#if contacts??>
                <#list contacts as item>
                    <div class="string-group">
                        <div class="title" data-category="${item.category}">
                            # ${item.category}
                        </div>
                        <div class="specialists-list">
                            <#if item.specialists?size gt 0>
                                <div class="card card-body">
                                    <#list item.specialists as s>
                                        <div class="string-item">
                                            <a href="/specialist/${s.id}" class="link-item">${s.name}</a>
                                        </div>
                                    </#list>
                                </div>
                            <#else>
                                <div class="card card-body empty-message">
                                    Нет специалистов в данной категории.
                                </div>
                            </#if>
                        </div>
                    </div>
                </#list>
            </#if>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const titles = document.querySelectorAll('.title');

            titles.forEach(title => {
                title.addEventListener('click', () => {
                    const specialistsList = title.nextElementSibling;
                    specialistsList.style.display = (specialistsList.style.display === 'none' || specialistsList.style.display === '') ? 'block' : 'none';
                });
            });

            const searchInput = document.getElementById('search');
            const listNames = document.querySelectorAll('.list-names');

            searchInput.addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();
                listNames.forEach(item => {
                    const name = item.innerText.toLowerCase();
                    if (name.includes(searchTerm)) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });

                if (searchTerm === '') {
                    listNames.forEach(item => {
                        item.style.display = 'none';
                    });
                }
            });

            listNames.forEach(item => {
                item.addEventListener('click', function (event) {
                    event.preventDefault();
                    window.location.href = this.getAttribute('href');
                });
            });
        });
    </script>

</@main.layout>
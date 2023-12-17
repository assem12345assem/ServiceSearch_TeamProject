<#import "../layout.ftlh" as main>
<@main.layout>
    <title>Создать новое портфолио</title>
    <a href="javascript:history.go(-1);" class="back-button">
        <i class="fas fa-arrow-left"></i>Назад
    </a>
    <div class="container">
    <h1 class="text-center">Создать портфолио</h1>
    <div class="bordered">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

        <label for="title">Введите название</label>
        <input type="text" name="title" id="title" class="w-100 my-3 form-control">

        <label for="fileInput" class="btn btn-primary">Загрузите фото и видео</label> <br>
        <input type="file" accept="image/*" class="my-3 fileInput" id="fileInput"
               style="visibility:hidden;">

        <button class="btn btn-primary text-center" type="submit" id="submitBtn">Сохранить</button>
    </div>

    <div class="preview bordered" id="preview"></div>
    <script>
        const photos = [];
        const formData = new FormData();

        document.querySelector('#submitBtn').addEventListener('click', function () {
            const csrfToken = document.querySelector('input[name="_csrf"]').value;
            const title = document.getElementById('title').value;
            formData.append('title', title);

            fetch('/portfolio/new', {
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': csrfToken
                },
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    console.log('Data sent successfully:', data);
                    window.location.href = '/profile';

                })
                .catch(error => {
                    console.error('Error sending data:', error);
                });
        });

        document.querySelectorAll('#fileInput').forEach(function (input) {
            input.addEventListener('change', function (event) {
                const previewElement = document.getElementById('preview');
                const files = event.target.files;

                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    const reader = new FileReader();
                    photos.push(file);
                    formData.append('photos', file);

                    reader.onload = function () {
                        const previewItem = document.createElement('div');
                        previewItem.classList.add('preview-item');
                        if (file.type.startsWith('image/')) {
                            const img = document.createElement('img');
                            img.src = reader.result;
                            img.setAttribute('data-index', i);
                            previewItem.appendChild(img);
                        } else if (file.type.startsWith('video/')) {
                            const video = document.createElement('video');
                            video.src = reader.result;
                            video.controls = true;
                            previewItem.appendChild(video);
                        }
                        previewElement.appendChild(previewItem);
                    }

                    reader.readAsDataURL(file);
                }
            });
        });

    </script>
    <style>
        .container {
            padding: 40px;
        }

        .bordered {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            margin: 20px;
        }

        .preview {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .preview-item {
            position: relative;
            border: 2px solid #ccc;
            margin: 5px;
            width: 100%;
            text-align: center;
        }

        .preview img {
            max-width: 100%;
            max-height: 100%;
        }

        .preview video {
            max-width: 100%;
        }

        .back-button{
            padding: 15px;
        }
    </style>
</@main.layout>
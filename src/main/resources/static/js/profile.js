$(document).ready(function () {
    $("#resume-content").show();
    $("#resume-tab").addClass("active");

    $("#resume-tab").click(function () {
        $(".tab-item").removeClass("active");
        $(this).addClass("active");
        $(".tab-content").hide();
        $("#resume-content").show();
    });

    $("#portfolio-tab").click(function () {
        $(".tab-item").removeClass("active");
        $(this).addClass("active");
        $(".tab-content").hide();
        $("#portfolio-content").show();
    });
});

const xCloseButton = document.getElementById("close-button").addEventListener("click", closeModal)

document.getElementById("close-button").addEventListener("click", function () {
    document.getElementById("side-menu").classList.remove("active");
});

function openModal() {
    document.getElementById("modal").style.display = "block";
}

function closeModal() {
    document.getElementById("modal").style.display = "none";
}

window.onclick = function (event) {
    var modal = document.getElementById("modal");
    if (event.target === modal) {
        closeModal();
    }
};


let ratingNum = document.getElementById("rating").textContent
ratingNum = ratingNum.replace(",", ".");

const rating = Math.round(parseFloat(ratingNum));
const maxRating = 5;

const ratingContainer = document.querySelector('.rating');
const stars = ratingContainer.querySelectorAll('.star');
const successNotification = document.getElementById("notification");

for (let i = 0; i < maxRating; i++) {
    if (i < rating) {
        stars[i].classList.add('active');
    } else {
        stars[i].classList.remove('active');
    }
}


const shareButtons = document.querySelectorAll('.share-button');

shareButtons.forEach(button => {
    button.addEventListener('click', () => {
        const url = window.location.href;
        const platform = button.classList[1];

        let shareUrl;
        switch (platform) {
            case 'facebook':
                shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`;
                break;
            case 'twitter':
                shareUrl = `https://twitter.com/share?url=${encodeURIComponent(url)}`;
                break;
            case 'linkedin':
                shareUrl = `https://www.linkedin.com/shareArticle?url=${encodeURIComponent(url)}`;
                break;
            case 'pinterest':
                shareUrl = `https://pinterest.com/pin/create/button/?url=${encodeURIComponent(url)}`;
                break;
            case 'whatsapp':
                shareUrl = `https://api.whatsapp.com/send?text=${encodeURIComponent(url)}`;
                break;
        }

        window.open(shareUrl, '_blank');
    });
});

document.getElementById("openModalRating").addEventListener("click", function () {
    openModalRating();
});

document.getElementById("close-button").addEventListener("click", function () {
    document.getElementById("side-menu").classList.remove("active");
});

function openModalRating() {
    document.getElementById("openModalRating").style.display = "none";
    document.getElementById("modalRating").style.display = "block";
}

function closeModalRating() {
    document.getElementById("openModalRating").style.display = "block";
    document.getElementById("modalRating").style.display = "none";

}

window.onclick = function (event) {
    var modal = document.getElementById("modalRating");
    if (event.target === modal) {
        closeModalRating();
    }
};

function submitReview() {
    const specialistId = document.getElementById("specialistId")
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');

    var rating = $("input[name='fst']:checked").val();
    var review = $("#review-input");

    var url = "/api/rating/new/" + specialistId.value;

    var data = {
        ratingValue: rating,
        reviewText: review.val()
    };

    if (validateForm()){
        $.ajax({
            type: "POST",
            url: url,
            data: JSON.stringify(data),
            contentType: "application/json",
            headers: {[csrfHeader]: csrfToken},
            success: function (response) {
                closeModalRating()
                showSuccessNotification(response, true);
                console.log("Отзыв успешно отправлен:", response);
            },
            error: function (error) {
                closeModalRating()
                showSuccessNotification(error.responseText, false);
                console.error("Ошибка при отправке отзыва:", error);
            }
        });
    }
}

function showSuccessNotification(message, isResponseOk){
    if (!message){
        if (isResponseOk){
            successNotification.textContent = "Отзыв сохранен"
        } else if (!isResponseOk){
            successNotification.textContent = "Ошибка при отправке отзыва"
            successNotification.classList.add("notificationError");
        }
    } else{
        successNotification.textContent = message
    }

    if (!isResponseOk){
        successNotification.classList.add("notificationError");

    }
    successNotification.classList.add("show");
    setTimeout(() => {
        successNotification.classList.remove("show");
    }, 3000);
}
function validateForm() {
    var fstValue = document.querySelector('input[name="fst"]:checked').value;
    var reviewText = document.getElementById('review-input').value;

    console.log("value of the rating ")
    console.log("value of the rating ", fstValue)
    if (fstValue < 1 || fstValue > 5) {
        alert("Пожалуйста, введите рейтинг от 1 до 5");
        return false;
    }

    return true;
}
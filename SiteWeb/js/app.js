const slideItems = document.querySelectorAll(".products_images");
const nombreItems = slideItems.length;
const nextArrow = document.querySelector(".right_arrow");
const previousArrow = document.querySelector(".left_arrow");
let current = 0;

function nextSlideShow() {
    slideItems[current].classList.remove("active");

    if(current < nombreItems - 1) {
        current++;
    } else {
        current = 0;
    }

    slideItems[current].classList.add("active");
}

function previousSlideShow() {
    slideItems[current].classList.remove("active");

    if(current > 0) {
        current--;
    } else {
        current = nombreItems - 1;
    }

    slideItems[current].classList.add("active");
}


nextArrow.addEventListener("click", () => nextSlideShow());
previousArrow.addEventListener("click", () => previousSlideShow());
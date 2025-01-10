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
nextArrow.addEventListener("click", () => nextSlideShow()); 

function previousSlideShow() {
    slideItems[current].classList.remove("active");

    if(current > 0) {
        current--;
    } else {
        current = nombreItems - 1;
    }

    slideItems[current].classList.add("active");
}

previousArrow.addEventListener("click", () => previousSlideShow());

const checkInput = document.getElementById("validate_check") ;
checkInput.checked = false ;
const validateButton = document.getElementById("button-validate")
validateButton.disable = true

if(validateButton.disable = true && !checkInput.checked){
    validateButton.style.color= " #fff" ;
    validateButton.style.border= "2px solid  rgb(54, 56, 54)" ;
    validateButton.style.backgroundColor= " #c7b7b7" ;
}


checkInput.addEventListener('click', ()=>{
    if(checkInput.checked){
        validateButton.disable = false ;

        validateButton.style.color= " #000" ;
        validateButton.style.border= "2px solid  rgb(36,211, 54)" ;
        validateButton.style.backgroundColor= " #fff" ;
    }else{
        validateButton.disable = true ;
        validateButton.style.color= " #fff" ;
        validateButton.style.border= "2px solid  rgb(54, 56, 54)" ;
        validateButton.style.backgroundColor= " #c7b7b7" ;   
    }
})

validateButton.addEventListener('click' , ()=>{
    if(validateButton.disable){
        alert("veuillez accepter les conditions d'utilisations")
    }else{
        window.open("livraison.php","_blank")
    }
    
})


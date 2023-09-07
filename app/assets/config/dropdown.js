var dropdown = document.getElementsByClassName("dropbtn")[0];

var dropdownContent = document.getElementsByClassName("dropdown-content")[0];

dropdown.addEventListener("click", function () {

    if (dropdownContent.style.display === "none") {
        dropdownContent.style.display = "block";
    } else {
        dropdownContent.style.display = "none";
    }
});

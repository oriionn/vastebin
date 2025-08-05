function isValueInvalid(value) {
    return value === "" || value === undefined || value === null
}

function showError(text) {
    const errorEl = document.getElementById("error");
    errorEl.innerText = text;
}

function redirect(url) {
    window.location.href = "/dashboard";
}

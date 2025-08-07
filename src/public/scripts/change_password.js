const submit = document.getElementById("submit");
const passwordEl = document.getElementById("password");
const confirmPasswordEl = document.getElementById("confirm_password");

submit.addEventListener("click", async () => {
    let password = passwordEl.value;
    let confirmPassword = confirmPasswordEl.value;
    if (password !== confirmPassword) return showError("Password and confirm password are not the same.");

    let res = await fetch(`/api/password`, {
        method: "POST",
        headers: {
            'Content-Type': "application/json",
            Authorization: `Bearer ${localStorage.getItem("session")}`
        },
        body: JSON.stringify({
            password
        })
    });

    let json = await res.json();
    if (res.status !== 200) return showError(JSON.parse(json).message);
    localStorage.removeItem("session")
    window.location.href = "/";
})
const submit = document.getElementById("submit");
const usernameEl = document.getElementById("username");
const passwordEl = document.getElementById("password");

submit.addEventListener("click", async () => {
    let username = usernameEl.value;
    let password = passwordEl.value;

    if (isValueInvalid(username) || isValueInvalid(password)) return showError("Invalid username or password.");
    if (username.includes(" ")) return showError("Invalid username or password");

    let res = await fetch(`/api/sign-in`, {
        method: "POST",
        headers: {
            'Content-Type': "application/json"
        },
        body: JSON.stringify({
            username,
            password
        })
    });

    let json = await res.json();
    if (res.status !== 200) return showError(JSON.parse(json).message);

    localStorage.setItem("session", json.message);
    window.location.href = "/dashboard";
})

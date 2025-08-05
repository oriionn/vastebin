const submit = document.getElementById("submit");
const usernameEl = document.getElementById("username");
const usernameLabelEl = document.querySelector("label[for='username']")
const passwordEl = document.getElementById("password");
const confirmPasswordEl = document.getElementById("confirm_password")

usernameEl.addEventListener("input", async () => {
    let username = usernameEl.value;
    if (username !== "") {
        let available = await isUsernameAvailable(username);

        let label = usernameLabelEl.getAttribute("data-label")
        if (available) {
            usernameLabelEl.innerHTML = `${label} (Available)`
        } else {
            usernameLabelEl.innerHTML = `${label} (Unavailable)`
        }
    }
});


submit.addEventListener("click", async () => {
    let username = usernameEl.value;
    let password = passwordEl.value;
    let confirmPassword = confirmPasswordEl.value;

    if (password !== confirmPassword) return showError("Password and confirm password are not the same.");
    if (isValueInvalid(username) || isValueInvalid(password)) return showError("Invalid username or password.");
    if (username.includes(" ")) return showError("Invalid username or password");
    if (!(await isUsernameAvailable(username))) return showError("Username unavailable");

    let res = await fetch(`/api/sign-up`, {
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

async function isUsernameAvailable(username) {
    let res = await fetch(`/api/username?u=${username}`);
    if (!res.ok) {
        return false
    }

    let json = await res.json();
    if (json.status !== 200) return false;

   return json.message === "true";
}

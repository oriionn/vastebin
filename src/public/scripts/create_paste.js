const submit = document.getElementById("submit");
const textarea = document.querySelector("textarea");

submit.addEventListener("click", async () => {
    let content = textarea.value;
    if (content.length <= 0) {
        return showError("No content");
    }

    let res = await fetch("/api/paste", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${localStorage.getItem("session")}`
        },
        body: JSON.stringify({
            content
        })
    });

    let json = await res.json();
    if (res.status !== 200) return showError(JSON.parse(json).message);
    redirect(`/paste/${json.message}`)
});

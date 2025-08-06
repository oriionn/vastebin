const header = document.querySelector("h1");

async function init_dashboard() {
    let res = await fetch(`/api/me`, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem("session")}`
        }
    });

    if (res.status !== 200) {
        localStorage.removeItem("session");
        return redirect("/")
    }

    let json = await res.json();
    let content = header.getAttribute("data-text");
    content = content.replaceAll("{username}", json.message);

    header.innerText = content;
}

init_dashboard()

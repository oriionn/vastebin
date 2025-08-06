async function init() {
    let session = localStorage.getItem("session");
    if (!session) return redirect("/");

    let res = await fetch(`/api/session`, {
        headers: {
            Authorization: `Bearer ${session}`
        }
    });

    if (!res.ok) return redirect("/");
    let json = await res.json();
    if (json.message === "true") return;

    return redirect("/");
}

init()

async function init() {
    let session = localStorage.getItem("session");
    if (!session) return;

    let res = await fetch(`/api/session`, {
        headers: {
            Authorization: `Bearer ${session}`
        }
    });

    if (!res.ok) return;
    let json = await res.json();

    if (json.message !== "true") return;

    return redirect("/dashboard");
}

init()

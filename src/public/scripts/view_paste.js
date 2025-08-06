const textarea = document.querySelector("textarea");
const raw = document.getElementById("raw");
const copy = document.getElementById("copy");

raw.addEventListener("click", () => {
    return redirect(`/raw/${id}`);
});

copy.addEventListener("click", () => {
    navigator.clipboard.writeText(textarea.value).catch(() => showError("A error occurred when added the content to your clipboard..."))
});

async function init_view() {
    let res = await fetch(`/raw/${id}`);
    if (!res.ok) return redirect(`/raw/${id}`);
    if (res.status !== 200) return redirect(`/raw/${id}`);

    textarea.value = await res.text();
}

init_view();
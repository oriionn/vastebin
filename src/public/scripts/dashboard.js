const header = document.querySelector("h1");
const tbody = document.querySelector("tbody");

async function init_dashboard() {
    await edit_header();
    await edit_table();
}

async function edit_header() {
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

    header.textContent = content;
}

async function edit_table() {
    let res = await fetch(`/api/paste`, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem("session")}`
        }
    });

    if (res.status !== 200) return;
    let json = await res.json();
    if (json.data.length === 0) return;
    
    tbody.innerHTML = "";
    json.data.forEach(paste => {
        let tr = document.createElement("tr");
        let tdId = document.createElement("td");
        let tdViews = document.createElement("td");
        let tdCreatedAt = document.createElement("td");
        let tdActions = document.createElement("td");
        
        tdId.textContent = paste.id;
        tdViews.textContent = paste.views;
        tdCreatedAt.textContent = dayjs(paste.created_at * 1000).local().format('DD/MM/YYYY HH:mm:ss');

        let viewAction = document.createElement("a");
        viewAction.href = `/paste/${paste.id}`;
        viewAction.textContent = "View";
        viewAction.target = "_blank";
        
        let deleteAction = document.createElement("a");
        deleteAction.href = `/actions/delete?id=${paste.id}`;
        deleteAction.textContent = "Delete";

        tdActions.appendChild(viewAction);
        tdActions.appendChild(deleteAction);
        tdActions.classList.add("actions");


        tr.appendChild(tdId);
        tr.appendChild(tdViews);
        tr.appendChild(tdCreatedAt);
        tr.appendChild(tdActions);

        tbody.appendChild(tr);
    });
}

init_dashboard()

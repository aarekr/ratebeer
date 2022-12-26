const BREWERIES = {};

const handleResponse = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  const breweryname = tr.appendChild(document.createElement("td"));
  breweryname.innerHTML = brewery.name;
  const year = tr.appendChild(document.createElement("td"));
  year.innerHTML = brewery.year
  const total = tr.appendChild(document.createElement("td"));
  total.innerHTML = brewery.total.number
  const status = tr.appendChild(document.createElement("td"));
  status.innerHTML = brewery.active
  
  return tr;
};

BREWERIES.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach((brewery) => {
    const tr = createTableRow(brewery);
    table.appendChild(tr);
  });
};

BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BREWERIES.sortByYear = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year - b.year;
  });
};

BREWERIES.sortByTotal = () => {
  BREWERIES.list.sort((a, b) => {
    return b.total.number - a.total.number;
  });
};

const breweries = () => {
  if (document.querySelectorAll("#brewerytable").length < 1) return;
  var request = new XMLHttpRequest();
  request.onload = handleResponse;
  request.open("get", "breweries.json", true);
  request.send();

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByName();
    BREWERIES.show();
  });

  document.getElementById("year").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByYear();
    BREWERIES.show();
  });

  document.getElementById("total").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByTotal();
    BREWERIES.show();
  });

  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleResponse);
};

export { breweries };
